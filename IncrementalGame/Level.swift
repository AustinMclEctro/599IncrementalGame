//
//  Level.swift
//  IncrementalGame
//
//  Created by Andrew Groeneveldt on 10-06-2017.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import UIKit
import SpriteKit
import CoreMotion

class Level: SKScene, SKPhysicsContactDelegate {
    
    var motionManager = CMMotionManager()
    let maxShapes = 12
    let minVel: CGFloat = 50
    var allowedObjects: Set<ObjectType> = []
    
    
    init(size: CGSize, actual: Bool=true) {
        super.init(size: size)
        
        backgroundColor = SKColor.black
        
        if actual {
            motionManager.startAccelerometerUpdates()
            
            physicsWorld.gravity = CGVector(dx: 0, dy: 0)
            physicsWorld.contactDelegate = self
            
            let boundary = SKPhysicsBody(edgeLoopFrom: self.frame)
            boundary.friction = 0.2
            boundary.categoryBitMask = 1
            boundary.contactTestBitMask = 1
            boundary.collisionBitMask = 1
            boundary.usesPreciseCollisionDetection = true
            boundary.affectedByGravity = false
            self.physicsBody = boundary
            
            addAllowedObject(type: .Triangle)
            
            // just for MVP demo
            addAllowedObject(type: .Square)
            addAllowedObject(type: .Bumper)
            // Added these
            addAllowedObject(type: .Star)
            addAllowedObject(type: .Pentagon)
            addAllowedObject(type: .Hexagon)
            addAllowedObject(type: .Circle)
        }
        else {
            let addTap = SKLabelNode(text: "Double Tap to Add a New Zone")
            addTap.fontSize = 26
            addTap.position = CGPoint(x: frame.midX, y: frame.midY)
            addChild(addTap)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(_ currentTime: TimeInterval) {
        if let accelData = motionManager.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelData.acceleration.x * 30, dy: accelData.acceleration.y * 30)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.velocity.magnitude() > minVel && contact.bodyB.velocity.magnitude() > minVel && !contact.bodyB.angularVelocity.isLess(than: minVel){
            if let playArea = view as? PlayArea {
                if let one = contact.bodyA.node as? GameObject {
                    playArea.gained(amount: one.objectType.getPoints())
                }
                if let two = contact.bodyB.node as? GameObject {
                    playArea.gained(amount: two.objectType.getPoints())
                }
            }
            if (contact.bodyA.node is GameObject && contact.bodyB.node is GameObject) {
                
                //find the most highly valued object in the collision
                var min = contact.bodyA.node as! GameObject
                var max = contact.bodyB.node as! GameObject
                if min.getType().getPoints() > max.getType().getPoints() {
                    swap(&min, &max)
                }
                //want animation to be of greater valued object
                //create an object first
                let collisionEmitter =  createEmitter(sourceNode: max, location: contact.contactPoint)
                animateCollision(collisionEmitter: collisionEmitter)
                
            }
        }
  
        
    }
 
    //creates an emitter node
    func createEmitter(sourceNode: GameObject, location: CGPoint) -> SKEmitterNode {
        let emitter = SKEmitterNode(fileNamed: "MyParticle.sks")
        //now set the emitter to have the right texture of the passed node
        emitter?.particleTexture = SKTexture(image: sourceNode.getType().getImage()!)
        emitter?.particlePosition = location
        emitter?.numParticlesToEmit = 5
        return emitter!
    }
    
    //animates the collision after being passed an emitter node by setting the proper duration, adding a child node
    //and then letting the animation play before removing itself
    func animateCollision(collisionEmitter: SKEmitterNode) {
        //set up a sequence animation which deletes its node after completion.
        let duration = CGFloat(collisionEmitter.numParticlesToEmit)*collisionEmitter.particleLifetime
        let addEmitterAction = SKAction.run({self.addChild(collisionEmitter)})
        let waitAction = SKAction.wait(forDuration: TimeInterval(duration)) //allow sparks to animate
        let remove = SKAction.run {collisionEmitter.removeFromParent()}
        let collisionSequence = SKAction.sequence([addEmitterAction,waitAction,remove])
        self.run(collisionSequence)
    }
    
    func canAdd(type: ObjectType) -> Bool {
        var addOK = true
        var shapeCount = 0
        if !allowedObjects.contains(type) {addOK = false}
        for object in self.children {
            if let shape = object as? GameObject {
                if shape.objectType.rawValue < 10 {
                    shapeCount += 1
                } else {
                    if shape.objectType == type {addOK = false}
                }
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
