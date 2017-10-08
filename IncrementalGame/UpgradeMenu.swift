//
//  UpgradeMenu.swift
//  IncrementalGame
//
//  Created by Ben Grande on 2017-10-05.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import Foundation
import SpriteKit

class UpgradeMenu: SideMenu {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //var circle = GameObject(type: .Circle);
        //addStoreItem(gameObject: circle);
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func addShape(object: GameObject, touches: Set<UITouch>, state: UIGestureRecognizerState) {
        super.addShape(object: object, touches: touches, state: state);
        if (state == .ended) {
            if let controller = superview as? ControllerView {
                controller.closeUpgrade();
            }
        }
        
    }
}
