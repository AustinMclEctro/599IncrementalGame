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
    
    var isSavingOn = false
    
    var zoomingTo: CGRect?;
    var infoPanel: InfoPanel;
    var playAreaFrame: CGRect;
    var playArea: PlayArea;
    var sceneCollection: SceneCollectionView;
    let scenePreviewButton: UIButton;
    var sceneOpen = false;
    var shopOpen = false;
    var tapToClose: UIButton;
    var shop: ShopCollectionView;
    var progressStore: ProgressStore;
    let shopWidth: CGFloat = 250.0;
    let gameState: GameState;
    let resetButton: UIButton;
    var feedbackGenerator: UIImpactFeedbackGenerator;
    var settingsMenu: SettingsMenu;
    let settingsButton: UIButton;
    let startupPopup: StartupPopup
    let settingsHelper = SettingsBundleHelper()
    
    var currencyA: Int {
        set(val) {
            // Do we want to allow this?
        }
        get {
            return gameState.currencyA;
        }
    }
    
    
    override init(frame: CGRect) {
        // Load gamestate
        if let savedGameState = GameState.loadGameState(), isSavingOn {
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
        scenePreviewButton = UIButton(frame: CGRect(x: 0, y: infoHeight, width: 50, height: 50))
        scenePreviewButton.setImage(UIImage(named: "PreviewButton"), for: .normal)
        
        shop = ShopCollectionView(frame: CGRect(x: 0, y:playAreaFrame.maxY, width: frame.width, height: frame.height-playAreaFrame.maxY))
        tapToClose = UIButton(frame: shop.frame);
        tapToClose.setTitle("Tap To Close", for: .normal)
        tapToClose.setTitleColor(.white, for: .normal)
        tapToClose.backgroundColor = .black
        
        progressStore = ProgressStore(frame: CGRect(x: 0, y: frame.height-(frame.width/2)-shop.frame.height, width: frame.width, height: frame.width))
        progressStore.curA = gameState.currencyA;
        //settings button configuration
        settingsButton = UIButton(frame: CGRect(x: frame.width-60, y: 90, width: 50, height: 50))
        settingsButton.setImage(UIImage(named:"Settings"), for: .normal)
        
        settingsMenu = SettingsMenu(frame: CGRect(x: 0, y: 0 , width: frame.width, height: frame.height))
        //below will set background color to white, but washes out the buttons
        settingsMenu.backgroundColor = UIColor.black
        
        // Configure the reset button
        resetButton =  UIButton(frame: CGRect(x: 5, y: 25, width: frame.width/3, height: 20))
        resetButton.setTitle("Reset", for: .normal)
        resetButton.setTitleColor(UIColor.white, for: .normal)
        
        // Create and configure the startup popup
        startupPopup = StartupPopup(frame: CGRect(x: ((frame.width/2) - StartupPopup.Dimensions.width/2), y: ((frame.height/2) - StartupPopup.Dimensions.height/2), width: 300, height: 400))
        startupPopup.isHidden = true
        
        feedbackGenerator = UIImpactFeedbackGenerator();
        feedbackGenerator.prepare();
        
        super.init(frame: frame)
        self.backgroundColor = UIColor.black;
        self.addSubview(infoPanel);
        self.addSubview(sceneCollection);
        infoPanel.upgradeCurrencyA(to: self.currencyA)
        self.addSubview(playArea);
        //self.addSubview(shopButton);
        self.addSubview(scenePreviewButton);
        self.addSubview(resetButton);
        self.addSubview(settingsButton)
        self.addSubview(shop);
        
        // Subscribe to applicationWillResignActive notification
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(saveGame), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        notificationCenter.addObserver(self, selector: #selector(onReceiveCurrencyUpdate(_:)), name: NSNotification.Name(rawValue: Notification.Name.currencyChanged), object: nil)
        notificationCenter.addObserver(self, selector: #selector(onReceivePassiveIncomeRate(_:)), name: NSNotification.Name(rawValue: Notification.Name.inactiveIncomeRate), object: nil)
        notificationCenter.addObserver(self, selector: #selector(onReceivedBackgroundIncome(_:)), name: NSNotification.Name(rawValue: Notification.Name.backgroundIncomeEarned), object: nil)
        notificationCenter.addObserver(self, selector: #selector(onResume), name: NSNotification.Name(rawValue: Notification.Name.resume), object: nil)
        
        setupTouchEvents()
    }

    
    /// Callback method that is called when the user presses resume in the settings menu
    @objc func onResume() {
        playArea.isPaused = false
        playArea.pIGManager.startInactiveIncomeGenerator()
        UIView.animate(withDuration: 0.5, animations: {
            self.settingsMenu.alpha = 0
        }) { _ in
            self.settingsMenu.removeFromSuperview()
        }
    }
    
    /// Callback method that is called when the PassiveIncomeManager sends the background income earned after startup.
    ///
    /// - Parameter notification: Contains an int with the amount of background income earned. The key is "amount".
    @objc func onReceivedBackgroundIncome(_ notification: Notification) {
        if let amount = notification.userInfo?["amount"] as? Int {
            self.addSubview(startupPopup)
            
            updateCurrencyA(by: amount)
            startupPopup.displayPopup(incomeEarned: amount)
            startupPopup.bringSubview(toFront: startupPopup)
            startupPopup.isHidden = false
        }
    }
    
    
    /// Callback method that is called when MasterView receives a notification
    /// that the points have changed
    ///
    /// - Parameter notification: Contains an int indicating the amount
    /// that the currency changed
    @objc func onReceiveCurrencyUpdate(_ notification: NSNotification) {
        if let amount = notification.userInfo?["amount"] as? Int {
            updateCurrencyA(by: amount)
        }
    }
    
    
    /// Callback method that is called when Masterview receives notifiaction with
    /// the inactive income rate. Updates the info panel to display the new rate.
    ///
    /// - Parameter notification: Contains the rate as an int.
    @objc func onReceivePassiveIncomeRate(_ notification: NSNotification) {
        if let rate = notification.userInfo?["rate"] as? Int {
            infoPanel.updateInactiveIncomeRate(rate: rate)
        }
    }
    
    
    /// Opens the upgrade tree for a specified GameObject.
    ///
    /// - Parameter object: The GameObject that is being upgraded.
    //TODO: Can delete if we use new ugrade
    /*func openUpgrade(object: GameObject) {
     
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
     
     }*/
    func upgradeShape(obj: GameObject, path: Int) {
        if let shape = obj as? Shape {
            switch path {
            case 1:
                shape.upgradeA();
                break;
            case 2:
                shape.upgradeB();
                break;
            case 3:
                shape.upgradeC();
                break;
            default:
                break;
            }
        }
        else if let fixture = obj as? Fixture {
            
        }
    }
    
    /// Updates the value for currencyA. Used for shop purchases.
    ///
    /// - Parameter by: The amount to add to currencyA
    func updateCurrencyA(by: Int) {
        gameState.currencyA += by;
        infoPanel.upgradeCurrencyA(to: gameState.currencyA);
        shop.curA = gameState.currencyA;
        if (shopOpen) {
            progressStore.curA = gameState.currencyA;
        }
    }
    func closeShop() {
        if progressStore.isShape {
            openShapeShop()
        }
        else {
            openFixtureShop()
        }
    }
    func openShapeShop() {
        progressStore.isShape = true;
        if (shopOpen) {
            tapToClose.removeFromSuperview()
            progressStore.animateOut {
                self.progressStore.removeFromSuperview();
            }
        }
        else {
            progressStore.updateStores();
            self.addSubview(progressStore);
            
            progressStore.animateIn()
            self.addSubview(tapToClose);
            
        }
        shopOpen = !shopOpen;
        
        
    }
    func openFixtureShop() {
        progressStore.isShape = false;
        if (shopOpen) {
            tapToClose.removeFromSuperview();
            progressStore.animateOut {
                self.progressStore.removeFromSuperview();
            }
        }
        else {
            progressStore.updateStores();
            self.addSubview(progressStore);
            self.addSubview(shop);
            progressStore.animateIn()
            self.addSubview(tapToClose);
            
        }
        shopOpen = !shopOpen;
    }
    
    /// Purchases an object for gameplay and adds the object to the playarea.
    ///
    /// - Parameters:
    ///   - of: The GameObject that is being purchased.
    func purchaseObject(of: ObjectType, sender: UIPanGestureRecognizer?) {
        if (gameState.currencyA < of.getPrice() || !playArea.getZone().canAdd(type: of)) {
            return;
        }
        
        updateCurrencyA(by: -of.getPrice())
        
        if sender != nil {
            let loc = sender!.location(in: playArea); // UIView location (need to flip y)
            let location = CGPoint(x: loc.x, y: playArea.frame.height-loc.y); // Flipped y
            let vel = sender!.velocity(in: playArea); // UIView velocity (need to flip y)
            let velocity =  CGVector(dx: vel.x, dy: -vel.y);// Flopped y
            if !of.isFixture() {
                let shape = playArea.addShape(of: of, at: location);
                shape?.physicsBody?.velocity = velocity;
            }
            else {
                playArea.addFixture(of: of, at: location);
            }
        }
        else {
            // Placed at ambiguous point
            let location =  CGPoint(x: 0, y: 0);
            if !of.isFixture() {
                playArea.addShape(of: of, at: location);
            }
            else {
                playArea.addFixture(of: of, at: location);
            }
        }
        shop.currentShapes = playArea.getGameObjects();
        closeShop();
        
    }
    
    
    func selectZone(index: Int) {
        playArea.removeFromSuperview();
        self.addSubview(playArea);
        
        playArea.selectZone(index: index);
        let fr = sceneCollection.zoomingTo(index: playArea.zoneNumber)
        playArea.frame = CGRect(x: playAreaFrame.minX+fr.minX, y: playAreaFrame.minY+fr.minY, width: fr.width, height: fr.height)
        transitionToClose()
        self.addSubview(scenePreviewButton)
        shop.currentShapes = playArea.getGameObjects();
    }
    
    
    func createZone() {
        let zone = Zone(size: playAreaFrame.size, children: [], pIG: nil, allowedObjects: nil)
        gameState.zones.append(zone)
        // TODO - change this with gameState newZonePrice
        // gameState.currencyA -= Zone.newZonePrice;
        sceneCollection.reloadData();
        playArea.selectZone(index: gameState.zones.count-1);
        transitionToClose()
        shop.currentShapes = playArea.getGameObjects();
        
    }
    
    
    // MARK: NSCoding
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// Saves the GameState
    @objc func saveGame() {
        // Call pre-save gamestate functions
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notification.Name.willSaveGameState), object: nil, userInfo: nil)
        
        if isSavingOn {
            gameState.saveGameState()
        }
    }
}

