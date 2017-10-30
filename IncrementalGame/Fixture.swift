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
    
    var withSize: CGSize  // REFACTOR: This might not need to be stored
    
    init(type: ObjectType, at: CGPoint, withSize: CGSize) {
        self.withSize = withSize
        
        super.init(type: type)
        super.setUp(at: at, withSize: withSize)
        let rangeX: SKRange
        let rangeY: SKRange
        let dimension = withSize.width/9
        if objectType == .Bumper {
            self.physicsBody?.restitution = 2.5
        }
        if objectType == .Graviton {
            let grav = SKFieldNode.radialGravityField()
            grav.categoryBitMask = 1
            grav.isEnabled = true
            grav.strength = 20
            self.addChild(grav)
        }
        if objectType == .Vortex {
            let vort = SKFieldNode.vortexField()
            vort.categoryBitMask = 1
            vort.isEnabled = true
            vort.strength = 10
            self.addChild(vort)
        }
        self.physicsBody?.isDynamic = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.affectedByGravity = false //bumper is not affected by gravity
        rangeX = SKRange(lowerLimit: (dimension*2), upperLimit: (withSize.width-(dimension*2)))
        rangeY = SKRange(lowerLimit: (dimension*2), upperLimit: (withSize.height-(dimension*2)))
        self.physicsBody?.usesPreciseCollisionDetection = true
        let conX = SKConstraint.positionX(rangeX)
        let conY = SKConstraint.positionY(rangeY)
        self.constraints = [conX,conY]
    }
    
    // MARK: NSCoding
    // REFACTOR: Move to GameObject
    
    /// Keys used to reference the properties in memory
    struct PropertyKey {
        static let objectType = "objectType"
        static let lastPosition = "lastPosition"
        static let levelSize = "levelSize"
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        try? (aCoder as! NSKeyedArchiver).encodeEncodable(objectType, forKey: PropertyKey.objectType)
        aCoder.encode(self.position, forKey: PropertyKey.lastPosition)
        aCoder.encode(self.withSize, forKey: PropertyKey.levelSize)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let objectType = (aDecoder as! NSKeyedUnarchiver).decodeDecodable(ObjectType.self, forKey: PropertyKey.objectType)
        let lastPosition = aDecoder.decodeCGPoint(forKey: PropertyKey.lastPosition)
        let withSize = aDecoder.decodeCGSize(forKey: PropertyKey.levelSize)
        
        self.init(type: objectType!, at: lastPosition, withSize: withSize)
    }
}
