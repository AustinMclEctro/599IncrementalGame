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
    let minVel: CGFloat = 30
    var allowedObjects: Set<ObjectType> = [.Circle]
    
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
        addAllowedObject(type: .Triangle)
        addAllowedObject(type: .Square)
        addAllowedObject(type: .Bumper)
        // Added these
        addAllowedObject(type: .Star)
        addAllowedObject(type: .Pentagon)
        addAllowedObject(type: .Hexagon)
        addAllowedObject(type: .Circle)
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        if let accelData = motionManager.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelData.acceleration.x * 30, dy: accelData.acceleration.y * 30)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.velocity.magnitude() > minVel || contact.bodyB.velocity.magnitude() > minVel {
            if let playArea = view as? PlayArea {
                if let one = contact.bodyA.node as? GameObject {
                    playArea.gained(amount: one.objectType.getPoints())
                }
                if let two = contact.bodyB.node as? GameObject {
                    playArea.gained(amount: two.objectType.getPoints())
                }
            }
        }
    }
    
    func canAdd(type: ObjectType) -> Bool {
        var addOK = true
        var shapeCount = 0
        if !allowedObjects.contains(type) {addOK = false}
        for object in self.children {
            let shape = object as! GameObject
            if shape.objectType.rawValue < 10 {
                shapeCount += 1
            } else {
                if shape.objectType == type {addOK = false}
            }
        }
        if shapeCount >= maxShapes {addOK = false}
        return addOK
    }
    
    func addAllowedObject(type: ObjectType) {
        allowedObjects.insert(type)
    }
}

extension CGVector {
    func magnitude() -> CGFloat {
        return sqrt((self.dx * self.dx) + (self.dy * self.dy))
    }
}