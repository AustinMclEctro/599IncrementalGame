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
    let objectMargins: CGFloat = 25.0

    let collidrLogo: UIImageView;
    let newGameButton: UIButton;
    let resumeButton: UIButton;
    let soundButton: UIButton;
    let musicButton: UIButton;
    let vibrationButton: UIButton;
    let guideButton: UIButton;
    let removeAdsButton: UIButton;
    
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
    
    private var _musicOn: Bool = false;
    var musicOn: Bool {
        set(val) {
            _musicOn = val;
            musicButton.backgroundColor = val ? .green : .red;
        }
        get {
            return _musicOn;
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
    
    
    override init(frame: CGRect) {
        
        let outerMargin = (frame.height - ((objectMargins + height) * 6))/2.5
        let logoWidth = (183/77)*height
        
        collidrLogo = UIImageView(frame: CGRect(x: (frame.width/2)-(logoWidth/2), y: outerMargin + (height + objectMargins) * 0, width: logoWidth, height: height))
        collidrLogo.image = UIImage(named: "colidr")
        newGameButton = UIButton(frame: CGRect(x: frame.width/2 - width/2, y:  outerMargin + (height + objectMargins) * 1, width: width, height: height))
        resumeButton =  UIButton(frame: CGRect(x: frame.width/2 - width/2, y: outerMargin + (height + objectMargins) * 2, width: width, height: height))
        soundButton =  UIButton(frame: CGRect(x: frame.width/2 - width/2, y: outerMargin + (height + objectMargins) * 3, width: width, height: height))
        musicButton =  UIButton(frame: CGRect(x: frame.width/2 - width/2, y: outerMargin + (height + objectMargins) * 4, width: width, height: height))
        vibrationButton = UIButton(frame: CGRect(x: frame.width/2 - width/2, y: outerMargin + (height + objectMargins) * 5, width: width, height: height ))
        guideButton =  UIButton(frame: CGRect(x: frame.width/2 - width/2, y: outerMargin + (height + objectMargins) * 6, width: width, height: height))
        removeAdsButton = UIButton(frame: CGRect(x: frame.width/2 - width/2, y: outerMargin + (height + objectMargins) * 7, width: width, height: height ))
        
        super.init(frame: frame)
        
        newGameButton.layer.cornerRadius = 15
        newGameButton.setTitle("New Game", for: .normal)
        newGameButton.backgroundColor = appColor
        newGameButton.addTarget(self, action: #selector(onNewGameButtonPressed), for: .touchDown)
        
        resumeButton.layer.cornerRadius = 15
        resumeButton.setTitle("Resume", for: .normal)
        resumeButton.backgroundColor = appColor
        resumeButton.addTarget(self, action: #selector(onResumeButtonPressed), for: .touchDown)
        
        soundButton.layer.cornerRadius = 15
        soundButton.setTitle("Sound", for: .normal)
        soundButton.backgroundColor = UIColor.red
        soundButton.addTarget(self, action: #selector(onSoundButtonPressed), for: .touchDown)
        
        musicButton.layer.cornerRadius = 15
        musicButton.setTitle("Music", for: .normal)
        musicButton.backgroundColor = UIColor.red
        musicButton.addTarget(self, action: #selector(onMusicButtonPressed), for: .touchDown)
        
        vibrationButton.layer.cornerRadius =  15
        vibrationButton.setTitle("Vibration", for: .normal)
        vibrationButton.backgroundColor = UIColor.red
        vibrationButton.addTarget(self, action: #selector(onVibrationButtonPressed), for: .touchDown)
        
        guideButton.layer.cornerRadius =  15
        guideButton.setTitle("Guide", for: .normal)
        guideButton.backgroundColor = appColor
        guideButton.addTarget(self, action: #selector(onGuideButtonPressed), for: .touchDown)

        removeAdsButton.layer.cornerRadius =  15
        removeAdsButton.setTitle("Remove Banner Ads", for: .normal)
        removeAdsButton.backgroundColor = UIColor.red
        removeAdsButton.addTarget(self, action: #selector(onResumeButtonPressed), for: .touchDown)
        
        self.addSubview(collidrLogo)
        self.addSubview(newGameButton)
        self.addSubview(resumeButton)
        self.addSubview(soundButton)
        self.addSubview(musicButton)
        self.addSubview(vibrationButton)
        self.addSubview(guideButton)
        self.addSubview(removeAdsButton)
        
        vibrationOn = UserDefaults.standard.bool(forKey: SettingsBundleKeys.Vibration);
        soundOn = UserDefaults.standard.bool(forKey: SettingsBundleKeys.Sound);
    }

    @objc func onNewGameButtonPressed (sender: UIButton){
        // TODO
    }
    
    @objc func onResumeButtonPressed (sender: UIButton){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notification.Name.resume), object: nil, userInfo: nil)
    }
    
    @objc func onSoundButtonPressed (sender: UIButton){
        soundOn = !soundOn;
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notification.Name.soundPreferenceChanged), object: nil, userInfo: nil)
    }
    
    @objc func onMusicButtonPressed (sender: UIButton){
        musicOn = !musicOn;
        let data: [String: Bool] = ["music": musicOn]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notification.Name.musicPreferenceChanged), object: nil, userInfo: data)
    }
    
    @objc func onVibrationButtonPressed (sender: UIButton){
        vibrationOn = !vibrationOn
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notification.Name.vibrationPreferenceChanged), object: nil, userInfo: nil)
    }
    
    @objc func onGuideButtonPressed (sender: UIButton){
        // TODO
    }
    
    @objc func onRemoveAdsButtonPressed (sender: UIButton){
        // TODO
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
