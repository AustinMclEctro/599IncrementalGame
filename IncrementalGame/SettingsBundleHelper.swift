//
//  SettingsBundleHelper.swift
//  IncrementalGame
//
//  Created by Michael Lee on 2017-11-14.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import Foundation
struct SettingsBundleKeys {
    static let Sound = "sound_preference"
    static let Vibration = "vibration_preference"
    static let BuildVersionKey = "build_preference"
    static let AppVersionKey = "version_preference"
}
class SettingsBundleHelper {
    
    // MARK: Initializers
    
    init() {
        // Register for notifications
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(onSoundSettingChanged), name: NSNotification.Name(rawValue: Notification.Name.soundPreferenceChanged), object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(onMusicSettingChanged), name: NSNotification.Name(rawValue: Notification.Name.musicPreferenceChanged), object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(onVibrationChanged), name: NSNotification.Name(rawValue: Notification.Name.vibrationPreferenceChanged), object: nil)
    }
    
    
    // MARK: Functions
    
    
    /// Callback method that is called when the Sound button in the settings menu
    /// is pressed. Changes the Sound setting.
    @objc func onSoundSettingChanged() {
        if (UserDefaults.standard.bool(forKey: SettingsBundleKeys.Sound)) {
            UserDefaults.standard.set(false, forKey: SettingsBundleKeys.Sound)
        } else {
            UserDefaults.standard.set(true, forKey: SettingsBundleKeys.Sound)
        }
    }
    
    
    /// Callback method which plays or stops the music based on the music button in the settings menu
    @objc func onMusicSettingChanged(_ notification: Notification) {
        if let musicStatus = notification.userInfo?["music"] as? Bool {
            if(musicStatus){
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notification.Name.playBGM), object: nil)
            }
            else if(!musicStatus){
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notification.Name.stopBGM), object: nil)
            }
        }
    }
    
    
    /// Callback method that is called when the Vibration button in the settings menu
    /// is pressed. Changes the Vibration setting.
    @objc func onVibrationChanged() {
        if (UserDefaults.standard.bool(forKey: SettingsBundleKeys.Vibration)) {
            UserDefaults.standard.set(false, forKey: SettingsBundleKeys.Vibration)
        } else {
            UserDefaults.standard.set(true, forKey: SettingsBundleKeys.Vibration)
        }
    }
}
