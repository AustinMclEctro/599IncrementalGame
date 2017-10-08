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
        let panLeft = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(shapeToggle));
        panLeft.isEnabled = true;
        panLeft.edges = .left;
        self.addGestureRecognizer(panLeft)
        
        let panRight = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(upgradeToggle));
        panRight.edges = .right;
        panRight.isEnabled = true;
        self.addGestureRecognizer(panRight);
        
        /*let closeShape = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(shapeClose))
        closeShape.edges = .right;
        shapeMenu.addGestureRecognizer(closeShape);
        
        let closeUpgrade = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(upgradeClose))
        closeUpgrade.edges = .left;
        shapeMenu.addGestureRecognizer(closeUpgrade);*/
        
        shapeButton.addTarget(self, action: #selector(clickShape), for: .touchUpInside)
        upgradeButton.addTarget(self, action: #selector(clickUpgrade), for: .touchUpInside)
    }
    func closeShape() {
        clickShape(sender: UIButton());
    }
    func closeUpgrade() {
        clickUpgrade(sender: UIButton());
    }
    @objc func clickShape(sender: UIButton) {
        if shapeOpen {
            shapeMenu.frame = CGRect(x: -200, y: 0, width: 200, height: frame.height);
            shapeOpen = false;
        }
        else {
            shapeMenu.frame = CGRect(x: 0, y: 0, width: 200, height: frame.height);
            shapeOpen = true;
        }
        shapeButton.frame = CGRect(x: shapeMenu.frame.maxX, y: shapeButton.frame.minY, width: shapeButton.frame.width, height: shapeButton.frame.height);
        updateMenuS();
        shapeMenu.scene?.isUserInteractionEnabled = true;
        shapeMenu.isUserInteractionEnabled = true;
    }
    @objc func clickUpgrade(sender: UIButton) {
        if upgradeOpen {
            upgradeMenu.frame = CGRect(x: frame.width, y: 0, width: 200, height: frame.height);
            upgradeOpen = false;
        }
        else {
            upgradeMenu.frame = CGRect(x: frame.width-200, y: 0, width: 200, height: frame.height);
            upgradeOpen = true;
            
        }
        upgradeButton.frame = CGRect(x: upgradeMenu.frame.minX-50, y: upgradeButton.frame.minY, width: upgradeButton.frame.width, height: upgradeButton.frame.height)
        updateMenuU();
    }
    @objc func upgradeClose(sender: UIScreenEdgePanGestureRecognizer) {
        print("HERE");
    }
    @objc func shapeClose(sender: UIScreenEdgePanGestureRecognizer) {
        print("HERE")
    }
    @objc func upgradeToggle(sender: UIScreenEdgePanGestureRecognizer) {
        let left = max(sender.location(in: self).x, frame.width-200);
        if (upgradeOpen) {
            return;
        }
        switch sender.state {
        case .began:
            break;
        case .changed:
            upgradeMenu.frame = CGRect(x: left, y: 0, width: 200, height: frame.height);
            break;
        default:
            print(left);
            if (left < frame.width-100) {
                upgradeMenu.frame = CGRect(x: frame.width-200, y: 0, width: 200, height: frame.height);
                upgradeOpen = true;
            }
            else {
                upgradeMenu.frame = CGRect(x: frame.width, y: 0, width: 200, height: frame.height);
                upgradeOpen = false;
            }
            break;
        }
        upgradeButton.frame = CGRect(x: upgradeMenu.frame.minX-50, y: upgradeButton.frame.minY, width: upgradeButton.frame.width, height: upgradeButton.frame.height)
         updateMenuU();
    }
    
    @objc func shapeToggle(sender: UIScreenEdgePanGestureRecognizer) {
        
        let left = min(-200 + sender.location(in: self).x, 0);
        if (shapeOpen) {
            return;
        }
        switch sender.state {
        case .began:
            break;
        case .changed:
            shapeMenu.frame = CGRect(x: left, y: 0, width: 200, height: frame.height);
            break;
        default:
            print(left);
            if (left > -100) {
                shapeMenu.frame = CGRect(x: 0, y: 0, width: 200, height: frame.height);
                shapeOpen = true;
            }
            else {
                shapeMenu.frame = CGRect(x: -200, y: 0, width: 200, height: frame.height);
                shapeOpen = false;
            }
            break;
        }
        shapeButton.frame = CGRect(x: shapeMenu.frame.maxX, y: shapeButton.frame.minY, width: shapeButton.frame.width, height: shapeButton.frame.height)
         updateMenuS();
    }
}
