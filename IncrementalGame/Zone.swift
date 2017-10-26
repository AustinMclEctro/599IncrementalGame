//
//  Zone.swift
//  IncrementalGame
//
//  Created by Andrew Groeneveldt on 10-06-2017.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import UIKit
import SpriteKit
import CoreMotion

class Zone: SKScene, SKPhysicsContactDelegate {
    
    var motionManager = CMMotionManager()
    let maxShapes = 12
    let minVel: CGFloat = 300 * 300
    var allowedObjects: Set<ObjectType> = []
    static var newZonePrice = 1000
    
    
    init(size: CGSize, zone0: Bool=false, children: [SKNode]) {
        
        super.init(size: size)
        
        backgroundColor = SKColor.black
        
        motionManager.startAccelerometerUpdates()
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        let boundary = SKPhysicsBody(edgeLoopFrom: self.frame)
        boundary.friction = 1
        boundary.categoryBitMask = 1
        boundary.contactTestBitMask = 1
        boundary.collisionBitMask = 1
        boundary.usesPreciseCollisionDetection = false
        boundary.affectedByGravity = false
        boundary.isDynamic = false
        self.physicsBody = boundary
        
        addAllowedObject(type: .Triangle)
        addAllowedObject(type: .Bumper)
        
        // just for MVP demo
        addAllowedObject(type: .Square)
        addAllowedObject(type: .Star)
        addAllowedObject(type: .Pentagon)
        addAllowedObject(type: .Hexagon)
        addAllowedObject(type: .Circle)

        if !children.isEmpty {
            for child in children {
                self.addChild(child)
            }
        }
        
        // Add zone 0 (no zones) and setup tap gesture
        if zone0 {
            let addTap = SKLabelNode(text: "Double Tap to Add a New Zone")
            addTap.fontSize = 26
            addTap.position = CGPoint(x: frame.midX, y: frame.midY)
            addChild(addTap)
            let addPrice = SKLabelNode(text: "For $\(Zone.newZonePrice)")
            addPrice.fontSize = 26
            addPrice.position = CGPoint(x: frame.midX, y: frame.midY-30)
            addChild(addPrice)
            allowedObjects = [];
        }
        
    }
    
    
    /// Updates the newZonePrice for the Zone object and updates the zone's price label.
    ///
    /// - Parameter price: The desired price for the zone.
    func updateZonePrice(_ price: Int) {
        Zone.newZonePrice = price
        if let priceLabel = children[1] as? SKLabelNode {
            priceLabel.text = "For $\(Zone.newZonePrice)"
        }
    }
    

    override func update(_ currentTime: TimeInterval) {
        if let accelData = motionManager.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelData.acceleration.x * 30, dy: accelData.acceleration.y * 30)
        }
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.velocity.magnitudeSquared() > minVel || contact.bodyB.velocity.magnitudeSquared() > minVel {
            if let playArea = view as? PlayArea {
                if let one = contact.bodyA.node as? Shape {
                    playArea.gained(amount: one.objectType.getPoints())
                }
                if let two = contact.bodyB.node as? Shape {
                    playArea.gained(amount: two.objectType.getPoints())
                }
                //the below only works because the only objects that are dynamic are shapes
                if contact.bodyB.isDynamic && contact.bodyA.isDynamic {
                    let A = contact.bodyA.node as? GameObject
                    let B = contact.bodyB.node as? GameObject
                    let spark: SKEmitterNode
                    if A!.getType().getPoints() >= B!.getType().getPoints() {
                        spark = createEmitter(sourceNode: contact.bodyA.node as! GameObject, location: contact.contactPoint)
                        animateCollision(collisionEmitter: spark)
                    } else {
                        spark = createEmitter(sourceNode: contact.bodyB.node as! GameObject, location: contact.contactPoint)
                        animateCollision(collisionEmitter: spark)
                    }
                }
            }
        }
        
    }
    
    
    /// Creates an emitter node to emit the collision animation.
    ///
    /// - Parameters:
    ///   - sourceNode: The SKNode containing the animation for the emitter.
    ///   - location: The location where the emitter will emit.
    /// - Returns: An SKNode that emits an animation.
    func createEmitter(sourceNode: GameObject, location: CGPoint) -> SKEmitterNode {
        let emitter = SKEmitterNode(fileNamed: "MyParticle.sks")
        // Now set the emitter to have the right texture of the passed node
        emitter?.particleTexture = SKTexture(image: sourceNode.getType().getImage()!)
        emitter?.particlePosition = location
        emitter?.numParticlesToEmit = 5
        return emitter!
    }
    
    
    /// Animates the collision after being passed an emitter node by setting the proper duration,
    /// adding a child node and then letting the animation play before removing itself
    ///
    /// - Parameter collisionEmitter: The SKEmitterNode that contains the settings for the animation.
    func animateCollision(collisionEmitter: SKEmitterNode) {
        // Set up a sequence animation which deletes its node after completion.
        let duration = CGFloat(collisionEmitter.numParticlesToEmit)*collisionEmitter.particleLifetime
        //can set particle actions with collisionEmitter.particleAction = actions
        let gatherPoint = frame.origin
        collisionEmitter.particleAction = SKAction.move(to: gatherPoint, duration: 2)
        let addEmitterAction = SKAction.run({self.addChild(collisionEmitter)})
        let waitAction = SKAction.wait(forDuration: TimeInterval(duration)) //allow sparks to animate
        let remove = SKAction.run {collisionEmitter.removeFromParent()}
        let collisionSequence = SKAction.sequence([addEmitterAction, collisionEmitter.particleAction!,waitAction,remove])
        self.run(collisionSequence)
    }
    
    
    /// Returns a Boolean indicating whether the ObjectType can be added. Only allowed objects
    /// below the maximum permitted amount of items under that ObjectType can be added.
    ///
    /// - Parameter type: The ObjectType (triange, bumper, etc.)
    /// - Returns: True if the object can be added, otherwise false.
    func canAdd(type: ObjectType) -> Bool {
        var addOK = true
        var shapeCount = 0
        if !allowedObjects.contains(type) {addOK = false}
        
        // Get and check shape count
        for object in self.children {
            if object is Shape {
                shapeCount += 1
            }
        }
        if shapeCount >= maxShapes {addOK = false}
        return addOK
    }
    
    
    /// Adds an ObjectType to the allowedObjects array.
    ///
    /// - Parameter type: The ObjectType (triange, bumper, etc.)
    func addAllowedObject(type: ObjectType) {
        allowedObjects.insert(type)
    }
    
    
    /// Removes an ObjectType to the allowedObjects array.
    ///
    /// - Parameter type: The ObjectType (triange, bumper, etc.)
    func removeAllowedObject(type: ObjectType) {
        allowedObjects.remove(type)
    }
    
    
    // MARK: NSCoding
    
    /// Keys used to reference the properties in memory
    struct PropertyKey {
        static let size = "size"
        static let children = "children"
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(size, forKey: PropertyKey.size)
        aCoder.encode(children, forKey: PropertyKey.children)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let size = aDecoder.decodeCGSize(forKey: PropertyKey.size)
        let children = aDecoder.decodeObject(forKey: PropertyKey.children) as! [SKNode]
        self.init(size: size, zone0: false, children: children)
    }
}

extension CGVector {
    func magnitudeSquared() -> CGFloat {
        return (self.dx * self.dx) + (self.dy * self.dy)
    }
}

