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
    
    //var emitter = SKEmitterNode(fileNamed: "MyParticle.sks")
    //var withSize: CGSize // REFACTOR: Might need to remove
    var inZone: Zone
    var pointValue = 0
    var upgradeALevel = 0
    var upgradeBLevel = 0
    var upgradeCLevel = 0
    
    override init(type: ObjectType, at: CGPoint, inZone: Zone) {
        self.inZone = inZone
        
        super.init(type: type, at: at, inZone: inZone)
        //super.setUp(at: at, withSize: withSize)
        
        self.pointValue = objectType.getPoints(upgradeALevel)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = true
        self.physicsBody?.restitution = 0.2
        self.physicsBody?.angularDamping = 0.5
        self.physicsBody?.friction = 0.5
        self.physicsBody?.linearDamping = 0.8
        self.physicsBody?.mass = 1
        self.physicsBody?.usesPreciseCollisionDetection = true
        let rangeX = SKRange(lowerLimit: (dimension/2)-5, upperLimit: (inZone.size.width-(dimension/2)+5))
        let rangeY = SKRange(lowerLimit: (dimension/2)-5, upperLimit: (inZone.size.height-(dimension/2)+5))
        let rangeD = SKRange(upperLimit: inZone.size.width * 0.6) // Need to tweak value still!!!!
        let conX = SKConstraint.positionX(rangeX)
        let conY = SKConstraint.positionY(rangeY)
        let conD = SKConstraint.distance(rangeD, to: CGPoint(x: inZone.size.width * 0.5, y: inZone.size.width * 0.5), in: inZone)
        self.constraints = [conX,conY,conD]
        //emitter?.particleTexture = SKTexture(image: self.getType().getImage()!)
        //emitter?.numParticlesToEmit = 10
        //emitter?.particleLifetime = 0.25
        //emitter?.position = CGPoint(x:self.size.width/2 , y:self.size.height/2)
        //emitter?.particleSize = CGSize(width: 40, height: 40)
        //emitter?.targetNode = inZone
        //self.addChild(emitter!)
    }
    
    /// Animates the collision after being passed an emitter node by setting the proper duration,
    /// adding a child node and then letting the animation play before removing itself
    ///
    /// - Parameter collisionEmitter: The SKEmitterNode that contains the settings for the animation.
    func animateCollision() {
        // Set up a sequence animation which deletes its node after completion.
        //let duration = Double((emitter?.particleLifetime)!*CGFloat((emitter?.numParticlesToEmit)!))
        //emitter?.resetSimulation()
        //emitter?.advanceSimulationTime(duration)
        removeAction(forKey: "pulse")
        let pulseIn = SKAction.scale(to: CGSize(width: dimension*0.75, height: dimension*0.75), duration: 0.03)
        let pulseOut = SKAction.scale(to: CGSize(width: dimension, height: dimension), duration: 0.03)
        let pulse = SKAction.sequence([pulseIn,pulseOut])
        run(pulse, withKey: "pulse")
    }
    func upgradePriceA() -> Int {
        guard canUpgradeA() else {return -1}
        return objectType.getUpgradePriceA(upgradeALevel)
    }
    func upgradePriceB() -> Int {
        guard canUpgradeB() else {return -1}
        return objectType.getUpgradePriceB(upgradeBLevel)
    }
    func upgradePriceC() -> Int {
        guard canUpgradeC() else {return -1}
        return objectType.getUpgradePriceC(upgradeCLevel)
    }
    func canUpgradeA() -> Bool {
        return upgradeALevel < 9
    }
    
    func upgradeA() {
        guard canUpgradeA() else {return}
        inZone.pIG.feed(portion: objectType.getPigRateA(upgradeALevel))
        upgradeALevel += 1
        pointValue = objectType.getPoints(upgradeALevel)
    }
    
    func canUpgradeB() -> Bool {
        return upgradeBLevel < 5
    }
    
    func upgradeB() {
        guard canUpgradeB() else {return}
        inZone.pIG.feed(portion: objectType.getPigRateB(upgradeBLevel))
        upgradeBLevel += 1
        self.physicsBody?.restitution += 0.15
    }
    
    func canUpgradeC() -> Bool {
        return upgradeCLevel < 5
    }
    
    func upgradeC() {
        guard canUpgradeC() else {return}
        inZone.pIG.feed(portion: objectType.getPigRateC(upgradeCLevel))
        upgradeCLevel += 1
        self.physicsBody?.linearDamping -= 0.15
    }
    
    
    
    func getPoints() -> Int {
        return pointValue
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
