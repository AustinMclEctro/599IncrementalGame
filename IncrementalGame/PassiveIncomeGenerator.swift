//
//  PassiveIncomeGenerator.swift
//  IncrementalGame
//
//  Created by Michael Lee on 2017-10-30.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import Foundation


/// An object that is used to generate passive income for a zone.
class PassiveIncomeGenerator {
    
    // MARK: Properties
    var rate: Int
    var gameState: GameState
    
    init(defaultRate: Int, gameState: GameState) {
        self.rate = defaultRate
        self.gameState = gameState
    }
    
    // TODO: Create method to get all zones and add their passive income rates
    
    /// Calculates the income that was generated while the
    /// game was not active.
    func calculateIdleIncome() {
        
    }
}
