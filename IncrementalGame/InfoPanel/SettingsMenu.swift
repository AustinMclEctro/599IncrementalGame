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
    private var _soundOn: Bool = false;
    var soundOn: Bool {
        set(val) {
            _soundOn = val;
            soundButton.backgroundColor = val ? .green : .red;
        }
        get {
            return _soundOn;
        }
    }
    private var _vibrationOn: Bool = false;
    var vibrationOn: Bool {
        set(val) {
            _vibrationOn = val;
            vibrationButton.backgroundColor = val ? .green : .red;
        }
        get {
            return _vibrationOn;
        }
    }
    let soundButton: UIButton;
    let vibrationButton: UIButton;
    override init(frame: CGRect) {
        soundButton =  UIButton(frame: CGRect(x: frame.width/2 - width/2, y: 0 + height, width: width, height: height) )
        vibrationButton = UIButton(frame: CGRect(x: frame.width/2 - width/2, y:0 + height*3, width: width, height: height ))
        super.init(frame: frame)
        
        //start copy paste below for more buttons
        
        soundButton.layer.cornerRadius = 15
        soundButton.setTitle("Sound", for: .normal)
        soundButton.backgroundColor = UIColor.red
        soundButton.addTarget(self, action: #selector(onSoundButtonPressed), for: .touchDown)
        self.addSubview(soundButton)
        // end copy paste
        
        
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
        
        vibrationOn = UserDefaults.standard.bool(forKey: SettingsBundleKeys.Vibration);
        soundOn = UserDefaults.standard.bool(forKey: SettingsBundleKeys.Sound);
        
    }
    
    @objc func onSoundButtonPressed (sender: UIButton){
        soundOn = !soundOn;
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notification.Name.soundPreferenceChanged), object: nil, userInfo: nil)
    }
    
    @objc func onVibrationButtonPressed (sender: UIButton){
        vibrationOn = !vibrationOn
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notification.Name.vibrationPreferenceChanged), object: nil, userInfo: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
