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
    
    var zone: Zone
    var zoneNumber = 0
    let gameState: GameState
    var selectedNode: GameObject?;
    
    // For edge pans to allow two scenes at once, with only one moving. See PlayAreaTouchEvents for more
    var tempImageZone: UIImageView?;
    
    init(frame: CGRect, gameState: GameState) {
        self.gameState = gameState
        
        // Load zones if they exist, create zone 0 if it doesn't
        if gameState.zones.isEmpty {
            zone = Zone(size: frame.size, children: [], pIG: nil, allowedObjects: nil)
            gameState.zones.append(zone)
        } else {
            zone = gameState.zones[0]; // REFACTOR: Should zone zero be saved in the zones array?
        }
        
        super.init(frame: frame)
        setupTouchEvents()
        //self.showsPhysics = true
        
        presentScene(zone)
    }
    
    /// Selects and presents the specified zone.
    ///
    /// - Parameter index: The index number of the zone in the zones array.
    func selectZone(index: Int) {
        // Displays the selected zone
        zoneNumber = index
        
        zone = gameState.zones[zoneNumber]
        presentScene(zone)
    }
    
    func getZone() -> Zone {
        return zone
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// Adds the specified shape to the level.
    ///
    /// - Parameters:
    ///   - of: The specific type of shape.
    ///   - at: The position where the fixture will be placed on the game screen.
    /// - Returns: <#return value description#>
    func addShape(of: ObjectType, at: CGPoint) -> Shape? { // REFACTOR: Could this be put in Zone?
        if zone.canAdd(type: of) {
            let shape = Shape(type: of, at: at, withSize: zone.size);
            zone.addChild(shape);
            return shape;
        }
        return nil;
    }
    
    
    /// Adds the specified fixture to the level.
    ///
    /// - Parameters:
    ///   - of: The specific type of fixture.
    ///   - at: The position where the fixture will be placed on the game screen.
    func addFixture(of: ObjectType, at: CGPoint) { // REFACTOR: Could this be put in Zone?
        if zone.canAdd(type: of) {
            let fix = Fixture(type: of, at: at, withSize: zone.size);
            zone.addChild(fix);
            zone.removeAllowedObject(type: of)
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
    }
    
    func resetGravity() {
        for zone in gameState.zones {
            zone.resetGravity()
        }
    }
    
}

