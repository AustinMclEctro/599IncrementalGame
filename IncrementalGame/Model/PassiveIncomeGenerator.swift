//
//  PassiveIncomeGenerator.swift
//  IncrementalGame
//
//  Created by Michael Lee on 2017-10-30.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import Foundation


/// An object that is used to generate passive income for a zone.
class PassiveIncomeGenerator: NSObject, NSCoding {
    
    // MARK: Constants
    struct Rates {
        static let `default` = 5
    }
    
    // MARK: Properties
    var rate: Int
    
    override init() {
        self.rate = Rates.default
    }
    
    init(defaultRate: Int) {
        self.rate = defaultRate
    }
    
    // TODO: Create method to get all zones and add their passive income rates
    
    /// Calculates the income that was generated while the
    /// game was not active.
    func calculateIdleIncome() {
        
    }
    
    // MARK: NSCoding
    
    struct PropertyKey {
        static let rate = "rate"
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The currency is required. If we cannot decode a currency string, the initializer should fail.
        let rate = aDecoder.decodeInteger(forKey: PropertyKey.rate)
        
        self.init(defaultRate: rate)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(rate, forKey: PropertyKey.rate)
    }

}
