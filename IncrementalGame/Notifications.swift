//
//  Notifications.swift
//  IncrementalGame
//
//  Created by Michael Lee on 2017-11-07.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let currencyChanged = "pointsChanged"
    static let inactiveIncomeRate = "inactiveIncomeRate"
    static let willSaveGameState = "willSaveGameState"
    static let shapesChanged = "shapesChanged"
    static let backgroundIncomeEarned = "backgroundIncomeEarned"
    static let soundPreferenceChanged = "soundPreferenceChanged"
    static let vibrationPreferenceChanged = "hapticFeedbackPreferenceChanged"
    static let resume = "resume"
    static let startupPopupClosed = "startupPopupClosed"
    static let celebration = "celebration"
}
