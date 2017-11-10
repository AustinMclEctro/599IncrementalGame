//
//  SettingsMenu.swift
//  IncrementalGame
//
//  Created by Luke Kissick on 2017-11-04.
//  Copyright © 2017 Luke Kissick. All rights reserved.
//

import Foundation
import UIKit

class SettingsMenu: UIView {
   
    let width: CGFloat = 200.0
    let height: CGFloat = 50.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //start copy paste below for more buttons
        let button1 =  UIButton(frame: CGRect(x: frame.width/2 - width/2, y: 0 + height, width: width, height: height) )
        button1.layer.cornerRadius = 15
        button1.setTitle("Sound", for: .normal)
        button1.backgroundColor = UIColor.red
        button1.addTarget(self, action: #selector(settings1), for: .touchUpInside)
        self.addSubview(button1)
        // end copy paste

        let button2 = UIButton(frame: CGRect(x: frame.width/2 - width/2, y:0 + height*3, width: width, height: height ))
        button2.layer.cornerRadius =  15
        button2.setTitle("Vibration", for: .normal)
        button2.backgroundColor = UIColor.red
        self.addSubview(button2)
        
        let button3 = UIButton(frame: CGRect(x: frame.width/2 - width/2, y:0 + height*5, width: width, height: height ))
        button3.layer.cornerRadius =  15
        button3.setTitle("Remove Banner Ads", for: .normal)
        button3.backgroundColor = UIColor.red
        self.addSubview(button3)
        
    }
    
    @objc func settings1 (sender: UIButton){
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
