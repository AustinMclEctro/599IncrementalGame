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
    
    var objectType: ObjectType      // TO SAVE
    var dimension: CGFloat          // TO SAVE
    //var emitter = SKEmitterNode(fileNamed: "MyParticle.sks")
    
    
    // MARK: Initializers

    
    init(type: ObjectType, at: CGPoint, zoneSize: CGSize) {
        objectType = type
        
        // Configure the appearance of the object
        let im = type.getImage() ?? UIImage()
        let texture = SKTexture(image: im)
        dimension = 1

        super.init(texture: texture, color: UIColor.clear, size: im.size)
        
        self.isUserInteractionEnabled = true
        
        // Set starting position
        if at.x == 0 && at.y == 0 {
            self.position = CGPoint(x: zoneSize.width*0.5, y: zoneSize.height*0.5)
        } else {
            self.position = at
        }
        
        // Set size depending on screen dimensions
        dimension = zoneSize.width/9
        self.scale(to: CGSize(width: dimension, height: dimension))
        
        // Configure physics body settings relative to the shape
        switch objectType {
        case .Circle, .Bonus, .Graviton, .Vortex:
            self.physicsBody = SKPhysicsBody(circleOfRadius: dimension/2.0)
        case .Square:
            self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: dimension, height: dimension))
        default:
            self.physicsBody = SKPhysicsBody(texture: self.texture!, size: CGSize(width: dimension, height: dimension))
        }
        
    }

    
    init(type: ObjectType) {
        objectType = type
        
        // Configure the appearance of the object
        let im = type.getImage() ?? UIImage()
        let texture = SKTexture(image: im)
        dimension = 1
        
        super.init(texture: texture, color: UIColor.clear, size: im.size)
    }
    
    
    // MARK: Functions
    
    
    func getType() -> ObjectType {
        return objectType
    }
    
    
    // MARK: NSCoding
    
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
