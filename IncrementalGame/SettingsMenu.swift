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
    var button1 = SKShapeNode()
    var button2 = SKShapeNode()
    let width: CGFloat = 200.0
    let height: CGFloat = 50.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        button1 = SKShapeNode(rect: CGRect(origin: CGPoint(x: frame.width/2 - width/2, y:frame.height - height*2) , size: CGSize(width: width, height: height) ) , cornerRadius: 10)
        button2 = SKShapeNode(rect: CGRect(origin: CGPoint(x: frame.width/2 - width/2, y:frame.height - height*4), size: CGSize(width: width, height: height )) , cornerRadius: 10)
        
        button1.fillColor = UIColor.blue.withAlphaComponent(0.3)
        button2.fillColor = UIColor.green.withAlphaComponent(0.3)
        presentScene(SKScene(size: frame.size))
        self.scene?.addChild(button1)
        self.scene?.addChild(button2)
        
        let text1 = SKLabelNode(text: "Menu Item 1")
        text1.horizontalAlignmentMode = .center
       
        let text2 = SKLabelNode(text: "Menu Item 2")
        text2.horizontalAlignmentMode = .center
        
        button1.addChild(text1)
        button2.addChild(text2)
        
        text1.position = CGPoint(x: frame.width/2, y:button1.frame.midY)
        text2.position = CGPoint(x: frame.width/2, y:button2.frame.midY)
        text1.verticalAlignmentMode = .center
        text2.verticalAlignmentMode = .center
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
