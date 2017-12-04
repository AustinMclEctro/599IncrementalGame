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
        static let defaultGeneral = 50
        static let defaultInactive = 50
        static let defaultBackground = 50
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
    private(set) var isOn = true
    var isInactiveGeneratorOn = true  // When the zone is not presented but the game is being played
    var isBackgroundGeneratorOn = true  // When the game is not being played
    
    // Timers
    var backgroundGeneratorStartTime = Date()
    var backgroundGeneratorStopTime = Date()
    
    // MARK: Initializers
    
    init(backgroundRate: Int, inactiveRate: Int, bGStartTime: Date = Date(), bGStopTime: Date = Date()) {
        self._backgroundRate = backgroundRate
        self._inactiveRate = inactiveRate
        
        super.init()
        
        // Subscribe to notifications
        NotificationCenter.default.addObserver(self, selector: #selector(startBackgroundGenerator), name: NSNotification.Name(rawValue: Notification.Name.willSaveGameState), object: nil)
    }
    
    
    /// Saves the date and time when the app goes to the background
    @objc func startBackgroundGenerator() {
        if isBackgroundGeneratorOn {
            backgroundGeneratorStartTime = Date()
        }
    }
    
    
    /// Saves the date and time when the app becomes active
    func stopBackgroundGenerator() {
        if isBackgroundGeneratorOn {
            backgroundGeneratorStopTime = Date()
        }
    }
    
    
    /// Calculates the amount of inactive indome (when the game is being played but the
    /// zone is not being presented) for a given duration by multiplying the inactive
    /// income rate by the amount of time.
    ///
    /// - Parameter inactiveSeconds: The number of seconds used to calculate the income.
    /// - Returns: The amount of points earned by the inactive income generator.
    func calculateInactiveIncome(inactiveSeconds: Int) -> Int {
        if isInactiveGeneratorOn {
            return inactiveSeconds * inactiveRate
        } else {
            return 0
        }
    }
    
    
    /// Calculates the income that was generated while the
    /// game was in the phone's background by multiplying the number of seconds
    /// the game spent in the background with the background rate.
    ///
    /// - Returns: Returns an integer representing the amount of points
    /// earned while the game was running in the background
    func calculateBackgroundIncome() -> Int {
        if isBackgroundGeneratorOn {
            let secondsInBackground = Int(backgroundGeneratorStopTime.timeIntervalSince(backgroundGeneratorStartTime))
            return secondsInBackground * backgroundRate
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
    
    func feed(portion: Int) {
        _inactiveRate += portion
        // QUESTION: Do we want to increase the background rate as well? Yes, for now.  Maybe go to just one rate eventually?
        _backgroundRate += portion
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notification.Name.inactiveIncomeRateChanged), object: nil, userInfo: nil)
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

