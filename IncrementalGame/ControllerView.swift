//
//  ControllerView.swift
//  IncrementalGame
//
//  Created by Ben Grande on 2017-10-05.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import Foundation
import UIKit

class ControllerView: UIView {
    var infoPanel: InfoPanel;
    var shapeMenu: ShapeMenu;
    var upgradeMenu: UpgradeMenu;
    var playArea: PlayArea;
    override init(frame: CGRect) {
        infoPanel = InfoPanel(frame: CGRect(x: 0, y: 0, width: frame.width, height: 100))
        shapeMenu = ShapeMenu(frame: CGRect(x: -100, y: 0, width: 100, height: frame.height));
        upgradeMenu = UpgradeMenu(frame: CGRect(x: frame.width, y: 0, width: 100, height: frame.height));
        playArea = PlayArea(frame: CGRect(x: 0, y: 100, width: frame.width, height: frame.height-100))
        
        infoPanel.backgroundColor = UIColor.red;
        playArea.backgroundColor = UIColor.blue;
        
        super.init(frame: frame)
        
        self.addSubview(infoPanel);
        self.addSubview(shapeMenu);
        self.addSubview(upgradeMenu);
        self.addSubview(playArea);
        
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panned)))
    }
    @objc func panned(sender: UIPanGestureRecognizer) {
        var vel = sender.velocity(in: self);
        if (vel.x > 0) {
            shapeMenu.frame = CGRect(x: 0, y: 0, width: 100, height: frame.height)
        }
        else {
            upgradeMenu.frame = CGRect(x: frame.width-100, y: 0, width: 100, height: frame.height)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
