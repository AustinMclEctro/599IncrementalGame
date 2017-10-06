//
//  Level.swift
//  IncrementalGame
//
//  Created by Andrew Groeneveldt on 10-06-2017.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import Foundation
import SpriteKit
import CoreMotion

class Level: SKScene, SKPhysicsContactDelegate {
    
    var motionManager = CMMotionManager()
    let maxShapes = 12
    var allowedShapes: Set<ObjectType> = [.Circle]
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black
        
        motionManager.startAccelerometerUpdates()
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        let boundary = SKPhysicsBody(edgeLoopFrom: self.frame)
        boundary.friction = 0.2
        boundary.categoryBitMask = 1
        boundary.contactTestBitMask = 1
        boundary.collisionBitMask = 1
        boundary.usesPreciseCollisionDetection = true
        self.physicsBody = boundary
        
        // just for MVP demo
        addAllowedShape(type: .Triangle)
        addAllowedShape(type: .Square)
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        if let accelData = motionManager.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelData.acceleration.x * 30, dy: accelData.acceleration.y * 30)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if let playArea = view as? PlayArea {
            if let one = contact.bodyA.node as? GameObject {
                playArea.gained(amount: one.basePoints)
            }
            if let two = contact.bodyB.node as? GameObject {
                playArea.gained(amount: two.basePoints)
            }
        }
    }
    
    func canAdd(type: ObjectType) -> Bool {
        return allowedShapes.contains(type) && self.children.count < maxShapes
    }
    
    func addAllowedShape(type: ObjectType) {
        allowedShapes.insert(type)
    }
}

