//
//  Shope.swift
//  IncrementalGame
//
//  Created by Ben Grande on 2017-10-12.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import Foundation
import SpriteKit

class Shop: SKView {
    var curA = 0;
    var itemCount = [1, 1]
    var storeItems: [[GameObject]] = [[],[]];
    var ringOne: SKShapeNode;
    var ringTwo: SKShapeNode;
    override init(frame: CGRect) {
        
        ringOne = SKShapeNode(ellipseIn: CGRect(x: 0, y: -frame.height, width: frame.width*2, height: frame.height*2))//SKShapeNode(color: .green, size: frame.width*2)//SKSpriteNode(frame: CGRect(x: 0, y: 0, width: frame.width*2, height: frame.height*2))
        //ringOne.layer.cornerRadius = frame.width;
        ringTwo = SKShapeNode(ellipseIn: CGRect(x: frame.width/4, y: -3*frame.height/4, width: 3*frame.width/2, height: 3*frame.height/2))
        super.init(frame: frame)
        ringOne.fillColor = UIColor.green.withAlphaComponent(0.3);
        ringTwo.fillColor = UIColor.green.withAlphaComponent(0.3);
        
        presentScene(SKScene(size: frame.size))
        self.scene?.addChild(ringOne);
        self.scene?.addChild(ringTwo);
        scene?.backgroundColor = .clear;
        
        let triangle = GameObject(type: .Triangle);
        let square = GameObject(type: .Square);
        let pentagon = GameObject(type: .Pentagon);
        let hexagon = GameObject(type: .Hexagon);
        let circle = GameObject(type: .Circle);
        let star = GameObject(type: .Star);
        
        addStoreItem(ring: 1, gameObject: triangle);
        addStoreItem(ring: 1, gameObject: square);
        addStoreItem(ring: 1, gameObject: pentagon);
        addStoreItem(ring: 1, gameObject: hexagon);
        addStoreItem(ring: 1, gameObject: circle);
        addStoreItem(ring: 1, gameObject: star);

        let bumper = GameObject(type: .Bumper);
        addStoreItem(ring: 2, gameObject: bumper)
        let bumper2 = GameObject(type: .Bumper);
        addStoreItem(ring: 2, gameObject: bumper2)
        let bumper3 = GameObject(type: .Bumper);
        addStoreItem(ring: 2, gameObject: bumper3)
        self.scene?.backgroundColor = .clear;
        self.backgroundColor = .clear;
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateIn() {
        
    }
    let numShapes : [CGFloat] = [8.0, 5.0]
    var ringPositions: [[CGPoint]] = [[],[]];
    func addStoreItem(ring: Int, gameObject: GameObject) {
        var shapeWidth = (frame.width/numShapes[0]);
        scene!.addChild(gameObject);
        //degrees * M_PI / 180.0
        let rad = CGFloat.pi-(CGFloat.pi*CGFloat(itemCount[ring-1])/(numShapes[ring-1]*2.0));
        
        let ringWidth = (frame.width*(2/CGFloat(ring+1))-(1.8*shapeWidth))
        
        let point = CGPoint(x: frame.width+cos(rad)*ringWidth-(shapeWidth/2), y: sin(rad)*ringWidth+(shapeWidth/2))
        ringPositions[ring-1].append(point);
        gameObject.position = point;
        
        gameObject.scale(to: CGSize(width: shapeWidth, height: shapeWidth));
        gameObject.name = String(describing: gameObject.objectType);
        gameObject.touched = self.addShape;
        gameObject.isUserInteractionEnabled = true
        storeItems[ring-1].append(gameObject);
        itemCount[ring-1] += 1;
        self.isUserInteractionEnabled = true;
        
        var label = SKLabelNode(text: "$"+String(gameObject.objectType.getPrice()));
        label.position = point//CGPoint(x: point.x+(1.5*shapeWidth), y: point.y-shapeWidth/2);
        label.fontSize = shapeWidth/2
        scene!.addChild(label)
    }
    var touchTime: NSDate?;
    var touchLoc: CGPoint?;
    func addShape(object: GameObject, touches: Set<UITouch>, state: UIGestureRecognizerState) {
        if (state == .began) {
            touchTime = NSDate();
            touchLoc = (touches.first?.location(in: self));
        }
        if (state == .ended) {
            if let controller = superview as? ControllerView {
                
                let touch = touches[touches.startIndex];
                let touchLocation = touch.location(in: self);
                if (abs(touchLoc!.x - touchLocation.y) < 20 && abs(touchLoc!.y - touchLocation.y) < 20) {
                    if (Double((touchTime?.timeIntervalSinceNow)!) > -0.5) {
                        // Tap
                        controller.purchaseObject(of: object, sender: nil);
                    }
                    else {
                        return; // Cancel
                    }
                }
                else {
                    controller.purchaseObject(of: object, sender: touches.first);
                    
                }
                var ring = storeItems[0].index(of: object) == nil ? 2 : 1;
                let ind = storeItems[ring-1].index(of: object) ?? 0
                var pos = ringPositions[ring-1][ind];
                object.position = pos//CGPoint(x: frame.width/2, y: frame.height-CGFloat(100*(storeItems.index(of: object)!+1)));
                self.removeFromSuperview();
                
                
            }
        }
    }
    func updateAllowedCurrency(val: Int) {
        // Called every time the store is opened/currency changes while open - constant update of available items
        curA = val;
        if let controller = superview as? ControllerView {
            for x in storeItems {
                for i in x {
                    //BUG: controller is sometimes being passed as a nil value and crashing the game, commented out for now
                    if (i.objectType.getPrice() > curA || !(controller.playArea.level.canAdd(type: i.objectType))) {
                        i.color = UIColor.black;
                        i.colorBlendFactor = 1.0;
                    }
                    else {
                        i.color = UIColor.gray;
                        i.colorBlendFactor = 0.0;
                    }
                }
                
                
            }
        }
    }
    var upgradeRingOne: SKShapeNode?;
    var upgradeLabelOne: SKLabelNode?;
    var upgradeRingTwo: SKShapeNode?;
    var upgradeLabelTwo: SKLabelNode?;
    
    func upgradeTree(object: GameObject) {
        
        if upgradeRingOne == nil {
            upgradeRingOne = SKShapeNode(ellipseIn: ringOne.frame);
            upgradeRingOne?.fillColor = .darkGray;
            upgradeLabelOne = SKLabelNode(text: "Upgrade 1");
            upgradeLabelOne?.zRotation = CGFloat.pi/4
            upgradeRingOne?.addChild(upgradeLabelOne!);
            upgradeLabelOne?.position = CGPoint(x: frame.width/2.5, y: 1.5*frame.height/2.5)
            
            upgradeRingTwo = SKShapeNode(ellipseIn: ringTwo.frame);
            upgradeRingTwo?.fillColor = .darkGray;
            upgradeLabelTwo = SKLabelNode(text: "Upgrade 2");
            upgradeLabelTwo?.zRotation = CGFloat.pi/4
            upgradeRingTwo?.addChild(upgradeLabelTwo!);
            upgradeLabelTwo?.position = CGPoint(x: 3*frame.width/4, y: frame.height/4)
        }
        self.scene?.addChild(upgradeRingOne!);
        self.scene?.addChild(upgradeRingTwo!);
    }
    func closeUpgradeTree() {
        upgradeRingTwo?.removeFromParent();
        upgradeRingOne?.removeFromParent();
    }
    func inRings(location: CGPoint) -> Bool {
        let loc = CGPoint(x: frame.width-location.x, y: frame.height-location.y);
        
        let asq = pow(loc.y, 2)
        let bsq = pow(loc.x, 2)
        let c = pow(asq+bsq, 0.5)*2
        if c < ringOne.frame.width  {
            return true
        }
        return false
    }
    func upgradeIn(location: CGPoint) {
        let loc = CGPoint(x: frame.width-location.x, y: frame.height-location.y);
        
        let asq = pow(loc.y, 2)
        let bsq = pow(loc.x, 2)
        let c = pow(asq+bsq, 0.5)*2
        if c < ringTwo.frame.width {
            upgradeRingOne?.fillColor = .darkGray
            upgradeRingTwo?.fillColor = .gray;
            
        }
        else if c < ringOne.frame.width  {
            upgradeRingTwo?.fillColor = .darkGray;
            upgradeRingOne?.fillColor = .gray;
        }
    }
    func purchaseUpgrade(object: GameObject, touch: UITouch) {
        closeUpgradeTree();
        self.removeFromSuperview()
    }
}
