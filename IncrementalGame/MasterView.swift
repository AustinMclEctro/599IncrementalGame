//
//  MasterView.swift
//  IncrementalGame
//
//  Created by Ben Grande on 2017-10-05.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import Foundation
import UIKit

class MasterView: UIView {
    var infoPanel: InfoPanel;
    var playArea: PlayArea;
    var shopButton: UIButton;
    var shop: Shop;
    var shopOpen = false;
    let shopWidth: CGFloat = 250.0;
    let gameState: GameState;
    
    override init(frame: CGRect) {
        gameState = GameState(0, []);
        
        
        let heightPerc = frame.width*1.25;
        let infoHeight = frame.height-heightPerc;
        infoPanel = InfoPanel(frame: CGRect(x: 0, y: 0, width: frame.width, height: infoHeight))
        playArea = PlayArea(frame: CGRect(x: 0, y: infoHeight, width: frame.width, height: heightPerc), gameState: gameState)
        shopButton = UIButton(frame: CGRect(x: frame.width-60, y: frame.height-60, width: 50, height: 50))
        shopButton.setImage(UIImage(named: "ShopButton"), for: .normal);
        shop = Shop(frame: CGRect(x: frame.width-shopWidth, y: frame.height-shopWidth, width: shopWidth, height: shopWidth))
        super.init(frame: frame)
        
        self.addSubview(infoPanel);
        
        self.addSubview(playArea);
        self.addSubview(shopButton);
        setupTouchEvents()
        updateCurrencyA(by: 5000)
    }
    
    // Upgrades & shop
    func openUpgrade(object: GameObject) {
        
        if (!shopOpen) {
            self.addSubview(shop)
            self.addSubview(shopButton)
        }
        shop.upgradeTree(object: object)
    }
    func closeUpgrade() {
        self.shop.closeUpgradeTree();
        if (!shopOpen) {
            self.shop.removeFromSuperview();
        }
        
    }
    func updateCurrencyA(by: Int) {
        gameState.currencyA += by;
        infoPanel.upgradeCurrencyA(to: gameState.currencyA);
        if (shopOpen) {
            shop.updateStores();
        }
    }
    var currencyA: Int {
        set(val) {
            // Do we want to allow this?
        }
        get {
            return gameState.currencyA;
        }
    }
    func purchaseObject(of: GameObject, sender: UIPanGestureRecognizer?) {
        if (gameState.currencyA < of.objectType.getPrice() || !playArea.level.canAdd(type: of.objectType)) {
            return;
        }
        updateCurrencyA(by: -of.objectType.getPrice())
        if sender != nil {
            let loc = sender!.location(in: playArea); // UIView location (need to flip y)
            let location = CGPoint(x: loc.x, y: playArea.frame.height-loc.y); // Flipped y
            let vel = sender!.velocity(in: playArea); // UIView velocity (need to flip y)
            let velocity =  CGVector(dx: vel.x, dy: -vel.y);// Flopped y
            let shape = playArea.addShape(of: of.objectType, at: location);
            shape?.physicsBody?.velocity = velocity;
            
        }
        else {
            // Placed at ambiguous point
            playArea.addShape(of: of.objectType, at: CGPoint(x: 0, y: 0));
        }
        closeStore();
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

