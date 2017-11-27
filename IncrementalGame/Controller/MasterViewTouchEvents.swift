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
        settingsButton.addTarget(self, action: #selector(onSettingsButtonPressed), for: .touchUpInside)
        scenePreviewButton.addTarget(self, action: #selector(tapDownPreview), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(onResetButtonPress), for: .touchUpInside)
        var pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinch));
        self.addGestureRecognizer(pinchGesture)
        tapToClose.addTarget(self, action: #selector(tapToClosePress), for: .touchUpInside)
        //tapToClose.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapToClosePress)))
    }
    
    
    @objc func tapToClosePress(sender: UIButton) {
        if shopOpen {
            closeShop();
        }
        else if sceneOpen {
            transitionToClose();
        }
    }
    
    
    @objc func onSettingsButtonPressed(sender: UIButton) {
        playArea.isPaused = true
        playArea.pIGManager.pauseInactiveIncomeGenerator()
        self.addSubview(settingsMenu)
        UIView.animate(withDuration: 0.5, animations: {
            self.settingsMenu.alpha = 1.0
        })
    }

    
    @objc func pinch(sender: UIPinchGestureRecognizer) {
        switch sender.state {
            case .began:
                zoomingTo = sceneCollection.zoomingTo(index: playArea.zoneNumber);
                if (sceneOpen) {
                    playArea.removeFromSuperview()
                    self.addSubview(playArea);
                }
                sceneCollection.reloadData();
                break;
            case .changed:
                if (!sceneOpen) {
                    var scale = sender.scale;
                    if (scale > 1) {
                        scale = 1;
                    }
                    var perc = 1.2-scale;
                    print(perc)
                    if (perc > 1) {
                        perc = 1;
                    }
                    var width = playAreaFrame.width-(playAreaFrame.width-zoomingTo!.width)*perc;
                    var height = playAreaFrame.height-(playAreaFrame.height-zoomingTo!.height)*perc;
                    playArea.frame = CGRect(x: playAreaFrame.minX+perc*zoomingTo!.minX, y: playAreaFrame.minY+perc*zoomingTo!.minY, width: width, height: height)
                }
                else {
                    var scale = sender.scale;
                    if (scale < 1) {
                        scale = 1;
                    }
                    var perc = scale-2.2;
                    
                    if (perc < 0) {
                        perc = 0;
                    }
                    else if (perc > 1) {
                        perc = 1;
                    }
                    print(perc)
                    
                    var width = playAreaFrame.width-(1-perc)*(playAreaFrame.width-zoomingTo!.width)
                    var height = playAreaFrame.height-(1-perc)*(playAreaFrame.height-zoomingTo!.height)
                    playArea.frame = CGRect(x: zoomingTo!.minX*(1-perc), y: playAreaFrame.minY+zoomingTo!.minY*(1-perc), width: width, height: height)
                }
                break;
            case .ended:
                if (!sceneOpen){
                    if (sender.scale < 0.5) { // animate until completion
                        transitionToOpen()
                    }
                    else { // animate backwards
                        transitionToClose()
                        
                    }
                }
                else {
                    if (sender.scale < 1.5) { // animate backwards
                        transitionToOpen()
                    }
                    else { // animate to completion
                        transitionToClose()
                        
                    }
                }
                break;
            default:
                break;
        }
    }
    
    
    func transitionToOpen() {
        var fr = self.sceneCollection.zoomingTo(index: self.playArea.zoneNumber);
        UIView.animate(withDuration: 0.5, animations: {
            self.playArea.frame = CGRect(x: self.playAreaFrame.minX+fr.minX, y: self.playAreaFrame.minY+fr.minY, width: fr.width, height: fr.height - 20) // - 20 for passive rate label
        }) { (success) in
            if (success) {
                self.playArea.removeFromSuperview();
                self.sceneCollection.setCurrent(playArea: self.playArea);
                self.sceneOpen = true;
            }
            else {
                self.transitionToClose()
            }
        }
        self.addSubview(tapToClose);
        scenePreviewButton.removeFromSuperview();
        
    }
    
    
    func transitionToClose() {
        /*let positionAnimation = CABasicAnimation(keyPath: "scale")
        positionAnimation.fromValue = [playArea.frame.size.x, playArea.size.y];
        positionAnimation.toValue = [playAreaFrame.size.x, playArea.size.y];
        
        let scaleAnimation = CABasicAnimation(keyPath: "position")
        scaleAnimation.fromValue = [playArea.frame.minX, playArea.frame.minY];
        scaleAnimation.toValue = [playAreaFrame.minX, playAreaFrame.minY];*/
        UIView.animate(withDuration: 0.5, animations: {
            self.playArea.frame = self.playAreaFrame
        })
        //var animation = CABasicAnimation();
        //playArea.frame = playAreaFrame;
        sceneOpen = false;
        playArea.removeFromSuperview()
        
        self.addSubview(playArea);
        self.addSubview(scenePreviewButton)
        tapToClose.removeFromSuperview()
    }
    
   
    @objc func tapDownPreview(sender: UIButton) {
        if shopOpen {
            closeShop();
        }
        feedbackGenerator.impactOccurred()
        feedbackGenerator.prepare()
        if (!sceneOpen) {
            transitionToOpen()
        }
        else {
            // Does all the work, some redundancy but negligible on performance
            selectZone(index: playArea.zoneNumber);
        }
    }
    

    /// Callback method that is called when the user presses the Reset button.
    /// Restores the game back to the default game state.
    ///
    /// - Parameter sender: The UIButton that was pressed.
    @objc func onResetButtonPress(sender: UIButton) {
        print("I will reset the game state.")
        gameState.restoreToDefault()
    }
}


