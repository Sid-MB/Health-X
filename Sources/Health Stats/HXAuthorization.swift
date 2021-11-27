//
//  HXAuthorization.swift
//  
//
//  Created by Siddharth M. Bhatia on 11/10/21.
//

import HealthKit

struct HXAuthorization {
    var store: HKHealthStore
    
    /// Requests authorization for specified data types.
    /// - Returns:
    ///     A dictionary of data types requested and whether we have **write** access for that data type.
    ///     Apple does not provide an easy way to retrieve read authorization status.
    /// - Throws:
    /// The function throws the error from `requestAuthorization(toShare:read:completion)`, if there is one.
    @discardableResult func request(_ types: Set<HKSampleType>, permissions: Permissions) async throws -> [HKSampleType : Bool] {
        let requestRead = permissions.contains(.read)
        let requestWrite = permissions.contains(.write)
        
        let toShare = requestWrite ? types : nil
        let toRead = requestRead ? types : nil
        return try await withCheckedThrowingContinuation { continuation in
            store.requestAuthorization(toShare: toShare,
                                       read: toRead) {success, error in
                // `Success` is true if the prompt was successful, not if we actually recieved authorization.
                
                if let e = error {
                    continuation.resume(throwing: e)
                    return
                }
                
                // Return dictionary of allowed
                var allowedDict: [HKSampleType : Bool] = [:]
                types.forEach {
                    allowedDict[$0] = (store.authorizationStatus(for: $0) == .sharingAuthorized)
                }
                
                continuation.resume(returning: allowedDict)
            }
        }
    }
    
    struct Permissions: OptionSet, SetAlgebra {
        let rawValue: Int8
        
        static let read   = Self(rawValue: 1 << 0)
        static let write  = Self(rawValue: 1 << 1)

        static let both: Self = [.read, .write]
    }
}
