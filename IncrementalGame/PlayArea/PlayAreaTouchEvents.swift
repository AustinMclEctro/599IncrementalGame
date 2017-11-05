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
        
        let edgePanRight = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleEdgePan))
        edgePanRight.edges = .right
        self.addGestureRecognizer(edgePanRight)
        let edgePanLeft = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleEdgePan))
        edgePanLeft.edges = .left
        self.addGestureRecognizer(edgePanLeft)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(drag));
        self.addGestureRecognizer(pan);
        pan.require(toFail: edgePanRight);
        pan.require(toFail: edgePanLeft);
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(oneTap))
        singleTap.cancelsTouchesInView = false;
        singleTap.require(toFail: pan)
        self.addGestureRecognizer(singleTap)
    }
    
    @objc func drag(sender: UIPanGestureRecognizer) {
        let location = CGPoint(x: sender.location(in: self).x, y: frame.height-sender.location(in: self).y)
        switch sender.state {
        case .began:
            
            let nodes = scene?.nodes(at: location) ?? []
            for n in nodes {
                if let node = n as? GameObject {
                    selectedNode = node;
                    selectedNode?.physicsBody?.affectedByGravity = false;
                    //selectedNode?.physicsBody?.isDynamic = false;
                    break;
                }
            }
            
            break;
        case .changed:
            if (selectedNode != nil) {
                selectedNode?.position = location;
            }
            break;
        default: // ended, canceled etc.
            let vel = sender.velocity(in: self);
            //selectedNode?.physicsBody?.isDynamic = true;
            selectedNode?.physicsBody?.affectedByGravity = true;
            // TODO - overcome gravity
            selectedNode?.physicsBody?.applyForce(CGVector(dx: vel.x, dy: -vel.y))
            selectedNode = nil;
            
            break;
        }
    }
    
    @objc func oneTap(recognizer: UITapGestureRecognizer) {
        var location = recognizer.location(in: self)
        location = zone.convertPoint(fromView: location)
        let nodes = self.zone.nodes(at: location)
        var shapeTapped: Shape?;
        for n in nodes {
            if let nodeTemp = n as? Shape {
                shapeTapped = nodeTemp;
                break;
            }
        }
        if shapeTapped != nil {
            gained(amount: shapeTapped!.objectType.getPoints())
            for child in zone.children {
                if let otherShape = child as? Shape {
                    let offset = CGVector(dx: otherShape.position.x - shapeTapped!.position.x, dy: otherShape.position.y - shapeTapped!.position.y)
                    if offset.magnitudeSquared() < shapeTapped!.size.width * shapeTapped!.size.width * 1.75 {
                        otherShape.physicsBody?.applyImpulse(offset)
                    }
                }
            }
        }
    }
    
    @objc func handleEdgePan(recognizer: UIScreenEdgePanGestureRecognizer) {
        // Allows draging shapes to override pan
        let location = CGPoint(x: recognizer.location(in: self).x, y: frame.height-recognizer.location(in: self).y)
        var index = zoneNumber
        if (recognizer.state == .began) {
            tempImageZone?.removeFromSuperview();
            if gameState.zones.count == 0 {
                return;
            }
            let nodes = scene?.nodes(at: location) ?? []
            for n in nodes {
                if let node = n as? GameObject {
                    selectedNode = node;
                    break;
                }
            }
            
            var image: CGImage?;
            if recognizer.edges == .right {
                tempImageZone = UIImageView(frame: CGRect(x: frame.width, y: 0, width: frame.width, height: frame.height))
                index = index+1 >= gameState.zones.count ? 0 : index+1;
                image = self.texture(from: gameState.zones[index])?.cgImage();
            }
            else if recognizer.edges == .left {
                index = index-1 < 0 ? gameState.zones.count-1 : index-1;
                
                tempImageZone = UIImageView(frame: CGRect(x: -frame.width, y: 0, width: frame.width, height: frame.height))
                
                image = self.texture(from: gameState.zones[index])?.cgImage();
            }
            else {
                return;
            }
            
            tempImageZone?.image = UIImage(cgImage: (image)!)
            self.addSubview(tempImageZone!);
            
            
        }
        if (selectedNode == nil) {
            
            if recognizer.state == .changed {
                if recognizer.edges == .right {
                    tempImageZone?.frame = CGRect(x: location.x, y: 0, width: frame.width, height: frame.height)
                    // TODO: This wont work since level is a SKScene - "Setting the position of a SKScene has no effect."
                    zone.position = CGPoint(x: location.x-frame.width/2, y: frame.midY)
                }
                else if recognizer.edges == .left {
                    tempImageZone?.frame = CGRect(x: location.x-frame.width, y: 0, width: frame.width, height: frame.height)
                    // TODO: This wont work since level is a SKScene - "Setting the position of a SKScene has no effect."
                    //level.position = CGPoint(x: location.x+frame.width/2, y: frame.midY)
                }
            }
            else if recognizer.state == .ended {
                // Dragged far enough
                if (recognizer.edges == .right && location.x <= frame.midX) || (recognizer.edges == .left && location.x >= frame.midX) {
                    UIView.animate(withDuration: 0.5, animations: {
                        self.tempImageZone?.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
                    }, completion: { (success) in
                        
                            if recognizer.edges == .right {
                                index += 1
                                if index == self.gameState.zones.count {index = 0}
                            } else if recognizer.edges == .left {
                                index -= 1
                                if index < 0 {index = self.gameState.zones.count - 1}
                            }
                            // Need to make sure selectedNode is nil, in case drag fails for some reason
                            self.selectedNode = nil;
                            // Show zone at index
                            self.selectZone(index: index);
                            // remove the image after the real one is down
                            self.tempImageZone?.removeFromSuperview();
                    
                        })
                }
                else { // Didnt drag far enough
                    // Where it should go if it fails
                    let dir = recognizer.edges == .left ? -frame.width : frame.width
                    UIView.animate(withDuration: 0.5, animations: {
                        // Put back
                        self.tempImageZone?.frame = CGRect(x: dir, y: 0, width: self.frame.width, height: self.frame.height)
                    }, completion: { (success) in
                        // Need to make sure selectedNode is nil, in case drag fails for some reason
                        self.selectedNode = nil;
                        // remove the image
                        self.tempImageZone?.removeFromSuperview();
                        
                    })
                }
            }
            else if recognizer.state != .began {
                self.selectedNode = nil;
                self.tempImageZone?.removeFromSuperview();
            }
        }
        else { // do drag instead of pan
            self.selectedNode = nil;
            self.tempImageZone?.removeFromSuperview();
            drag(sender: recognizer);
        }
    }
    
    /*@objc func pinchSelf(sender: UIPinchGestureRecognizer) {
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
    }*/
    
    
}
