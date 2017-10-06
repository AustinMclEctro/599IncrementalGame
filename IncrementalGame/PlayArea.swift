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
    
    var level: Level
    
    override init(frame: CGRect) {
        level = Level()
        super.init(frame: frame)
        let scene = level
        scene.size = frame.size
        presentScene(scene)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setShapes(_ shapes: [[String: String]]) {
        // used to init
    }
    
    func addObject(of: ObjectType, at: CGPoint) {
        // GameObject inherits from SKSpriteNode
        // Initializer is ObjectType - Circle, Triangle etc
        if level.canAdd(type: of) {
            let gameObject = GameObject(type: of);
            level.addChild(gameObject);
            gameObject.setUp(at: at, withSize: level.size)
        }
    }
    
    func gained(amount: Int) {
        // Change the name/delete as you like :) just left here to show how to add currency A
        if let controller = superview as? ControllerView {
            controller.addCurA(by: amount);
        }
    }
    
}

