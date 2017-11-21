//
//  Shape.swift
//  IncrementalGame
//
//  Created by Andrew Groeneveldt on 2017-10-22.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import Foundation
import SpriteKit


/// Shape objects, such as the triangle and square, used for gameplay. 
class Shape: GameObject {
    
    
    var emitter = SKEmitterNode(fileNamed: "MyParticle.sks")
    //var withSize: CGSize // REFACTOR: Might need to remove
    var inZone: Zone
    var pointMultiplier = 1
    var upgradeALevel = 0
    var upgradeBLevel = 0
    var upgradeCLevel = 0
    
    override init(type: ObjectType, at: CGPoint, inZone: Zone) {
        self.inZone = inZone
        
        super.init(type: type, at: at, inZone: inZone)
        //super.setUp(at: at, withSize: withSize)
        
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = true
        self.physicsBody?.restitution = 0.75
        self.physicsBody?.angularDamping = 0.5
        self.physicsBody?.friction = 0.5
        self.physicsBody?.linearDamping = 0.5
        self.physicsBody?.mass = 1
        self.physicsBody?.usesPreciseCollisionDetection = true
        let rangeX = SKRange(lowerLimit: (dimension/2)-5, upperLimit: (inZone.size.width-(dimension/2)+5))
        let rangeY = SKRange(lowerLimit: (dimension/2)-5, upperLimit: (inZone.size.height-(dimension/2)+5))
        let rangeD = SKRange(upperLimit: inZone.size.width * 0.6) // Need to tweak value still!!!!
        let conX = SKConstraint.positionX(rangeX)
        let conY = SKConstraint.positionY(rangeY)
        let conD = SKConstraint.distance(rangeD, to: CGPoint(x: inZone.size.width * 0.5, y: inZone.size.width * 0.5), in: inZone)
        self.constraints = [conX,conY,conD]
        emitter?.particleTexture = SKTexture(image: self.getType().getImage()!)
        emitter?.numParticlesToEmit = 10
        emitter?.particleLifetime = 0.25
        emitter?.position = CGPoint(x:self.size.width/2 , y:self.size.height/2)
        emitter?.particleSize = CGSize(width: 40, height: 40)
        emitter?.targetNode = inZone
        self.addChild(emitter!)
    }
    
    /// Animates the collision after being passed an emitter node by setting the proper duration,
    /// adding a child node and then letting the animation play before removing itself
    ///
    /// - Parameter collisionEmitter: The SKEmitterNode that contains the settings for the animation.
    func animateCollision() {
        // Set up a sequence animation which deletes its node after completion.
        let duration = Double((emitter?.particleLifetime)!*CGFloat((emitter?.numParticlesToEmit)!))
        emitter?.resetSimulation()
        emitter?.advanceSimulationTime(duration)
    }
    func upgradePriceA() -> Int {
        return 1000000000;
    }
    func upgradePriceB() -> Int {
        return objectType.getPrice();
    }
    func upgradePriceC() -> Int {
        return objectType.getPrice();
    }
    func canUpgradeA() -> Bool {
        return upgradeALevel < 10
    }
    
    func upgradeA() {
        guard upgradeALevel < 10 else {return}
        upgradeALevel += 1
        pointMultiplier += 1
    }
    
    func canUpgradeB() -> Bool {
        return upgradeBLevel < 5
    }
    
    func upgradeB() {
        guard upgradeBLevel < 5 else {return}
        upgradeBLevel += 1
        self.physicsBody?.restitution *= 1.25
    }
    
    func canUpgradeC() -> Bool {
        return upgradeCLevel < 5
    }
    
    func upgradeC() {
        guard upgradeCLevel < 5 else {return}
        upgradeCLevel += 1
        self.physicsBody?.linearDamping *= 0.8
    }
    
    
    
    func getPoints() -> Int {
        return self.objectType.getPoints() * pointMultiplier
    }
    
    // MARK: NSCoding
    // REFACTOR: Move to GameObject
    
    /// Keys used to reference the properties in memory
    struct PropertyKey {
        static let objectType = "objectType"
        static let lastPosition = "lastPosition"
        static let zone = "zone"
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)        
        try? (aCoder as! NSKeyedArchiver).encodeEncodable(objectType, forKey: PropertyKey.objectType)
        aCoder.encode(self.position, forKey: PropertyKey.lastPosition)
        aCoder.encode(self.inZone, forKey: PropertyKey.zone)
    }
    
    
    required convenience init?(coder aDecoder: NSCoder) {
        let objectType = (aDecoder as! NSKeyedUnarchiver).decodeDecodable(ObjectType.self, forKey: PropertyKey.objectType)
        let lastPosition = aDecoder.decodeCGPoint(forKey: PropertyKey.lastPosition)
        let zone = aDecoder.decodeObject(forKey: PropertyKey.zone) as! Zone
        
        self.init(type: objectType!, at: lastPosition, inZone: zone)
    }
}
