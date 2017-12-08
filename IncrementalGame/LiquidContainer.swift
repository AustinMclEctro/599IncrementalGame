//
//  LiquidController.swift
//  IncrementalGame
//
//  Created by Ben Grande on 2017-11-23.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit
import CoreMotion

class LiquidContainer: SKScene {
    
    // MARK: Properties
    
    var motionManager = CMMotionManager()
    var gravityX = 0.0;
    var gravityY = 2.0;
    var liquid: SKSpriteNode;
    
    
    // MARK: Initializers
    
    
    override init(size: CGSize) {
        motionManager.startAccelerometerUpdates()
        liquid = SKSpriteNode(color: .blue, size: CGSize(width: size.height*2, height: size.height*2))
        
        super.init(size: size)
        
        liquid.position = CGPoint(x: size.width/2, y: size.height/2)
        liquid.anchorPoint = CGPoint(x: 0.5, y: 0)
        liquid.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: 10), center: CGPoint(x: 0, y: liquid.size.height/2));
        liquid.physicsBody?.pinned = true;
        liquid.physicsBody?.angularDamping = 1.0
        
        //self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.addChild(liquid);
    }
    
    
    // MARK: Functions
    
    
    override func update(_ currentTime: TimeInterval) {
        if let accelData = motionManager.accelerometerData {
            physicsWorld.gravity = CGVector(dx: (accelData.acceleration.x - gravityX) * 25, dy: (accelData.acceleration.y - gravityY) * 25)
        }
        
    }
    
    
    // MARK: NSCoding
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }    
}

