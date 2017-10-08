//
//  SideMenu.swift
//  IncrementalGame
//
//  Created by Ben Grande on 2017-10-05.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import Foundation
import SpriteKit

class SideMenu: SKView {
    var curA = 0;
    override init(frame: CGRect) {
        super.init(frame: frame)
        presentScene(SKScene(size: frame.size))
        //self.isUserInteractionEnabled = true;
    }
    var itemCount = 0;
    var storeItems: [GameObject] = [];
    func addStoreItem(gameObject: GameObject) {
        scene!.addChild(gameObject);
        gameObject.position = CGPoint(x: frame.width/2, y: frame.height-CGFloat(100*(itemCount+1)));
        var label = SKLabelNode(text: "$"+String(gameObject.objectType.getPrice()));
        label.position = CGPoint(x: frame.width/2, y: frame.height-CGFloat(100*(itemCount+1))-50);
        scene!.addChild(label)
        gameObject.scale(to: CGSize(width: frame.width/5, height: frame.width/5));
        gameObject.name = String(describing: gameObject.objectType);
        gameObject.touched = self.addShape;
        gameObject.isUserInteractionEnabled = true
        storeItems.append(gameObject);
        itemCount += 1;
        self.isUserInteractionEnabled = false;
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
                object.position = CGPoint(x: frame.width/2, y: frame.height-CGFloat(100*(storeItems.index(of: object)!+1)));
                
                
                
            }
        }
    }
    func updateAllowedCurrency(val: Int) {
        // Called every time the store is opened/currency changes while open - constant update of available items
        curA = val;
        let controller = superview as? ControllerView
        for i in storeItems {
            if (i.objectType.getPrice() > curA || !(controller?.playArea.level.canAdd(type: i.objectType))!) {
                i.color = UIColor.gray;
                i.colorBlendFactor = 0.9;
            }
            else {
                i.color = UIColor.gray;
                i.colorBlendFactor = 0.0;
            }
            
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
