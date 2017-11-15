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
        let soundButton =  UIButton(frame: CGRect(x: frame.width/2 - width/2, y: 0 + height, width: width, height: height) )
        soundButton.layer.cornerRadius = 15
        soundButton.setTitle("Sound", for: .normal)
        soundButton.backgroundColor = UIColor.red
        soundButton.addTarget(self, action: #selector(onSoundButtonPressed), for: .touchDown)
        self.addSubview(soundButton)
        // end copy paste

        let vibrationButton = UIButton(frame: CGRect(x: frame.width/2 - width/2, y:0 + height*3, width: width, height: height ))
        vibrationButton.layer.cornerRadius =  15
        vibrationButton.setTitle("Vibration", for: .normal)
        vibrationButton.backgroundColor = UIColor.red
        vibrationButton.addTarget(self, action: #selector(onVibrationButtonPressed), for: .touchDown)
        self.addSubview(soundButton)
        self.addSubview(vibrationButton)
        
        let button3 = UIButton(frame: CGRect(x: frame.width/2 - width/2, y:0 + height*5, width: width, height: height ))
        button3.layer.cornerRadius =  15
        button3.setTitle("Remove Banner Ads", for: .normal)
        button3.backgroundColor = UIColor.red
        self.addSubview(button3)
        
    }
    
    @objc func onSoundButtonPressed (sender: UIButton){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notification.Name.soundPreferenceChanged), object: nil, userInfo: nil)
    }
    
    @objc func onVibrationButtonPressed (sender: UIButton){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notification.Name.vibrationPreferenceChanged), object: nil, userInfo: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
