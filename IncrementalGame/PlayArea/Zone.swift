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
    var maxShapes = 3
    let minVel: CGFloat = 250
    var allowedObjects: Set<ObjectType> = []
    var gravityX: Double = 0
    var gravityY: Double = 0
    var pIG = PassiveIncomeGenerator(backgroundRate: PassiveIncomeGenerator.Rates.background, inactiveRate: PassiveIncomeGenerator.Rates.inactive)
    var upgradeALevel = 0
    var upgradeBLevel = 0
    var sparksAvail = 12
    let maxSparks = 12
    
    var hapticXLightGenerator = UISelectionFeedbackGenerator()
    var hapticLightGenerator = UIImpactFeedbackGenerator(style: .light);
    var hapticMediumGenerator = UIImpactFeedbackGenerator(style: .medium);
    var hapticHeavyGenerator = UIImpactFeedbackGenerator(style: .heavy);
    
    init(size: CGSize, children: [SKNode], pIG: PassiveIncomeGenerator?, allowedObjects: Set<ObjectType>?) {
        
        super.init(size: size)
        //backgroundColor = SKColor.black
        
        motionManager.startAccelerometerUpdates()
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        let boundRect = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        let boundPath = UIBezierPath(roundedRect: boundRect, cornerRadius: 75.0)
        let boundary = SKPhysicsBody(edgeLoopFrom: boundPath.cgPath)
        boundary.friction = 1
        boundary.categoryBitMask = 1
        boundary.contactTestBitMask = 1
        boundary.collisionBitMask = 1
        boundary.usesPreciseCollisionDetection = true
        self.physicsBody = boundary
        let outline = SKShapeNode(path: boundPath.cgPath)
        outline.lineWidth = 5
        outline.fillColor = .clear
        outline.strokeColor = .white
        outline.glowWidth = 1.5
        let background = SKSpriteNode(imageNamed: "DefaultSquares")
        background.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        background.scale(to: frame.size);
        self.addChild(background)
        self.addChild(outline)
        
        addAllowedObject(type: .Triangle)
        addAllowedObject(type: .Bumper)
        
        // Load zone properties
        if !children.isEmpty {
            for child in children {
                self.addChild(child)
            }
        }
        if allowedObjects != nil {
            self.allowedObjects = allowedObjects!
        }
        if pIG != nil {
            self.pIG = pIG!
        } else {
            self.pIG = PassiveIncomeGenerator(backgroundRate: PassiveIncomeGenerator.Rates.background, inactiveRate: PassiveIncomeGenerator.Rates.inactive)
        }
    }
    
    
    func canUpgradeA() -> Bool {
        return upgradeALevel < 3
    }
    
    func upgradeA() {
        guard upgradeALevel < 3 else {return}
        upgradeALevel += 1
        maxShapes += 3
    }
    
    func canUpgradeB() -> Bool {
        return upgradeBLevel < 7
    }
    
    func upgradeB() {
        upgradeBLevel += 1
        switch upgradeBLevel {
        case 1:
            addAllowedObject(type: .Square)
        case 2:
            addAllowedObject(type: .Graviton)
        case 3:
            addAllowedObject(type: .Pentagon)
        case 4:
            addAllowedObject(type: .Hexagon)
        case 5:
            addAllowedObject(type: .Vortex)
        case 6:
            addAllowedObject(type: .Circle)
        case 7:
            addAllowedObject(type: .Star)
        default:
            return
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        if let accelData = motionManager.accelerometerData {
            physicsWorld.gravity = CGVector(dx: (accelData.acceleration.x - gravityX) * 50, dy: (accelData.acceleration.y - gravityY) * 50)
        }
 
    }
    
    func resetGravity() {
        if let accelData = motionManager.accelerometerData {
            gravityX = accelData.acceleration.x
            gravityY = accelData.acceleration.y
        }
    }
    func hasSounds() -> Bool {
        return false;
    }
    func hapticFor(contact: SKPhysicsContact) {
        let hasHaptics = UserDefaults.standard.bool(forKey: SettingsBundleKeys.Vibration);
        if hasHaptics {
            let fakeFA = contact.bodyA.angularVelocity*contact.bodyA.mass;
            let fakeFB = contact.bodyB.angularVelocity*contact.bodyB.mass;
            
            let totFakeF = abs(fakeFA)+abs(fakeFB);
            if (totFakeF < 5) {
                return;
            }
            if totFakeF < 10 {
                hapticXLightGenerator.prepare()
                hapticXLightGenerator.selectionChanged()
            }
            else if (totFakeF < 15) {
                hapticLightGenerator.prepare()
                hapticLightGenerator.impactOccurred()
            }
            else if (totFakeF < 25) {
                hapticMediumGenerator.prepare()
                hapticMediumGenerator.impactOccurred()
            }
            else {
                hapticHeavyGenerator.prepare()
                hapticHeavyGenerator.impactOccurred()
            }
        }
        
    }
    
    func soundFor(_ object: GameObject) {
        let hasSound = UserDefaults.standard.bool(forKey: SettingsBundleKeys.Sound);
        if hasSound {
            object.getType().playCollisionSound(object)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        hapticFor(contact: contact);
        if contact.bodyA.velocity.magnitudeSquared() > minVel || contact.bodyB.velocity.magnitudeSquared() > minVel {
            var hit: Shape? = nil
            var maxPoints: Int = 0
            if let playArea = view as? PlayArea {
                if let one = contact.bodyA.node as? Shape {
                    maxPoints = one.getPoints()
                    hit = one
                    playArea.gained(amount: maxPoints)
                    //soundFor(one)
                    one.getType().playCollisionSound(one)
                }
                
                if let two = contact.bodyB.node as? Shape {
                    let points = two.getPoints()
                    playArea.gained(amount: points)
                    if points > maxPoints {
                        hit = two
                    }
                    //soundFor(two)
                    two.getType().playCollisionSound(two)
                }
                
                if sparksAvail > 0 {
                    //let spark = createEmitter(sourceNode: hit!, location: contact.contactPoint)
                    //animateCollision(collisionEmitter: spark)
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
        sparksAvail -= 1
        if sparksAvail < 0 {sparksAvail = 0}
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
        sparksAvail += 1
        if sparksAvail > maxSparks {sparksAvail = maxSparks}
        
        /* IN PROGRESS - BROKEN CODE
         //set up a dummy spark node
         let dummy = SKSpriteNode(texture: collisionEmitter.particleTexture)
         dummy.position = self.frame.origin
         //dummy.isHidden = true
         dummy.physicsBody = SKPhysicsBody(circleOfRadius: 5.0)
         dummy.physicsBody?.isDynamic = true
         dummy.physicsBody?.collisionBitMask = 0
         dummy.physicsBody?.affectedByGravity = true
         let show = SKAction.fadeIn(withDuration: 1.5)
         let scale = SKAction.scale(to: 1, duration: 1)
         let randPulse = CGVector(dx: Int(arc4random_uniform(20)), dy: Int(arc4random_uniform(20)))
         let start = SKAction.applyImpulse(randPulse, duration: 0.5)
         let begin = SKAction.group([show, scale, start])
         
         
         
         let gather = SKAction.move(to: CGPoint(x: 40, y: 40), duration: 1.5)
         
         let addDummy = SKAction.run {
         collisionEmitter.addChild(dummy)
         }
         
         let removeDummy = SKAction.run {
         dummy.removeFromParent()
         }
         
         let gatherSequence = SKAction.sequence([addDummy,begin,gather,removeDummy])
         let together = SKAction.group([collisionSequence,gatherSequence])
         self.run(together)
         */
    }
    
    
    /// Returns a Boolean indicating whether the ObjectType can be added. Only allowed objects
    /// below the maximum permitted amount of items under that ObjectType can be added.
    ///
    /// - Parameter type: The ObjectType (triange, bumper, etc.)
    /// - Returns: True if the object can be added, otherwise false.
    func canAdd(type: ObjectType) -> Bool {
        guard allowedObjects.contains(type) else {return false}
        
        guard !type.isFixture() else {return true}
        
        var shapeCount = 0
        
        // Get and check shape count
        for object in self.children {
            if object is Shape {
                shapeCount += 1
            }
        }
        return shapeCount < maxShapes
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
        static let allowedObjects = "allowedObjects"
        static let pIG = "pIG"
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(size, forKey: PropertyKey.size)
        aCoder.encode(pIG, forKey: PropertyKey.pIG)
        try? (aCoder as! NSKeyedArchiver).encodeEncodable(Array(allowedObjects), forKey: PropertyKey.allowedObjects)
        
        //Save only GameObjects
        var childrenToSave = [SKNode]()
        for child in children {
            if let gameObject = child as? GameObject {
                childrenToSave.append(gameObject)
            }
        }
        aCoder.encode(childrenToSave, forKey: PropertyKey.children)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let size = aDecoder.decodeCGSize(forKey: PropertyKey.size)
        let children = aDecoder.decodeObject(forKey: PropertyKey.children) as! [SKNode]
        let allowedObjects = Set((aDecoder as! NSKeyedUnarchiver).decodeDecodable([ObjectType].self, forKey: PropertyKey.allowedObjects)!)
        let pIG = aDecoder.decodeObject(forKey: PropertyKey.pIG) as! PassiveIncomeGenerator
        self.init(size: size, children: children, pIG: pIG, allowedObjects: allowedObjects)
    }
}

extension CGVector {
    func magnitudeSquared() -> CGFloat {
        return (self.dx * self.dx) + (self.dy * self.dy)
    }
}

