//
//  MasterViewTouchEvents.swift
//  IncrementalGame
//
//  Created by Ben Grande on 2017-10-05.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import Foundation
import UIKit


extension MasterView {
    
    /// Adds a touch event for the shop button.
    func setupTouchEvents() {
        shopButton.addTarget(self, action: #selector(tapDownStore), for: .touchDown)
    }
    
    
    /// Closes the shop by removing the view from the master view.
    func closeStore() {
        shop.removeFromSuperview()
        shopOpen = false;
    }
    
    
    /// Callback function that is called when the user presses the store button.
    /// Presents the store on the game screen.
    ///
    /// - Parameter sender: The UIButton for the store.
    @objc func tapDownStore(sender: UIButton) {
        if (!shopOpen) {
            self.addSubview(shop)
            self.addSubview(sender)
            shop.animateIn {
                
            }
        }
        else {
            shop.removeFromSuperview()
        }
        shopOpen = !shopOpen;
    }
}

