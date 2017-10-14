//
//  ControllerViewTouchEvents.swift
//  IncrementalGame
//
//  Created by Ben Grande on 2017-10-05.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import Foundation
import UIKit
extension ControllerView {
    func setupTouchEvents() {
        shopButton.addTarget(self, action: #selector(tapDownStore), for: .touchDown)
    }
    func closeStore() {
        
    }
    
    @objc func tapDownStore(sender: UIButton) {
        if (!shopOpen) {
            self.addSubview(shop)
            shop.animateIn();
            self.addSubview(sender)
            openedShop();
            
        }
        else {
            shop.removeFromSuperview()
        }
        shopOpen = !shopOpen;
        
    }

    
   
}
