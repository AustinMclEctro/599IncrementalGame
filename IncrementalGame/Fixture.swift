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
    
    init(type: ObjectType, at: CGPoint, withSize: CGSize) {
        super.init(type: type)
        super.setUp(at: at, withSize: withSize)
        let rangeX: SKRange
        let rangeY: SKRange
        let dimension = withSize.width/9
        if objectType == .Bumper {
            self.physicsBody?.restitution = 2.5
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
