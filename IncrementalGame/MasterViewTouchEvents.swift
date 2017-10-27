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
        scenePreviewButton.addTarget(self, action: #selector(tapDownPreview), for: .touchUpInside)
        var pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinch));
        self.addGestureRecognizer(pinchGesture)
    }
    
    @objc func pinch(sender: UIPinchGestureRecognizer) {
        switch sender.state {
            case .began:
                zoomingTo = sceneCollection.zoomingTo(index: playArea.zoneNumber);
                if (sceneOpen) {
                    playArea.removeFromSuperview()
                    self.addSubview(playArea);
                }
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
        //var animation = CABasicAnimation();
        playArea.removeFromSuperview();
        sceneCollection.setCurrent(playArea: playArea);
        sceneOpen = true;
    }
    func transitionToClose() {
        //var animation = CABasicAnimation();
        playArea.frame = playAreaFrame;
        sceneOpen = false;
        playArea.removeFromSuperview()
        self.addSubview(playArea);
        self.addSubview(shopButton)
        self.addSubview(scenePreviewButton)
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
    @objc func tapDownPreview(sender: UIButton) {
        if (!sceneOpen) {
            transitionToOpen()
        }
        else {
            transitionToClose()
        }
    }
}


