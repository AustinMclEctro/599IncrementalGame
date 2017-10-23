//
//  PlayArea.swift
//  IncrementalGame
//
//  Created by Ben Grande on 2017-10-05.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import Foundation
import SpriteKit

class PlayArea: SKView {
    
    var level: Zone
    var zoneNumber = 0
    let gameState: GameState
    var tableSceneView: SceneTableView?
    var tableOpen = false
    
    
    init(frame: CGRect, gameState: GameState) {
        self.gameState = gameState
        level = Zone(size: frame.size, zone0: true)
        gameState.zones.append(level)
        super.init(frame: frame)
        setupTouchEvents()
        presentScene(level)
        
    }
    
    func selectZone(index: Int) {
        // Displays the selected zone
        zoneNumber = index
        
        // don't know why this is needed but zones[0] won't display right without it!!
        if zoneNumber == 0 {gameState.zones[0] = Zone(size: frame.size, zone0: true)}
        
        level = gameState.zones[index]
        presentScene(level)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addShape(of: ObjectType, at: CGPoint) {
        if level.canAdd(type: of) {
            let shape = Shape(type: of, at: at, withSize: level.size);
            level.addChild(shape);
        }
    }
    
    func addFixture(of: ObjectType, at: CGPoint) {
        if level.canAdd(type: of) {
            let fix = Fixture(type: of, at: at, withSize: level.size);
            level.addChild(fix);
            level.removeAllowedObject(type: of)
        }
    }
    
    func gained(amount: Int) {
        // Change the name/delete as you like :) just left here to show how to add currency A
        if let controller = superview as? MasterView {
            controller.updateCurrencyA(by: amount);
        }
    }
    
}

