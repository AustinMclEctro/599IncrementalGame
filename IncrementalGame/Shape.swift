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
    
    var withSize: CGSize // REFACTOR: Might need to remove
    
    init(type: ObjectType, at: CGPoint, withSize: CGSize) {
        self.withSize = withSize
        
        super.init(type: type)
        super.setUp(at: at, withSize: withSize)
        let rangeX: SKRange
        let rangeY: SKRange
        let dimension = withSize.width/9
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = true
        self.physicsBody?.restitution = 0.75
        self.physicsBody?.angularDamping = 0.5
        self.physicsBody?.friction = 0
        self.physicsBody?.linearDamping = 0.5
        rangeX = SKRange(lowerLimit: (dimension/2)+1, upperLimit: (withSize.width-(dimension/2)-1))
        rangeY = SKRange(lowerLimit: (dimension/2)+1, upperLimit: (withSize.height-(dimension/2)-1))
        self.physicsBody?.usesPreciseCollisionDetection = true
        let conX = SKConstraint.positionX(rangeX)
        let conY = SKConstraint.positionY(rangeY)
        self.constraints = [conX,conY]
    }
    
    // MARK: NSCoding
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("shape")
    
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
