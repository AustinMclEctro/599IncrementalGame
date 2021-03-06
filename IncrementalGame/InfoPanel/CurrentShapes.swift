//
//  CurrentShapes.swift
//  IncrementalGame
//
//  Created by Ben Grande on 2017-11-10.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class CurrentShapes: SKView {
    
    // MARK: Properties
    
    var shapes: [Shape] = [];
    var fixtures: [Fixture] = [];
    
    var feedbackGenerator = UIImpactFeedbackGenerator();
    
    var selectedObjectTemp: StoreItem?;
    var selectedObject: StoreItem?;
    
    
    // MARK: Initializers
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let scene = SKScene(size: frame.size);
        self.presentScene(scene);
        NotificationCenter.default.addObserver(self, selector: #selector(shapesChanged), name: NSNotification.Name(rawValue: Notification.Name.shapesChanged), object: nil)
        scene.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(drag)))
    }
    
    
    // MARK: Functions
    
    
    func drawObjects() {
        var counter = 3*CGFloat.pi/4;
        let incr = (CGFloat.pi)/CGFloat(shapes.count)
        let halfWidth = frame.width/2;
        
        let imSize = CGSize(width: (frame.width/8.5), height: (frame.width/8.5))
        let hypot = halfWidth - (imSize.width/2)
        
        for child in scene!.children {
            child.removeFromParent()
        }
        for shape in shapes {
            
            let tempShape = StoreItem(obj: shape)//SKSpriteNode(texture: SKTexture(image: shape.objectType.getImage()!))
            let x = cos(counter)*hypot
            let y = sin(counter)*hypot
            let pt = CGPoint(x: halfWidth+x, y: halfWidth+y);
            
            scene!.addChild(tempShape);
            tempShape.physicsBody = nil;
            tempShape.color = .red
            
            tempShape.size = imSize
            tempShape.position = pt
            
            counter += incr
            
        }
        counter = CGFloat.pi/4;
        for fixture in fixtures {
            let tempShape = StoreItem(obj: fixture);//SKSpriteNode(texture: SKTexture(image: fixture.objectType.getImage()!))
            let x = cos(counter)*hypot
            let y = sin(counter)*hypot
            let pt = CGPoint(x: halfWidth+x, y: halfWidth+y);
            
            scene!.addChild(tempShape);
            tempShape.physicsBody = nil;
            tempShape.color = .red
            
            tempShape.size = imSize
            tempShape.position = pt
            
            counter -= incr
        }
        self.backgroundColor = .clear;
        self.scene?.backgroundColor = .clear;
    }
    
    
    @objc func shapesChanged(sender: Notification) {
        if let zone = sender.userInfo?["zone"] as? Zone {
            shapes = [];
            fixtures = [];
            for child in zone.children {
                if let shape = child as? Shape {
                    shapes.append(shape);
                }
                else if let fixture = child as? Fixture {
                    fixtures.append(fixture);
                }
            }
        }
        drawObjects();
    }
    

    @objc func drag(sender: UIPanGestureRecognizer) {
        
        switch sender.state {
        case .began:
            let location = CGPoint(x: sender.location(in: self).x, y: frame.height-sender.location(in: self).y)
            let nodes = scene?.nodes(at: location) ?? []
            if (nodes.count > 0) {
                var node: StoreItem?;
                var counter = 0;
                while node == nil && counter < nodes.count {
                    node = nodes[0] as? StoreItem
                    
                    counter += 1;
                }
                if (node == nil) {
                    return;
                }
                feedbackGenerator.prepare();
                feedbackGenerator.impactOccurred();
                selectedObjectTemp = node!.copy() as? StoreItem
                selectedObject = node
                selectedObject?.color = UIColor.black;
                selectedObject?.colorBlendFactor = 1.0;
                self.scene?.addChild(selectedObjectTemp!)
            }
            
            break;
        case .changed:
            
            let location = CGPoint(x: sender.location(in: self).x, y: self.frame.height-sender.location(in: self).y)
            if (selectedObjectTemp != nil) {
                selectedObjectTemp?.position = location;
            }
            
            break;
        default: // ended, canceled etc.
            selectedObjectTemp?.removeFromParent()
            selectedObjectTemp = nil;
            selectedObject?.colorBlendFactor = 0
            selectedObject = nil;
            break;
        }
    }
 
    
    // MARK: NSCoding
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
