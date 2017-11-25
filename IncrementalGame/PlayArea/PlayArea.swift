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
    var gameState: GameState
    var selectedNode: GameObject?;
    var pIGManager: PassiveIncomeManager

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
        
        // Passive Income generator
        pIGManager = PassiveIncomeManager(gameState: gameState)
        
        super.init(frame: frame)
        setupTouchEvents()
        //self.showsPhysics = true
        
        presentScene(zone)
        let data: [String: Zone] = ["zone": zone]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notification.Name.shapesChanged), object: nil, userInfo: data)
    }
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
    
    
    /// Adds the specified shape to the level.
    ///
    /// - Parameters:
    ///   - of: The specific type of shape.
    ///   - at: The position where the fixture will be placed on the game screen.
    /// - Returns: <#return value description#>
    func addShape(of: ObjectType, at: CGPoint) -> Shape? { // REFACTOR: Could this be put in Zone?
        if zone.canAdd(type: of) {
            let shape = Shape(type: of, at: at, inZone: zone);
            zone.addChild(shape);
            zone.pIG.feed(portion: Shape.PigRates.newShape);
            //the below is so fucked up, do not touch targetNode
            //shape.emitter?.targetNode = zone
            let data: [String: Zone] = ["zone": zone]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notification.Name.shapesChanged), object: nil, userInfo: data)
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
            let fix = Fixture(type: of, at: at, inZone: zone);
            zone.addChild(fix);
            zone.pIG.feed(portion: Fixture.PigRates.newFixture);
            zone.removeAllowedObject(type: of)
            let data: [String: Zone] = ["zone": zone]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notification.Name.shapesChanged), object: nil, userInfo: data)
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

