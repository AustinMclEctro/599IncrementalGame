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
    var touched: ((GameObject, Set<UITouch>, UIGestureRecognizerState) -> Void) = {
        _, _, _ in
        return
    }
    
    init(type: ObjectType) {
        objectType = type
        let im = type.getImage() ?? UIImage()
        let texture = SKTexture(image: im)
        
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
            case .Circle, .Bumper: self.physicsBody = SKPhysicsBody(circleOfRadius: dimension/2.0)
            case .Square: self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: dimension, height: dimension))
            default: self.physicsBody = SKPhysicsBody(texture: self.texture!, size: CGSize(width: dimension, height: dimension))
        }
        self.physicsBody?.categoryBitMask = 1
        self.physicsBody?.contactTestBitMask = 1
        self.physicsBody?.collisionBitMask = 1
        let rangeX: SKRange
        let rangeY: SKRange
        
        if objectType == .Bumper {
            self.physicsBody?.isDynamic = false
            self.physicsBody?.allowsRotation = false
            self.physicsBody?.restitution = 2.5
            self.physicsBody?.affectedByGravity = false //bumper is not affected by gravity
            rangeX = SKRange(lowerLimit: (dimension*2), upperLimit: (withSize.width-(dimension*2)))
            rangeY = SKRange(lowerLimit: (dimension*2), upperLimit: (withSize.height-(dimension*2)))
        } else {
            self.physicsBody?.isDynamic = true
            self.physicsBody?.allowsRotation = true
            self.physicsBody?.restitution = 0.75
            rangeX = SKRange(lowerLimit: (dimension/2)-1, upperLimit: (withSize.width-(dimension/2)+1))
            rangeY = SKRange(lowerLimit: (dimension/2)-1, upperLimit: (withSize.height-(dimension/2)+1))
        }
        
        self.physicsBody?.usesPreciseCollisionDetection = false
        
        let conX = SKConstraint.positionX(rangeX)
        let conY = SKConstraint.positionY(rangeY)
        self.constraints = [conX,conY]
    }
    
    
    func getType() -> ObjectType {
        return objectType
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touched(self, touches, .began)
        if let level = parent as? Level {
            if let playArea = level.view as? PlayArea {
                playArea.gained(amount: objectType.getPoints())
            }
        }
    }
    var movedToStore = false;
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touched(self, touches, .changed)
        self.position = touches.first!.location(in: parent!)
        self.physicsBody?.isDynamic = false
        
            if let p = parent as? Level {
                if let controller = p.view?.superview as? ControllerView {
                    if !movedToStore {
                        if !controller.shopOpen {
                            if (controller.shopButton.frame.contains(touches.first!.location(in: controller))) {
                                // In shop
                                controller.openUpgrade(object: self);
                                movedToStore = true;
                            }
                        }
                        else {
                            if (controller.shop.frame.contains(touches.first!.location(in: controller))) {
                                // In shop
                                controller.openUpgrade(object: self);
                                movedToStore = true;
                            }
                        }
                    }
                    else {
                        if !(controller.shop.frame.contains(touches.first!.location(in: controller))) {
                            
                            controller.closeUpgrade();
                            self.movedToStore = false;
                            
                        }
                        else {
                            if controller.shop.inRings(location: touches.first!.location(in: controller.shop)) {
                                controller.shop.upgradeIn(location: touches.first!.location(in: controller.shop));
                            }
                            else {
                                controller.closeUpgrade();
                                self.movedToStore = false;
                            }
                        }
                    }
                    
                }
            }
        
        
        
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touched(self, touches, .ended)
        let touch = touches.first
        let location = touch!.location(in: self)
        let last = touch!.previousLocation(in: self)
        
        let flick = CGVector(dx: location.x - last.x, dy: location.y - last.y)
        if objectType.rawValue < 10 {
            self.physicsBody?.isDynamic = true
            self.physicsBody?.applyImpulse(flick)
        }
        if (movedToStore) {
            if let p = parent as? Level {
                if let controller = p.view?.superview as? ControllerView {
                    controller.purchaseUpgrade(object: self, touch: touches.first!)
                }
            }
        }
        movedToStore = false;
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touched(self, touches, .ended)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


enum ObjectType: Int {
    case Pentagon = 5
    case Hexagon = 6
    case Star = 8
    case Circle = 9
    case Triangle = 3
    case Square = 4
    case Bumper = 10
    
    
    func getImage() -> UIImage? {
        return UIImage(named: String(describing: self))
    }
    func getPrice() -> Int {
        if self.rawValue < 10 {
            return self.rawValue * self.rawValue * 100
        } else {
            return 10000
        }
    }
    func getPoints() -> Int {
        if self.rawValue < 10 {
            return self.rawValue
        } else {
            return 0
        }
    }
}

