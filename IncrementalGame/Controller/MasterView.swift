//
//  MasterView.swift
//  IncrementalGame
//
//  Created by Ben Grande on 2017-10-05.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import Foundation
import UIKit
import os.log

// TODO: Is there another way to distinguish between adding fixtures and shapes?

/// The master view for the app. Contains a number of subviews including a
/// view for the InfoPanel, the PlayArea and the Shop. It also contains the GameState.
class MasterView: UIView {
    var zoomingTo: CGRect?;
    
    var infoPanel: InfoPanel;
    var playAreaFrame: CGRect;
    var playArea: PlayArea;
    var sceneCollection: SceneCollectionView;
    let scenePreviewButton: UIButton;
    var sceneOpen = false;
    var shopButton: UIButton;
    var shop: Shop;
    var shopOpen = false;
    let shopWidth: CGFloat = 250.0;
    let gameState: GameState;
    let gravButton: UIButton
    let resetButton: UIButton;
    
    
    var currencyA: Int {
        set(val) {
            // Do we want to allow this?
        }
        get {
            return gameState.currencyA;
        }
    }
    
    var feedbackGenerator: UISelectionFeedbackGenerator;
    override init(frame: CGRect) {
        if let savedGameState = GameState.loadGameState() {
            gameState = savedGameState
        } else {
            var player = Player(id: 1)
            gameState = GameState(5000, [], player)
        }
        
        
        
        
        // Configure and create the subviews
        let heightPerc = frame.width;//*1.25; // For the PlayArea
        let infoHeight = frame.height-heightPerc-60; // For the info panel
        infoPanel = InfoPanel(frame: CGRect(x: 0, y: 0, width: frame.width, height: infoHeight))
        playAreaFrame = CGRect(x: 0, y: infoHeight, width: frame.width, height: heightPerc);
        playArea = PlayArea(frame: playAreaFrame, gameState: gameState)
        sceneCollection = SceneCollectionView(frame: playAreaFrame, gameState: gameState);
        scenePreviewButton = UIButton(frame: CGRect(x: 0, y: frame.height-60, width: 50, height: 50))
        scenePreviewButton.setImage(UIImage(named: "PreviewButton"), for: .normal)
        shopButton = UIButton(frame: CGRect(x: frame.width-60, y: frame.height-60, width: 50, height: 50))
        shopButton.setImage(UIImage(named: "ShopButton"), for: .normal);
        shop = Shop(frame: CGRect(x: frame.width-shopWidth, y: frame.height-shopWidth, width: shopWidth, height: shopWidth))

        gravButton = UIButton(frame: CGRect(x: frame.width-60, y: 0, width: 50, height: 50))
        gravButton.setImage(UIImage(named: "Gravity"), for: .normal);
        
        // Configure the reset button
        resetButton =  UIButton(frame: CGRect(x: 5, y: 25, width: frame.width/3, height: 20))
        resetButton.setTitle("Reset", for: .normal)
        resetButton.setTitleColor(UIColor.white, for: .normal)
        
        feedbackGenerator = UISelectionFeedbackGenerator();
        feedbackGenerator.prepare();
        
        super.init(frame: frame)
        self.backgroundColor = UIColor.black;
        self.addSubview(infoPanel);
        self.addSubview(sceneCollection);
        infoPanel.upgradeCurrencyA(to: self.currencyA)
        self.addSubview(playArea);
        self.addSubview(shopButton);
        self.addSubview(gravButton)
        self.addSubview(scenePreviewButton);
        self.addSubview(resetButton);
        
        // Subscribe to applicationWillResignActive notification
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(MasterView.saveGame), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        
        setupTouchEvents()
    }
    
    
    /// Opens the upgrade tree for a specified GameObject.
    ///
    /// - Parameter object: The GameObject that is being upgraded.
    func openUpgrade(object: GameObject) {
        
        if (!shopOpen) {
            self.addSubview(shop)
            self.addSubview(shopButton)
        }
        shop.upgradeTree(object: object)
    }
    
    
    /// Closes the upgrade tree.
    func closeUpgrade() {
        self.shop.closeUpgradeTree();
        if (!shopOpen) {
            self.shop.removeFromSuperview();
        }
        
    }
    
    
    /// Updates the value for currencyA. Used for shop purchases.
    ///
    /// - Parameter by: The amount to add to currencyA
    func updateCurrencyA(by: Int) { // REFACTOR: Could this be moved to GameState and combined with Gained in PlayArea?
        gameState.currencyA += by;
        infoPanel.upgradeCurrencyA(to: gameState.currencyA);
        if (shopOpen) {
            shop.updateStores();
        }
    }
    
    
    /// Purchases an object for gameplay and adds the object to the playarea.
    ///
    /// - Parameters:
    ///   - of: The GameObject that is being purchased.
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
            if !of.objectType.isFixture() {
                let shape = playArea.addShape(of: of.objectType, at: location);
                shape?.physicsBody?.velocity = velocity;
            }
            else {
                playArea.addFixture(of: of.objectType, at: location);
            }
            
        }
        else {
            // Placed at ambiguous point
            let location =  CGPoint(x: 0, y: 0);
            if !of.objectType.isFixture() {
                playArea.addShape(of: of.objectType, at: location);
            }
            else {
                playArea.addFixture(of: of.objectType, at: location);
            }
        }
        
        closeStore();
    }
    func selectZone(index: Int) {
        playArea.removeFromSuperview();
        self.addSubview(playArea);
        
        playArea.selectZone(index: index);
        var fr = sceneCollection.zoomingTo(index: playArea.zoneNumber)
        playArea.frame = CGRect(x: playAreaFrame.minX+fr.minX, y: playAreaFrame.minY+fr.minY, width: fr.width, height: fr.height)
        transitionToClose()
        self.addSubview(shopButton)
        self.addSubview(scenePreviewButton)
    }
    func createZone() {
        let level = Zone(size: playAreaFrame.size, zone0: false, children: [], pIG: nil, allowedObjects: nil)
        gameState.zones.append(level)
        // TODO - change this with gameState newZonePrice
        gameState.currencyA -= Zone.newZonePrice;
        sceneCollection.reloadData();
        playArea.selectZone(index: gameState.zones.count-1);
        transitionToClose()
        
    }
    
    
    // MARK: NSCoding
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// Saves the GameState
    @objc func saveGame() {
        gameState.saveGameState()
    }
}

