//
//  Shape.swift
//  IncrementalGame
//
//  Created by Andrew Groeneveldt on 2017-10-22.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import Foundation
import SpriteKit

class Shape: GameObject {
    
    init(type: ObjectType, at: CGPoint, withSize: CGSize) {
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
