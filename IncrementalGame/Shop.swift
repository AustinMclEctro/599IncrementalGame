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
    private var _curA = 0;
    var curA: Int {
        set(val) {
            if _curA > curA { // Purchased something
                blackout() // updateStores called by blackout
            }
            else {
                updateStores() // need to call it since not called by blackout
            }
            _curA = val;

        }
        get {
            return _curA;
        }
    }
    var itemCount = [1, 1]
    var storeItems: [[GameObject]] = [[],[]];
    var ringOne: SKShapeNode;
    var ringTwo: SKShapeNode;
    override init(frame: CGRect) {
        // Outer ring
        ringOne = SKShapeNode(ellipseIn: CGRect(x: 0, y: -frame.height, width: frame.width*2, height: frame.height*2))
        ringOne.fillColor = UIColor.green.withAlphaComponent(0.3);
        // inner ring - placed within the outer ring
        ringTwo = SKShapeNode(ellipseIn: CGRect(x: frame.width/4, y: -3*frame.height/4, width: 3*frame.width/2, height: 3*frame.height/2))
        ringTwo.fillColor = UIColor.green.withAlphaComponent(0.3);
        super.init(frame: frame)
        
        // Sets up the store scene
        presentScene(SKScene(size: frame.size))
        
        // Adds both rings
        self.scene?.addChild(ringOne);
        self.scene?.addChild(ringTwo);
        // We want a clear background so that shapes are visible behind
        scene?.backgroundColor = .clear;
        
        // All of the shapes created and added
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
        
        // Create structures
        let bumper = GameObject(type: .Bumper);
        addStoreItem(ring: 2, gameObject: bumper)
        let bumper2 = GameObject(type: .Bumper);
        addStoreItem(ring: 2, gameObject: bumper2)
        let bumper3 = GameObject(type: .Bumper);
        addStoreItem(ring: 2, gameObject: bumper3)
        self.scene?.backgroundColor = .clear;
        self.backgroundColor = .clear;
        blackout();
    }
    func blackout() {
        // Makes all shapes black, then shows only the ones that can be added
        // Should be called only when needed (purchasing objects, changing zones)
        for i in self.storeItems {
            for x in i {
                x.color = UIColor.black;
                x.colorBlendFactor = 1.0;
            }
        }
        nextLowestRing1 = 0;
        nextLowestRing2 = 0;
        updateStores()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func didMoveToSuperview() {
        
        super.didMoveToSuperview()
        /*animateIn {
         
        }*/
        blackout();
        
    }
    override func removeFromSuperview() {
        animateOut {
            super.removeFromSuperview()
        }
    }
    func animateIn(callback: @escaping () -> Void) {
        let move = SKAction.move(to: CGPoint(x: 0, y: 0), duration:0.45)
        move.timingMode = .easeOut
        self.ringOne.run(move);
        Timer.scheduledTimer(withTimeInterval: 0.15, repeats: false, block: {_ in
            self.ringTwo.run(move);
            Timer.scheduledTimer(withTimeInterval: 0.35, repeats: false, block: {_ in
                self.ringOne.position = CGPoint(x: 0, y: 0)
                self.ringTwo.position = CGPoint(x: 0, y: 0)
                callback()
            });
        });
        
    }
    func animateOut(callback: @escaping () -> Void) {
        let move = SKAction.move(to: CGPoint(x: self.frame.width, y: -self.frame.height), duration:0.5)
        move.timingMode = .easeOut
        self.ringTwo.run(move);
        Timer.scheduledTimer(withTimeInterval: 0.15, repeats: false, block: {_ in
            
            self.ringOne.run(move);
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: {_ in
                self.ringOne.position = CGPoint(x: self.frame.width, y: -self.frame.height)
                self.ringTwo.position = CGPoint(x: self.frame.width, y: -self.frame.height)
                callback()
            });
        });
    }
    let numShapes : [CGFloat] = [8.0, 5.0]
    var ringPositions: [[CGPoint]] = [[],[]];
    func addStoreItem(ring: Int, gameObject: GameObject) {
        let shapeWidth = (frame.width/numShapes[0]);
        gameObject.zPosition = 10
        ringOne.addChild(gameObject);
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
        
        let label = SKLabelNode(text: "$"+String(gameObject.objectType.getPrice()));
        label.position = point//CGPoint(x: point.x+(1.5*shapeWidth), y: point.y-shapeWidth/2);
        label.fontSize = shapeWidth/2
        label.zPosition = 11;
        ringOne.addChild(label)
    
    }
    var touchTime: NSDate?;
    var touchLoc: CGPoint?;
    func addShape(object: GameObject, touches: Set<UITouch>, state: UIGestureRecognizerState) {
        if (state == .began) {
            touchTime = NSDate();
            touchLoc = (touches.first?.location(in: self));
        }
        if (state == .ended) {
            if let controller = superview as? MasterView {
                
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
                let ring = storeItems[0].index(of: object) == nil ? 2 : 1;
                let ind = storeItems[ring-1].index(of: object) ?? 0
                let pos = ringPositions[ring-1][ind];
                object.position = pos//CGPoint(x: frame.width/2, y: frame.height-CGFloat(100*(storeItems.index(of: object)!+1)));
                self.removeFromSuperview();
                
                
            }
        }
    }
    var nextLowestRing1 = 0;
    var nextLowestRing2 = 0;
    func updateAllowedCurrency(val: Int) {
        // Called every time the store is opened/currency changes while open - constant update of available items
        curA = val;
    }
    func updateStores() {
        if let controller = superview as? MasterView {
            if (nextLowestRing1 < storeItems[0].count) {
                var storeItem1 = storeItems[0][nextLowestRing1];
                while (curA >= storeItem1.getType().getPrice()) {
                    applyFilter(item: storeItem1, controller: controller);
                    nextLowestRing1 += 1;
                    if (nextLowestRing1 >= storeItems[0].count) { // second loop condition
                        break;
                    }
                    storeItem1 = storeItems[0][nextLowestRing1];
                }
            }
            if (nextLowestRing2 < storeItems[1].count) {
                var storeItem2 = storeItems[1][nextLowestRing2];
                while (curA >= storeItem2.getType().getPrice()) {
                    applyFilter(item: storeItem2, controller: controller);
                    nextLowestRing2 += 1;
                    if (nextLowestRing2 >= storeItems[1].count) {
                        break;
                    }
                    storeItem2 = storeItems[1][nextLowestRing2];
                }
            }
            /*nextLowestRing1 = nextLowestRing1 > 0 ? nextLowestRing1 : storeItems[0].count;
             nextLowestRing2 = nextLowestRing2 > 0 ? nextLowestRing2 : storeItems[1].count;
             //for x in storeItems {
             for i in 0..<nextLowestRing1 {
             let item = storeItems[0][i];
             applyFilter(item: item, controller: controller);
             }
             for i in 0..<nextLowestRing2 {
             let item = storeItems[1][i];
             applyFilter(item: item, controller: controller);
             }*/
            
            
            
            //}
        }
    }
    func applyFilter(item: GameObject, controller: MasterView) {
        // Makes store items black or normal depending on ability to add
        if (item.objectType.getPrice() > curA || !(controller.playArea.level.canAdd(type: item.objectType))) {
            item.color = UIColor.black;
            item.colorBlendFactor = 1.0;
        }
        else {
            item.color = UIColor.gray;
            item.colorBlendFactor = 0.0;
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

