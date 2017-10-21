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
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinchSelf))
        self.addGestureRecognizer(pinch);
    }
    func closeStore() {
        
    }
    
    @objc func tapDownStore(sender: UIButton) {
        if (!shopOpen) {
            self.addSubview(shop)
            self.addSubview(sender)
            openedShop();
        }
        else {
            shop.removeFromSuperview()
        }
        shopOpen = !shopOpen;
        
    }
    
    @objc func pinchSelf(sender: UIPinchGestureRecognizer) {
        let scale = sender.scale
        
        switch sender.state {
        case .began:
            if (tableSceneView == nil) {
                tableSceneView = SceneTableView(frame: CGRect(x: -100, y: -100, width: frame.width+200, height: frame.height+200))
            }
            tableSceneView!.setZones(zones: playArea.zones);
            self.addSubview(tableSceneView!);
        case .changed:
            if (tableOpen) {
                
                tableSceneView?.alpha = scale;
                let dif = 200*(1-scale);
                tableSceneView!.frame = CGRect(x: dif, y: dif, width: frame.width+(dif*2), height: frame.height+(dif*2));
            }
            else {
                let maxScale = min(scale, 2);
                let opacity = min(scale-1, 1);
                tableSceneView?.alpha = opacity;
                let dif = 100-50*maxScale;
                tableSceneView!.frame = CGRect(x: dif, y: dif, width: frame.width+(dif*2), height: frame.height+(dif*2));
            }
        default:
            if scale >= 1.5 {
                tableSceneView!.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height);
                tableOpen = true;
            }
            else {
                tableSceneView?.removeFromSuperview();
                tableOpen = false;
            }
        }
        
        
        
        
    }

    
   
}
