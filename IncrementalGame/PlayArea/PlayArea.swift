//
//  PlayArea.swift
//  IncrementalGame
//
//  Created by Ben Grande on 2017-10-05.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit


/// A view primarily used as a container for the active zone.
class PlayArea: SKView {
    
    // MARK: Properties
    
    var zone: Zone
    var zoneNumber = 0
    var gameState: GameState
    var selectedNode: GameObject?;
    var pIGManager: PassiveIncomeManager

    // For edge pans to allow two scenes at once, with only one moving. See PlayAreaTouchEvents for more
    var tempImageZone: UIImageView?;
  
    
    // MARK: Initializers
    
    
    init(frame: CGRect, gameState: GameState) {
        self.gameState = gameState
        
        // Load zones if they exist, create zone 0 if it doesn't
        if gameState.zones.isEmpty {
            zone = Zone(size: frame.size, children: [], pIG: nil, allowedObjects: nil)
            gameState.zones.append(zone)
        } else {
            zone = gameState.zones[0]; // REFACTOR: Should zone zero be saved in the zones array?
        }
        
        // Passive Income generator
        pIGManager = PassiveIncomeManager(gameState: gameState)
        
        super.init(frame: frame)
        
        self.layer.cornerRadius = 75.0
        
        self.layer.masksToBounds = true
        
        setupTouchEvents()
        
        presentScene(zone)
        let data: [String: Zone] = ["zone": zone]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notification.Name.shapesChanged), object: nil, userInfo: data)
    }
    
    
    // MARK: Functions
    
    
    // Returns list of game objects within current zone.
    // TODO: Should implement as a cache instead?
    // - Return: list of game objects within current zone
    func getGameObjects() -> [GameObject] {
        var obs: [GameObject] = []
        for i in getZone().children {
            if let ob = i as? GameObject {
                obs.append(ob);
            }
        }
        return obs;
    }
    
    
    /// Selects and presents the specified zone.
    ///
    /// - Parameter index: The index number of the zone in the zones array.
    func selectZone(index: Int) {
        // Get and display newly selected zone
        zoneNumber = index
        zone = gameState.zones[zoneNumber]
        presentScene(zone)
        let data: [String: Zone] = ["zone": zone]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notification.Name.shapesChanged), object: nil, userInfo: data)
    }
    
    
    func getZone() -> Zone {
        return zone
    }
    
    
    // returns the price to add an additional zone
    func newZonePrice() -> Int {
        if gameState.zones.count < 17 {
            return Int(pow(2,Double(gameState.zones.count))) * 10000
        } else {
            return Int.max/2
        }
    }
    
    
    /// Increases value of currencyA from gameplay.
    ///
    /// - Parameter amount: The amount of points gained.
    func gained(amount: Int) { // REFACTOR: Combine this with updateCurrency in MasterView?
        // Change the name/delete as you like :) just left here to show how to add currency A
        if let controller = superview as? MasterView {
            controller.updateCurrencyA(by: amount);
        }
        //update the zone cumulative currency amount
        self.getZone().updateProgress(money: amount)
    }

    
    // MARK: NSCoding
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

