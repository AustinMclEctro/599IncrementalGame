//
//  Fixture.swift
//  IncrementalGame
//
//  Created by Andrew Groeneveldt on 2017-10-22.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import Foundation
import SpriteKit

/// Fixtures, such as the bumper, used in gameplay. 
class Fixture: GameObject {
    
    //var withSize: CGSize  // REFACTOR: This might not need to be stored
    var inZone: Zone
    var upgradeLevel = 0
    
    override init(type: ObjectType, at: CGPoint, inZone: Zone) {
        self.inZone = inZone
        
        super.init(type: type, at: at, inZone: inZone)
        //super.setUp(at: at, withSize: withSize)
        
        switch objectType {
        case .Graviton:
            let grav = SKFieldNode.radialGravityField()
            grav.categoryBitMask = 1
            grav.isEnabled = true
            grav.strength = 20
            grav.isExclusive = false
            grav.falloff = 0.75
            self.addChild(grav)
        case .Vortex:
            let vort = SKFieldNode.vortexField()
            vort.categoryBitMask = 1
            vort.isEnabled = true
            vort.strength = 5
            vort.isExclusive = false
            self.addChild(vort)
        default:
            self.physicsBody?.restitution = 1.25
        }
        
        self.physicsBody?.isDynamic = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.usesPreciseCollisionDetection = true
        let rangeX = SKRange(lowerLimit: (dimension*2), upperLimit: (inZone.size.width-(dimension*2)))
        let rangeY = SKRange(lowerLimit: (dimension*2), upperLimit: (inZone.size.height-(dimension*2)))
        let conX = SKConstraint.positionX(rangeX)
        let conY = SKConstraint.positionY(rangeY)
        self.constraints = [conX,conY]
    }
    
    func upgradePrice() -> Int {
        guard canUpgrade() else {return -1}
        return objectType.getUpgradePriceFix(upgradeLevel)
    }
    
    func canUpgrade() -> Bool {
        return upgradeLevel < 5
    }
    
    func upgrade() {
        guard canUpgrade() else {return}
        inZone.pIG.feed(portion: objectType.getPigRateFix(upgradeLevel))
        upgradeLevel += 1
        if let force = self.children[0] as? SKFieldNode {
            force.strength *= 1.25
        } else {
            self.physicsBody?.restitution *= 1.25
        }
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
