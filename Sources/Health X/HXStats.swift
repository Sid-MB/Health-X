//
//  HXStats.swift
//  
//
//  Created by Siddharth M. Bhatia on 11/10/21.
//

import HealthKit
import Combine


/// An object holding all available health information and the methods to update it.
/// Also works with `HXAccess` to retrieve authorization for data types.
public class HXStats: ObservableObject {
    
    @Published public var stepCount: Int?
    
    public init() {
        self.store = HKHealthStore.init()
        access = HXAccess(store: store)
    }

    private var store: HKHealthStore
    private var access: HXAccess
    
    // TODO: Updates automatically, @Published automatically fired.
    public func update() async {
        do {
            let newStepVal = try await access.getSteps()
            DispatchQueue.main.async {
                self.stepCount = newStepVal
                ///*Publishing changes from background threads is not allowed; make sure to publish values from the main thread (via operators like receive(on:)) on model updates.
            }
        } catch {
            switch error {
            case HXAccess.QueryError.authAttempted:
                print("Authorization was attempted automatically.")
            default:
                assertionFailure(error.localizedDescription)
            }
        }
    }
}
