//
//  HXAccess.swift
//  
//
//  Created by Siddharth M. Bhatia on 11/10/21.
//

import HealthKit

struct HXAccess {
    var store: HKHealthStore
    
    func getSteps() async throws -> Int {
        let quantity = HKQuantityType(.stepCount)
        let requestAuthOnFailure = true
        
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Int, Swift.Error>) in
            let query = HKStatisticsQuery(quantityType: quantity, quantitySamplePredicate: HXPredicate.Time.today, options: .cumulativeSum) { (query, possibleStats, possibleError) in
                guard let statistics = possibleStats else {
                    // Arises from insufficent permissions too!
                    if (requestAuthOnFailure) {
                        Task {
                            print("Requesting auth")
                            do {
                                try await HXAuthorization.init(store: store).request([quantity], permissions: .read)
                                
                                // TODO: Build in a way to see if authorization failed.
                                print("Quantity authorization did not crash and burn! (Still may not be authorized, who knows..)")
                                
                                continuation.resume(throwing: QueryError.authAttempted)
                                
                                
                            } catch {
                                continuation.resume(throwing: QueryError.authFailed(error))
                            }
                            
                            
                            //                        continuation.resume(throwing: QueryError.nilStatistics)
                        }
                    }
                    return
                }
                
                guard let sum = statistics.sumQuantity() else {
                    continuation.resume(throwing: QueryError.nilSum)
                    return
                }
                let steps = Int(sum.doubleValue(for: .count()))
                continuation.resume(returning: steps)
            }
            store.execute(query)
        }
        
    }
    
    enum QueryError: Swift.Error, LocalizedError {
        case nilStatistics, nilSum
        case authFailed(Error?)
        case authAttempted
        
        public var errorDescription: String? {
            switch self {
            case .nilStatistics:
                return "HKStatisticsQuery statistics were nil. This error can arise from insufficent permissions."
            case .nilSum:
                return "HKStatisticsQuery's statistics.sumQuanitity was nil."
            case .authFailed(let e):
                return "Authorization was attempted and it failed. Error: \(e?.localizedDescription)"
            case .authAttempted:
                return "Authorization was attempted; we don't know if it succeeded. You can try again if you want."
            }
        }
    }
}

