//
//  SceneShapePreview.swift
//  IncrementalGame
//
//  Created by Ben Grande on 2017-10-16.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import Foundation
import SpriteKit

class SceneShapePreview: SKView {
    init(frame: CGRect, children: [SKNode]) {
        super.init(frame: frame);
        self.presentScene(SKScene(size: frame.size))
        self.backgroundColor = .clear;
        self.scene?.backgroundColor = .clear;
        var counter = 1;
        for child in children {
            if let object = child as? Shape {
                let pr = SKSpriteNode(imageNamed: String(describing: object.objectType))
                scene?.addChild(pr)
                pr.position = CGPoint(x: counter*20, y: 10)
                let shapeWidth = 10.0;
                pr.scale(to: CGSize(width: shapeWidth, height: shapeWidth));
                counter += 1;
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

