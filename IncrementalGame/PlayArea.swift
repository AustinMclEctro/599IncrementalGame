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
    override init(frame: CGRect) {
        super.init(frame: frame)
        presentScene(SKScene(size: frame.size))
        
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
        var gameObject = GameObject(type: of);
        self.scene!.addChild(gameObject);
        gameObject.position = at;
        gameObject.scale(to: CGSize(width: 50, height: 50));
    }
    func gained(amount: Int) {
        // Change the name/delete as you like :) just left here to show how to add currency A
        if let controller = superview as? ControllerView {
            controller.addCurA(by: amount);
        }
    }
}
