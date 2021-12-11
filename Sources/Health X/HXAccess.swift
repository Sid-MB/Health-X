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
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Int, Swift.Error>) in
            let query = HKStatisticsQuery(quantityType: HKQuantityType(.stepCount), quantitySamplePredicate: HXPredicate.Time.today, options: .cumulativeSum) { (query, possibleStats, possibleError) in
                guard let statistics = possibleStats else {
                    continuation.resume(throwing: QueryError.nilStatistics)
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
    
    enum QueryError: Swift.Error {
        case nilStatistics, nilSum
    }
}
