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
    private var currencyA = 0;
    func addCurA(by: Int) {
        currencyA += by;
        infoPanel.upgradeCurrencyA(to: currencyA);
        if shapeOpen {
            shapeMenu.updateAllowedCurrency(val: currencyA);
        }
        if upgradeOpen {
            upgradeMenu.updateAllowedCurrency(val: currencyA);
        }
    }
    func purchaseObject(of: GameObject, sender: UITouch?) {
        if sender != nil {
            playArea.addObject(of: of.objectType, at: sender!.location(in: playArea));
        }
        else {
            // Placed at ambiguous point
            playArea.addObject(of: of.objectType, at: CGPoint(x: 0, y: 0));
        }
    }
    func updateMenuU() {
        upgradeMenu.updateAllowedCurrency(val: currencyA);
    }
    func updateMenuS() {
        shapeMenu.updateAllowedCurrency(val: currencyA);
    }
    
    var infoPanel: InfoPanel;
    var shapeMenu: ShapeMenu;
    var upgradeMenu: UpgradeMenu;
    var playArea: PlayArea;
    
    var shapeButton: UIButton;
    var upgradeButton: UIButton;
    var userDefaults: UserDefaults;
    override init(frame: CGRect) {
        userDefaults = UserDefaults();
        
        
        
        
        let heightPerc = frame.width*1.25;
        let infoHeight = frame.height-heightPerc;
        infoPanel = InfoPanel(frame: CGRect(x: 0, y: 0, width: frame.width, height: infoHeight))
        shapeMenu = ShapeMenu(frame: CGRect(x: -200, y: 0, width: 200, height: frame.height));
        upgradeMenu = UpgradeMenu(frame: CGRect(x: frame.width, y: 0, width: 100, height: frame.height));
        playArea = PlayArea(frame: CGRect(x: 0, y: infoHeight, width: frame.width, height: heightPerc))
        
        shapeMenu.layer.zPosition = 3000;
        upgradeMenu.layer.zPosition = 3000;
        
        shapeButton = UIButton(frame: CGRect(x: 0, y: 100, width: 50, height: 100))
        upgradeButton = UIButton(frame: CGRect(x: frame.width-50, y: 100, width: 50, height: 100))
        
        shapeButton.backgroundColor = UIColor.darkGray;
        upgradeButton.backgroundColor = UIColor.darkGray;
        
        super.init(frame: frame)
        
        self.getUserInfo();
        
        self.addSubview(infoPanel);
        self.addSubview(shapeMenu);
        self.addSubview(upgradeMenu);
        self.addSubview(playArea);
        setupTouchEvents()
        
        self.addSubview(shapeButton);
        self.addSubview(upgradeButton);
        infoPanel.upgradeCurrencyA(to: currencyA)
    }
    func getUserInfo() {
        let curA = userDefaults.integer(forKey: "currencyA")
        if (curA == nil) {
            userDefaults.set(currencyA, forKey: "currencyA");
        }
        else {
            currencyA = curA;
        }
        let shapes = userDefaults.array(forKey: "shapes") as? [[String: String]] ?? [];
        if (shapes != nil) {
            playArea.setShapes(shapes)
        }
        else {
            userDefaults.set([], forKey: "shapes")
        }
        
    }
    var shapeOpen = false;
    var upgradeOpen = false;
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
