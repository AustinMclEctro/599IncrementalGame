//
//  SettingsBundleHelper.swift
//  IncrementalGame
//
//  Created by Michael Lee on 2017-11-14.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import Foundation

class SettingsBundleHelper {
    struct SettingsBundleKeys {
        static let Sound = "sound_preference"
        static let Vibration = "vibration_preference"
        static let BuildVersionKey = "build_preference"
        static let AppVersionKey = "version_preference"
    }
    
    init() {
        // Register for notifications
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(onSoundSettingChanged), name: NSNotification.Name(rawValue: Notification.Name.soundPreferenceChanged), object: nil)
        notificationCenter.addObserver(self, selector: #selector(onVibrationChanged), name: NSNotification.Name(rawValue: Notification.Name.vibrationPreferenceChanged), object: nil)
    }
    
    
    
    /// Callback method that is called when the Sound button in the settings menu
    /// is pressed. Changes the Sound setting.
    @objc func onSoundSettingChanged() {
        if (UserDefaults.standard.bool(forKey: SettingsBundleKeys.Sound)) {
            UserDefaults.standard.set(false, forKey: SettingsBundleKeys.Sound)
        } else {
            UserDefaults.standard.set(true, forKey: SettingsBundleKeys.Sound)
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
