//
//  ObjectType.swift
//  IncrementalGame
//
//  Created by Ben Grande on 2017-10-05.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import Foundation
import SpriteKit

class GameObject: SKSpriteNode {
    
    var objectType: ObjectType
    var basePoints: Int
    var touched: ((GameObject, Set<UITouch>, UIGestureRecognizerState) -> Void) = {
        _, _, _ in
        return
    }
    
    init(type: ObjectType) {
        objectType = type
        let im = type.getImage() ?? UIImage()
        let texture = SKTexture(image: im)
        if type == .Circle {
            basePoints = 1
        } else {
            basePoints = type.rawValue + 2
        }
        
        super.init(texture: texture, color: UIColor.clear, size: im.size)
        self.isUserInteractionEnabled = true
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
        case .Circle: self.physicsBody = SKPhysicsBody(circleOfRadius: dimension/2.0)
        case .Square: self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: dimension, height: dimension))
        default: self.physicsBody = SKPhysicsBody(texture: self.texture!, size: CGSize(width: dimension, height: dimension))
        }
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = true
        self.physicsBody?.restitution = 0.75
        self.physicsBody?.categoryBitMask = 1
        self.physicsBody?.contactTestBitMask = 1
        self.physicsBody?.collisionBitMask = 1
        self.physicsBody?.usesPreciseCollisionDetection = true
    }
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touched(self, touches, .began)
        if let level = parent as? Level {
            if let playArea = level.view as? PlayArea {
                playArea.gained(amount: basePoints)
            }
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touched(self, touches, .changed)
        self.position = touches.first!.location(in: parent!)
        self.physicsBody?.isDynamic = false
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touched(self, touches, .ended)
        let touch = touches.first
        let location = touch!.location(in: self)
        let last = touch!.previousLocation(in: self)
        
        let flick = CGVector(dx: location.x - last.x, dy: location.y - last.y)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.applyImpulse(flick)
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touched(self, touches, .ended)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
enum ObjectType: Int {
    case Circle
    case Triangle
    case Square
    func getImage() -> UIImage? {
        return UIImage(named: String(describing: self))
    }
}

