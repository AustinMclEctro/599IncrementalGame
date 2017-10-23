//
//  PlayArea.swift
//  IncrementalGame
//
//  Created by Ben Grande on 2017-10-05.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit
class PlayArea: SKView {
    
    var level: Zone
    var zoneNumber = 0
    let gameState: GameState
    var tableSceneView: SceneTableView?
    var tableOpen = false
    
    
    init(frame: CGRect, gameState: GameState) {
        self.gameState = gameState
        level = Zone(size: frame.size, zone0: true)
        gameState.zones.append(level)
        super.init(frame: frame)
        setupTouchEvents()
        presentScene(level)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(drag))
        self.addGestureRecognizer(pan)
        
        let leftEdgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(panLeftEdge))
        leftEdgePan.edges = .left
        self.addGestureRecognizer(leftEdgePan)
        leftEdgePan.require(toFail: pan)
        
        let rightEdgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(panRightEdge))
        rightEdgePan.edges = .right
        self.addGestureRecognizer(rightEdgePan)
        rightEdgePan.require(toFail: pan)
    }
    @objc func panLeftEdge(sender: UIScreenEdgePanGestureRecognizer) {
        let oneLess = String(zoneNumber-1);
        print("left from "+String(zoneNumber)+" to "+oneLess)
        if sender.state == .ended {
            selectZone(index: zoneNumber-1)
        }
    }
    @objc func panRightEdge(sender: UIScreenEdgePanGestureRecognizer) {
        let oneMore = String(zoneNumber+1)
        print("right from "+String(zoneNumber)+" to "+oneMore)
        if sender.state == .ended {
            selectZone(index: zoneNumber+1)
        }
    }
    var selectedNode: GameObject?;
    @objc func drag(sender: UIPanGestureRecognizer) {
        let location = CGPoint(x: sender.location(in: self).x, y: frame.height-sender.location(in: self).y)
        switch sender.state {
            case .began:
                let nodes = scene?.nodes(at: location) ?? []
                if (nodes.count > 0) {
                    if let node = nodes[0] as? GameObject {
                        selectedNode = node;
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
                selectedNode?.physicsBody?.applyForce(CGVector(dx: vel.x, dy: -vel.y))
                selectedNode = nil;
                break;
        }
    }
    
    func selectZone(index: Int) {
        let count = gameState.zones.count
        var ind = index%count
        if (index < 0) {
            ind = gameState.zones.count+index;
        }
        // Displays the selected zone
        zoneNumber = ind
        
        // don't know why this is needed but zones[0] won't display right without it!!
        if zoneNumber == 0 {gameState.zones[0] = Zone(size: frame.size, zone0: true)}
        
        level = gameState.zones[ind]
        presentScene(level)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addShape(of: ObjectType, at: CGPoint) -> Shape? {
        if level.canAdd(type: of) {
            let shape = Shape(type: of, at: at, withSize: level.size);
            level.addChild(shape);
            return shape;
        }
        return nil;
    }
    
    func addFixture(of: ObjectType, at: CGPoint) {
        if level.canAdd(type: of) {
            let fix = Fixture(type: of, at: at, withSize: level.size);
            level.addChild(fix);
            level.removeAllowedObject(type: of)
        }
    }
    
    func gained(amount: Int) {
        // Change the name/delete as you like :) just left here to show how to add currency A
        if let controller = superview as? MasterView {
            controller.updateCurrencyA(by: amount);
        }
    }
    
}

