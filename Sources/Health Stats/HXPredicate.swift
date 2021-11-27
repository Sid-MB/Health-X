//
//  HXPredicate.swift
//  
//
//  Created by Siddharth M. Bhatia on 11/10/21.
//

import Foundation
import HealthKit

struct HXPredicate {
    @available(*, unavailable) private init() {}

    struct Time {
        @available(*, unavailable) private init() {}
        
        static var today: NSPredicate {
            let calendar = Calendar.current

            let components = calendar.dateComponents([.year, .month, .day], from: .now)

            guard let startDate = calendar.date(from: components) else {
                fatalError("*** Unable to create the start date ***")
            }
             
            guard let endDate = calendar.date(byAdding: .day, value: 1, to: startDate) else {
                fatalError("*** Unable to create the end date ***")
            }

            let today = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
            return today
        }
    }
}
