//
//  GameObject.swift
//  IncrementalGame
//
//  Created by Andrew Groeneveldt on 2017-10-22.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import Foundation
import SpriteKit


class GameObject: SKSpriteNode {
    
    var objectType: ObjectType

    init(type: ObjectType) {
        objectType = type
        let im = type.getImage() ?? UIImage()
        let texture = SKTexture(image: im)
        
        super.init(texture: texture, color: UIColor.clear, size: im.size)
        self.isUserInteractionEnabled = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp(at: CGPoint, withSize: CGSize) {
        if at.x == 0 && at.y == 0 {
            self.position = CGPoint(x: withSize.width*0.5, y: withSize.height*0.5)
        } else {
            self.position = at
        }
        let dimension = withSize.width/9
        self.scale(to: CGSize(width: dimension, height: dimension))
        switch objectType {
        case .Circle, .Bumper: self.physicsBody = SKPhysicsBody(circleOfRadius: dimension/2.0)
        case .Square: self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: dimension, height: dimension))
        default: self.physicsBody = SKPhysicsBody(texture: self.texture!, size: CGSize(width: dimension, height: dimension))
        }
        self.physicsBody?.categoryBitMask = 1
        self.physicsBody?.contactTestBitMask = 1
        self.physicsBody?.collisionBitMask = 1
    }
    
    func getType() -> ObjectType {
        return objectType
    }
    
}
