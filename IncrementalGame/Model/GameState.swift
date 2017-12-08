//
//  GameState.swift
//  IncrementalGame
//
//  Created by Ben Grande on 2017-10-12.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import Foundation
import os.log


/// Used to store the game state. Includes data such as
/// currency and zones.
class GameState: NSObject, NSCoding {
    
    // MARK: Properties
    
    var currencyA: Int
    var zones: [Zone]
    var player: Player
    
    
    // MARK: Initializers
    
    
    init(_ startingCurrency: Int, _ existingZones: [Zone], _ player: Player) {
        self.currencyA = startingCurrency
        self.zones = existingZones
        self.player = player
    }
    
    
    // MARK: NSCoding
    
    
    // Archiving paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("gameState")
    
    
    struct PropertyKey {
        static let currencyA = "currencyA"
        static let zones = "zones"
        static let player = "player"
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The currency is required. If we cannot decode a currency string, the initializer should fail.
        let currencyA = aDecoder.decodeInteger(forKey: PropertyKey.currencyA)
        let zones = aDecoder.decodeObject(forKey: PropertyKey.zones) as! [Zone]
        let player = aDecoder.decodeObject(forKey: PropertyKey.player) as! Player
        
        self.init(currencyA, zones, player)
    }
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(currencyA, forKey: PropertyKey.currencyA)
        aCoder.encode(zones, forKey: PropertyKey.zones)
        aCoder.encode(player, forKey: PropertyKey.player)
    }
    
    
    func saveGameState() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(self, toFile: GameState.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("GameState successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save GameState...", log: OSLog.default, type: .error)
        }
    }
    
    
    static func loadGameState() -> GameState?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: GameState.ArchiveURL.path) as? GameState
    }
    
    
    /// Restores the game state back to a new game
    func restoreToDefault() {
        do {
            try FileManager.default.removeItem(at: GameState.ArchiveURL)
        } catch {
            os_log("No GameState to reset.", log: OSLog.default, type: .debug)
        }
    }
}

