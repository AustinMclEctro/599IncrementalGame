//
//  PlayArea.swift
//  IncrementalGame
//
//  Created by Ben Grande on 2017-10-05.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import Foundation
import SpriteKit

class PlayArea: SKView, UIGestureRecognizerDelegate {
    
    var level: Level
    var zones: [Level] = []
    var zoneNumber = 0
    let doubleTap = UITapGestureRecognizer()
    let swipeRight = UISwipeGestureRecognizer()
    let swipeLeft = UISwipeGestureRecognizer()
    init(frame: CGRect, gameState: GameState) {
        level = Level(size: frame.size, actual: false)
        super.init(frame: frame)
        doubleTap.numberOfTapsRequired = 2
        doubleTap.addTarget(self, action: #selector(handleTaps))
        doubleTap.delegate = self
        self.addGestureRecognizer(doubleTap)
        swipeRight.numberOfTouchesRequired = 2
        swipeRight.direction = .right
        swipeRight.addTarget(self, action: #selector(handleSwipes(recognizer:)))
        swipeRight.delegate = self
        self.addGestureRecognizer(swipeRight)
        swipeLeft.numberOfTouchesRequired = 2
        swipeLeft.direction = .left
        swipeLeft.addTarget(self, action: #selector(handleSwipes(recognizer:)))
        swipeLeft.delegate = self
        self.addGestureRecognizer(swipeLeft)
        zones.append(level)
        presentScene(level)
        
        
        
    }
    
    
    
    @objc func handleSwipes(recognizer: UISwipeGestureRecognizer) {
        if recognizer.direction == .left {
            zoneNumber += 1
            if zoneNumber == zones.count {zoneNumber = 0}
        } else if recognizer.direction == .right {
            zoneNumber -= 1
            if zoneNumber < 0 {zoneNumber = zones.count - 1}
        }
        
        // don't know why this is needed but zones[0] won't display right without it!!
        if zoneNumber == 0 {zones[0] = Level(size: frame.size, actual: false)}
        
        // Show zone at index
        selectZone(index: zoneNumber);
        // just for testing
        print(zoneNumber)
    }
    func selectZone(index: Int) {
        // Displays the selected zone
        level = zones[index]
        presentScene(level)
    }
    @objc func handleTaps() {
        if zoneNumber == 0 {
            zoneNumber = zones.count
            zones.append(Level(size: frame.size))
            level = zones[zoneNumber]
            presentScene(level)
            // just for testing
            if level.canAdd(type: .Bumper) {
                addObject(of: .Bumper, at: CGPoint(x:0, y:0))
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setShapes(_ shapes: [[String: String]]) {
        // used to init
    }
    
    func addObject(of: ObjectType, at: CGPoint) {
        // GameObject inherits from SKSpriteNode
        // Initializer is ObjectType - Circle, Triangle etc
        let gameObject = GameObject(type: of);
        level.addChild(gameObject);
        gameObject.setUp(at: at, withSize: level.size)
    }
    
    func gained(amount: Int) {
        // Change the name/delete as you like :) just left here to show how to add currency A
        if let controller = superview as? ControllerView {
            controller.addCurA(by: amount);
        }
    }
    
    
    
}

