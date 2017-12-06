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
    
    var updateInterval = 3
    
    var gameState: GameState
    var isCollectingInactiveInc = false
    var timer = Timer()
    
    // MARK: Initializers
    
    init( gameState: GameState) {
        self.gameState = gameState
        
        // Subscribe to notifications
        NotificationCenter.default.addObserver(self, selector: #selector(onPigStart), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sendInactiveIncomeRate), name: NSNotification.Name(rawValue: Notification.Name.inactiveIncomeRateChanged), object: nil)
    }
    
    
    /// Callback method that is called when there has been an update in one of the
    /// passive income rates
    @objc func sendInactiveIncomeRate() {
        let data: [String: Int] = ["rate": calculateInactiveIncomeRate()]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notification.Name.inactiveIncomeRate), object: nil, userInfo: data)
    }
    
    
    /// Calculates and collects the income earned by the given zones
    /// while the game was in the background (game was not open). Also sends
    /// the inactive rate at startup.
    @objc func onPigStart() {
        sendInactiveIncomeRate()
        
        var totalBackgroundIncome = 0
        for zone in gameState.zones {
            zone.pIG.stopBackgroundGenerator()
            totalBackgroundIncome += zone.pIG.calculateBackgroundIncome()
        }
        
        print("Collecting background income: \(totalBackgroundIncome)")
        
        let data: [String: Int] = ["amount": totalBackgroundIncome]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notification.Name.backgroundIncomeEarned), object: nil, userInfo: data)
    }
    
    
    /// Starts a timer which collects the inactive income
    /// (when the game is being played but the zone is not being presented)
    /// for a set of provided zones. Updates the points in the info panel.
    func startInactiveIncomeGenerator() {
        if (!isCollectingInactiveInc) {
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(updateInterval), target: self, selector: #selector(collectInactiveIncome), userInfo: nil, repeats: true)
            isCollectingInactiveInc = true
        }
    }
    
    
    /// Pauses the inactive income generators for all the zones by stopping
    /// the timer.
    func pauseInactiveIncomeGenerator() {
        if (isCollectingInactiveInc) {
            timer.invalidate()
            isCollectingInactiveInc = false
        }
    }
    
    
    /// Collects the inactive income
    /// (when the game is being played but the zone is not being presented)
    /// for a set of provided zones. Updates the points in the info panel.
    /// Calculates the inactive income rate and sends it to the info panel.
    @objc private func collectInactiveIncome() {
        var totalActiveIncome = 0
        for zone in gameState.zones {
            totalActiveIncome += zone.pIG.calculateInactiveIncome(inactiveSeconds: updateInterval)
        }
        
        print("Collecting inactive income: \(totalActiveIncome)")
        
        let currencyChange: [String: Int] = ["amount": totalActiveIncome]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notification.Name.currencyChanged), object: nil, userInfo: currencyChange)
    }
    
    
    /// Calculates the total rate at which a given set of zones generates
    /// inactive (zones not being presented while game is played) income.
    func calculateInactiveIncomeRate() -> Int {
        var totalRate = 0
        for zone in gameState.zones {
            totalRate += zone.pIG.inactiveRate
        }
        return totalRate
    }
    
    
    /// Fully turns on the passive income generators for a
    /// given set of zones.
    ///
    /// - Parameter zones: The zones containing passive income generators.
    func startPassiveIncomeGenerator() {
        for zone in gameState.zones {
            zone.pIG.fullStart()
        }
    }
    
    
    /// Fully turns off the passive income generators for a
    /// given set of zones.
    ///
    /// - Parameter zones: The zones containing passive income generators.
    func stopPassiveIncomeGenerator() {
        for zone in gameState.zones {
            zone.pIG.fullStop()
        }
    }
}

