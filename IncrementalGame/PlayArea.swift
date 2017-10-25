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
    
    var level: Zone // REFACTOR: Rename to zone?
    var zoneNumber = 0
    let gameState: GameState
    var tableSceneView: SceneTableView?
    var tableOpen = false
    var selectedNode: GameObject?;
    
    init(frame: CGRect, gameState: GameState) {
        self.gameState = gameState
        
        if gameState.zones.isEmpty {
            level = Zone(size: frame.size, zone0: true)
            gameState.zones.append(level)
        } else {
            level = gameState.zones[1]; // REFACTOR: Should zone zero be saved in the zones array?
        }
        
        super.init(frame: frame)
        setupTouchEvents()
        presentScene(level)
        
        
        /*let leftEdgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(panLeftEdge))
        leftEdgePan.edges = .left
        self.addGestureRecognizer(leftEdgePan)
        leftEdgePan.require(toFail: pan)
        
        let rightEdgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(panRightEdge))
        rightEdgePan.edges = .right
        self.addGestureRecognizer(rightEdgePan)
        rightEdgePan.require(toFail: pan)*/
    }
    
    @objc func panLeftEdge(sender: UIScreenEdgePanGestureRecognizer) {
        let oneLess = String(zoneNumber-1);
        print("left from "+String(zoneNumber)+" to "+oneLess)
        if sender.state == .ended {
            selectZone(index: zoneNumber-1)
        }
    }
    
    @objc func panRightEdge(sender: UIScreenEdgePanGestureRecognizer) {
        let oneMore = String(zoneNumber+1)
        print("right from "+String(zoneNumber)+" to "+oneMore)
        if sender.state == .ended {
            selectZone(index: zoneNumber+1)
        }
    }
    
    
    /// Selects and presents the specified zone.
    ///
    /// - Parameter index: The index number of the zone in the zones array.
    func selectZone(index: Int) {
        let count = gameState.zones.count
        var ind = index%count
        if (index < 0) {
            ind = gameState.zones.count+index;
        }
        // Displays the selected zone
        zoneNumber = ind
        
        // don't know why this is needed but zones[0] won't display right without it!!
        if zoneNumber == 0 {gameState.zones[0] = Zone(size: frame.size, zone0: true)}
        
        level = gameState.zones[ind]
        presentScene(level)
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
        if level.canAdd(type: of) {
            let shape = Shape(type: of, at: at, withSize: level.size);
            level.addChild(shape);
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
        if level.canAdd(type: of) {
            let fix = Fixture(type: of, at: at, withSize: level.size);
            level.addChild(fix);
            level.removeAllowedObject(type: of)
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
    
}

