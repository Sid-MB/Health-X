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
    
    public var stepCount: Int?
    
    internal init() {
        self.store = HKHealthStore.init()
        access = HXAccess(store: store)
    }

    private var store: HKHealthStore
    private var access: HXAccess

    func update() async {
        if let steps = try? await access.getSteps() {
            stepCount = steps
        }
    }
}
