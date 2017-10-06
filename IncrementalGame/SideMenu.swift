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
        self.isUserInteractionEnabled = true;
    }
    var itemCount = 0;
    func addStoreItem(gameObject: GameObject) {
        
        scene!.addChild(gameObject);
        gameObject.position = CGPoint(x: frame.width/2, y: frame.height-CGFloat(100*(itemCount+1)));
        gameObject.scale(to: CGSize(width: 50, height: 50));
        gameObject.touched = self.addShape;
        gameObject.isUserInteractionEnabled = true
        itemCount += 1;
        
    }
    func addShape(object: GameObject, touches: Set<UITouch>, state: UIGestureRecognizerState) {
        if (state == .ended) {
            if let controller = superview as? ControllerView {
                var touch = touches[touches.startIndex];
                controller.purchaseObject(of: object, sender: nil);
                
            }
        }
    }
    func updateAllowedCurrency(val: Int) {
        // Called every time the store is opened/currency changes while open - constant update of available items
        curA = val;
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
