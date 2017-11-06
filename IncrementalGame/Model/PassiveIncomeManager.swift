//
//  PassiveIncomeManager.swift
//  IncrementalGame
//
//  Created by Michael Lee on 2017-11-04.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import Foundation
import os.log

class PassiveIncomeManager {
    
    // MARK: Properties
    var updateInterval = 5
    var timer = Timer()
    
    // MARK: Initializers
    init() {
        
    }
    
    /// Calculates and collects the income earned by the given zones
    /// while the game was in the background (game was not open).
    ///
    func collectBackgroundIncome(zones: [Zone]) {
        var totalBackgroundIncome = 0
        for zone in zones {
            totalBackgroundIncome += zone.pIG.calculateBackgroundIncome()
        }
        
        incrementScore(amount: totalBackgroundIncome)
    }
    
    
    /// Starts a timer which collects the inactive income
    /// (when the game is being played but the zone is not being presented)
    /// for a set of provided zones. Updates the points in the info panel.
    ///
    /// - Parameter zones: The zones containing passive income generators.
    func startInactiveIncomeGenerator(zones: [Zone]) {
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(updateInterval), target: self, selector: #selector(collectInactiveIncome(_:)), userInfo: zones, repeats: true)
    }
    
    
    /// Collects the inactive income
    /// (when the game is being played but the zone is not being presented)
    /// for a set of provided zones. Updates the points in the info panel.
    ///
    /// - Parameter zones: The zones containing passive income generators.
    @objc private func collectInactiveIncome(_ timer: Timer) {
        let zones = timer.userInfo as! [Zone]
        var totalActiveIncome = 0
        for zone in zones {
            totalActiveIncome += zone.pIG.calculateInactiveIncome(inactiveMinutes: updateInterval)
        }
        
        print("Collecting inactive income: \(totalActiveIncome)")
        incrementScore(amount: totalActiveIncome)
    }
    
    
    /// Updates the score on the info panel
    ///
    /// - Parameter amount: The amount to increase the score.
    func incrementScore(amount: Int) {
        
    }
    
    
    /// Calculates the total rate at which a given set of zones generates
    /// inactive (zones not being presented while game is played) income.
    ///
    /// - Returns: The inactive income generation rate.
    func calculateInactiveIncomeRate(zones: [Zone]) -> Int {
        var totalRate = 0
        for zone in zones {
            totalRate += zone.pIG.inactiveRate
        }
        return totalRate
    }
    
    
    /// Fully turns on the passive income generators for a
    /// given set of zones.
    ///
    /// - Parameter zones: The zones containing passive income generators.
    func startPassiveIncomeGenerator(zones: [Zone]) {
        for zone in zones {
            zone.pIG.fullStart()
        }
    }
    
    
    /// Fully turns off the passive income generators for a
    /// given set of zones.
    ///
    /// - Parameter zones: The zones containing passive income generators.
    func stopPassiveIncomeGenerator(zones: [Zone]) {
        for zone in zones {
            zone.pIG.fullStop()
        }
    }
    
    
}
