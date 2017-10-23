//
//  PlayAreaTouchEvents.swift
//  IncrementalGame
//
//  Created by Andrew Groeneveldt on 2017-10-22.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import Foundation
import UIKit
extension PlayArea {
    
    func setupTouchEvents() {
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinchSelf))
        self.addGestureRecognizer(pinch)
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleTaps))
        doubleTap.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTap)
        let edgePanRight = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleEdgePan))
        edgePanRight.edges = .right
        self.addGestureRecognizer(edgePanRight)
        let edgePanLeft = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleEdgePan))
        edgePanLeft.edges = .left
        self.addGestureRecognizer(edgePanLeft)
    }
    
    @objc func handleEdgePan(recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .ended {
            if recognizer.edges == .right {
                zoneNumber += 1
                if zoneNumber == gameState.zones.count {zoneNumber = 0}
            } else if recognizer.edges == .left {
                zoneNumber -= 1
                if zoneNumber < 0 {zoneNumber = gameState.zones.count - 1}
            }
        
        // Show zone at index
            selectZone(index: zoneNumber);
        
        // just for testing
            print(zoneNumber)
        }
    }
    
    
    @objc func pinchSelf(sender: UIPinchGestureRecognizer) {
        let scale = sender.scale
        
        switch sender.state {
        case .began:
            if (tableSceneView == nil) {
                tableSceneView = SceneTableView(frame: CGRect(x: -100, y: -100, width: frame.width+200, height: frame.height+200))
            }
            tableSceneView!.setZones(zones: gameState.zones);
            self.addSubview(tableSceneView!);
        case .changed:
            if (tableOpen) {
                
                tableSceneView?.alpha = scale
                let dif = 200*(1-scale)
                tableSceneView!.frame = CGRect(x: dif, y: dif, width: frame.width+(dif*2), height: frame.height+(dif*2))
            }
            else {
                let maxScale = min(scale, 2)
                let opacity = min(scale-1, 1)
                tableSceneView?.alpha = opacity
                let dif = 100-50*maxScale
                tableSceneView!.frame = CGRect(x: dif, y: dif, width: frame.width+(dif*2), height: frame.height+(dif*2))
            }
        default:
            if scale >= 1.5 {
                tableSceneView!.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
                tableOpen = true
            }
            else {
                tableSceneView?.removeFromSuperview()
                tableOpen = false
            }
        }
    }
    
    
    @objc func handleTaps(recognizer: UITapGestureRecognizer) {
        if zoneNumber == 0 && gameState.currencyA >= Zone.newZonePrice {
            zoneNumber = gameState.zones.count
            gameState.zones.append(Zone(size: frame.size))
            gained(amount: -Zone.newZonePrice)
            level = gameState.zones[zoneNumber]
            presentScene(level)
            Zone.newZonePrice = gameState.zones.count * gameState.zones.count * 1000
            // just for testing
            addFixture(of: .Bumper, at: CGPoint(x:0, y:0))
            addShape(of: .Triangle, at: CGPoint(x:100, y:100))
            addShape(of: .Square, at: CGPoint(x:200, y:100))
        }
    }
    
}
