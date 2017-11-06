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
        static let `default` = 2
        static let inactive = 2
        static let background = 2
    }
    
    // MARK: Properties
    
    // Rates
    private var _backgroundRate: Int
    var backgroundRate: Int {
        get {
            return self.isBackgroundGeneratorOn ? self._backgroundRate : 0
        }
    }
    private var _inactiveRate: Int
    var inactiveRate: Int {
        get {
            return self.isInactiveGeneratorOn ? self._inactiveRate : 0
        }
    }
    
    // States
    private(set) var isOn = false
    var isInactiveGeneratorOn = false  // When the zone is not presented but the game is being played
    var isBackgroundGeneratorOn = false  // When the game is not being played

    // Timers
    var backgroundGeneratorStartTime: Date
    var backgroundGeneratorStopTime: Date
    
    // MARK: Initializers
    
    init(backgroundRate: Int, inactiveRate: Int, bGStartTime: Date = Date(), bGStopTime: Date = Date()) {
        self._backgroundRate = backgroundRate
        self._inactiveRate = inactiveRate
        self.backgroundGeneratorStartTime = bGStartTime
        self.backgroundGeneratorStopTime = bGStopTime
    }
    
    
    /// Calculates the amount of inactive indome (when the game is being played but the
    /// zone is not being presented) for a given duration by multiplying the inactive
    /// income rate by the amount of time.
    ///
    /// - Parameter inactiveMinutes: The number of minutes used to calculate the income.
    /// - Returns: The amount of points earned by the inactive income generator.
    func calculateInactiveIncome(inactiveMinutes: Int) -> Int {
        if isInactiveGeneratorOn {
            return inactiveMinutes * inactiveRate
        } else {
            return 0
        }
    }
    
    
    /// Calculates the income that was generated while the
    /// game was in the phone's background by multiplying the number of minutes
    /// the game spent in the background with the background rate.
    ///
    /// - Returns: Returns an integer representing the amount of points
    /// earned while the game was running in the background
    func calculateBackgroundIncome() -> Int {
        if isBackgroundGeneratorOn {
            let minutesInBackground = Int(floor((backgroundGeneratorStopTime.timeIntervalSince1970 - backgroundGeneratorStartTime.timeIntervalSince1970)/60)) // TODO: Check if minutes correct
            return minutesInBackground * backgroundRate
        } else {
            return 0
        }
    }
    
    
    /// Starts all generators in the passive income generator
    func fullStart() {
        self.isOn = true
        self.isBackgroundGeneratorOn = true
        self.isInactiveGeneratorOn = true
    }
    
    
    /// Stops all generators in the passive income generator
    func fullStop() {
        self.isOn = false
        self.isBackgroundGeneratorOn = false
        self.isInactiveGeneratorOn = false
    }
    
    
    // MARK: NSCoding
    
    
    struct PropertyKey {
        static let backgroundRate = "backgroundRate"
        static let inactiveRate = "inactiveRate"
        static let backgroundGeneratorStartTime = "backgroundGeneratorStartTime"
        static let backgroundGeneratorStopTime = "backgroundGeneratorStopTime"
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The currency is required. If we cannot decode a currency string, the initializer should fail.
        let backgroundRate = aDecoder.decodeInteger(forKey: PropertyKey.backgroundRate)
        let inactiveRate = aDecoder.decodeInteger(forKey: PropertyKey.inactiveRate)
        let backgroundGeneratorStartTime = aDecoder.decodeObject(forKey: PropertyKey.backgroundGeneratorStartTime) as! Date
        let backgroundGeneratorStopTime = aDecoder.decodeObject(forKey: PropertyKey.backgroundGeneratorStopTime) as! Date
        
        self.init(backgroundRate: backgroundRate, inactiveRate: inactiveRate, bGStartTime: backgroundGeneratorStartTime, bGStopTime: backgroundGeneratorStopTime)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(backgroundRate, forKey: PropertyKey.backgroundRate)
        aCoder.encode(inactiveRate, forKey: PropertyKey.inactiveRate)
        aCoder.encode(backgroundGeneratorStartTime, forKey: PropertyKey.backgroundGeneratorStartTime)
        aCoder.encode(backgroundGeneratorStopTime, forKey: PropertyKey.backgroundGeneratorStopTime)
    }

}
