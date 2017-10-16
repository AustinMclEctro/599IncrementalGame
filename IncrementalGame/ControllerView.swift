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
    private var _currencyA: Int = 0;
    private var currencyA: Int {
        set(val) {
            _currencyA = val;
            gameState.currencyA = currencyA;
        }
        get {
            return _currencyA;
        }
    }
    func addCurA(by: Int) {
        currencyA += by;
        infoPanel.upgradeCurrencyA(to: currencyA);
        if (shopOpen) {
            shop.updateAllowedCurrency(val: currencyA);
        }
    }
    func purchaseObject(of: GameObject, sender: UITouch?) {
        if (currencyA < of.objectType.getPrice() || !playArea.level.canAdd(type: of.objectType)) {
            return;
        }
        currencyA -= of.objectType.getPrice();
        if sender != nil {
            var locat = sender?.preciseLocation(in: playArea) ?? sender?.location(in: playArea) ?? CGPoint(x: 0, y: 0)
            playArea.addObject(of: of.objectType, at: CGPoint(x: locat.x, y: playArea.frame.height-locat.y));
        }
        else {
            // Placed at ambiguous point
            playArea.addObject(of: of.objectType, at: CGPoint(x: 0, y: 0));
        }
        
        GameState.saveGameState(gameState)
    }

    
    var infoPanel: InfoPanel;
    var playArea: PlayArea;
    var shopButton: UIButton;
    var shop: Shop;
    var shopOpen = false;
    let shopWidth: CGFloat = 250.0;
    let gameState: GameState;
    override init(frame: CGRect) {
        if GameState.loadGameState() != nil {
            self.gameState = GameState.loadGameState()!
        } else {
            gameState = GameState(2000);
        }
        
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
        self.getUserInfo();
        setupTouchEvents()
        
        infoPanel.upgradeCurrencyA(to: currencyA);
    }
    func getUserInfo() {
        currencyA = gameState.currencyA;
        
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
    func purchaseUpgrade(object: GameObject, touch: UITouch) {
        self.shop.purchaseUpgrade(object: object, touch: touch)
    }
    func openedShop() {
        shop.updateAllowedCurrency(val: currencyA);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
