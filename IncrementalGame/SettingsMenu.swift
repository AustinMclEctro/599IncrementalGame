//
//  SettingsMenu.swift
//  IncrementalGame
//
//  Created by Luke Kissick on 2017-11-04.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import Foundation
import SpriteKit

class SettingsMenu: SKView {
    var button1: SKShapeNode
    var button2: SKShapeNode
    
    override init(frame: CGRect) {
        button1 = SKShapeNode(rect: CGRect(x: 0, y: -frame.height, width: frame.width, height: frame.height) , cornerRadius: 10)
        button1.fillColor = UIColor.darkGray.withAlphaComponent(0.3)
        button2 = SKShapeNode(rect: CGRect(x: 0, y: -frame.height, width: frame.width, height: frame.height) , cornerRadius: 10)
        button2.fillColor = UIColor.green.withAlphaComponent(0.3)
        super.init(frame: frame)
        presentScene(SKScene(size: frame.size))
        self.scene?.addChild(button1)
        self.scene?.addChild(button2)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
