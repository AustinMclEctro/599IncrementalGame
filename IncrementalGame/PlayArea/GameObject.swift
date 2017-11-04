//
//  GameObject.swift
//  IncrementalGame
//
//  Created by Andrew Groeneveldt on 2017-10-22.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import Foundation
import SpriteKit


/// A SKSpriteNode for objects that is used in gameplay (ie. Shapes and Fixtures).
/// Contains common methods and properties for setting position, size and physics.
class GameObject: SKSpriteNode {
    
    var objectType: ObjectType

    init(type: ObjectType) {
        objectType = type
        
        // Configure the appearance of the object
        let im = type.getImage() ?? UIImage()
        let texture = SKTexture(image: im)
        
        super.init(texture: texture, color: UIColor.clear, size: im.size)
        
        self.isUserInteractionEnabled = true
    }
    
    
    /// A helper method used to set up a GameObject by configuring its starting
    /// position, dimensions and its physics body.
    ///
    /// - Parameters:
    ///   - at: The position at which the GameObject was placed on the game screen.
    ///   - withSize: The size of the zone/play area.
    func setUp(at: CGPoint, withSize: CGSize) {
        // Set starting position
        if at.x == 0 && at.y == 0 {
            self.position = CGPoint(x: withSize.width*0.5, y: withSize.height*0.5)
        } else {
            self.position = at
        }
        
        // Set size depending on screen dimensions
        let dimension = withSize.width/9
        self.scale(to: CGSize(width: dimension, height: dimension))
        
        // Configure physics body settings relative to the shape
        switch objectType {
            case .Circle, .Bumper, .Graviton, .Vortex:
                self.physicsBody = SKPhysicsBody(circleOfRadius: dimension/2.0)
            case .Square:
                self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: dimension, height: dimension))
            default:
                self.physicsBody = SKPhysicsBody(texture: self.texture!, size: CGSize(width: dimension, height: dimension))
        }
        
        self.physicsBody?.categoryBitMask = 1
        self.physicsBody?.contactTestBitMask = 1
        self.physicsBody?.collisionBitMask = 1
    }
    
    func getType() -> ObjectType {
        return objectType
    }
    
    
    // MARK: NSCoding
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
