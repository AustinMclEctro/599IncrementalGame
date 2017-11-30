//
//  StartupPopup.swift
//  IncrementalGame
//
//  Created by Michael Lee on 2017-11-12.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import Foundation
import UIKit
import iAd

class StartupPopup : UIView {
    
    // MARK: Constants 
    struct Dimensions {
        static let width: CGFloat = 300.0
        static let height: CGFloat = 400.0
        static let okButtonWidth: CGFloat = 200.0
        static let okButtonHeight: CGFloat = 50.0
        static let headerLabelHeight: CGFloat = 30.0
        static let adHeaderLabelHeight: CGFloat = 20.0
        static let adWidth: CGFloat = 200.0
        static let adHeight: CGFloat = 120.0
        static let backgroundLabelHeight: CGFloat = 60.0
        static let margin: CGFloat = 20.0
    }
    
    // MARK: Properties
    
    var headerLabel = UILabel()
    var backgroundIncomeLabel = UILabel()
    var adHeaderLabel = UILabel()
    var ad = UIImageView()
    var okButton = UIButton()
    
    // MARK: Initializer
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        // Configure popup appearance
        self.layer.cornerRadius = 25.0
        self.clipsToBounds = true
        self.backgroundColor = UIColor.white
    
        // Create and configure header label
        headerLabel.frame = CGRect(x: frame.width/2 - Dimensions.width/2, y: Dimensions.margin, width: Dimensions.width, height: Dimensions.headerLabelHeight )
        headerLabel.font = headerLabel.font.withSize(30)
        headerLabel.text = "You earned:"
        headerLabel.textColor = UIColor.black
        headerLabel.textAlignment = .center
        
        // Create and configure UILabel
        backgroundIncomeLabel.frame = CGRect(x: frame.width/2 - Dimensions.width/2, y: (Dimensions.margin * 2) + Dimensions.headerLabelHeight, width: Dimensions.width, height: Dimensions.backgroundLabelHeight )
        backgroundIncomeLabel.textColor = UIColor.black
        backgroundIncomeLabel.textAlignment = .center
        backgroundIncomeLabel.font = backgroundIncomeLabel.font.withSize(70)
        
        // Create and configure ad header
        adHeaderLabel.frame = CGRect(x: frame.width/2 - Dimensions.width/2, y: (Dimensions.margin * 3) + Dimensions.backgroundLabelHeight + Dimensions.headerLabelHeight, width: Dimensions.width, height: Dimensions.adHeaderLabelHeight )
        adHeaderLabel.font = headerLabel.font.withSize(15)
        adHeaderLabel.text = "Click the ad below to get a multiplier:"
        adHeaderLabel.textColor = UIColor.black
        adHeaderLabel.textAlignment = .center
        
        // Create and configure ad
        ad.frame = CGRect(x: frame.width/2 - Dimensions.width/2, y: (Dimensions.margin * 4) + Dimensions.headerLabelHeight + Dimensions.backgroundLabelHeight + Dimensions.adHeaderLabelHeight, width: Dimensions.width, height: Dimensions.adHeight )
        let image = UIImage(named: "placeholderAd")
        ad.image = image
        //10 + 10 + 10 + Dimensions.headerLabelHeight + Dimensions.backgroundLabelHeight
        
        // Create and configure OK button
        okButton.frame = CGRect(x: frame.width/2 - Dimensions.okButtonWidth/2, y: (Dimensions.margin * 5) + Dimensions.headerLabelHeight + Dimensions.backgroundLabelHeight + Dimensions.adHeaderLabelHeight + Dimensions.adHeight, width: Dimensions.okButtonWidth, height: Dimensions.okButtonHeight )
        okButton.layer.cornerRadius = 15
        okButton.backgroundColor = appColor;//UIColor.red
        okButton.setTitle("Ok", for: .normal)
        okButton.titleLabel?.textAlignment = .center
        okButton.setTitleColor(UIColor.white, for: .normal)
        okButton.addTarget(self, action: #selector(onOkButtonPressed(_:)), for: .touchDown)
        
        // Add components to the popup
        self.addSubview(headerLabel)
        self.addSubview(backgroundIncomeLabel)
        self.addSubview(adHeaderLabel)
        self.addSubview(ad)
        self.addSubview(okButton)
    }
    
    
    /// Callback method that is called when the ok button in the startup popup is pressed.
    @objc func onOkButtonPressed(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notification.Name.startupPopupClosed), object: nil, userInfo: nil)
    }
    
    func displayPopup(incomeEarned: Int) {
        self.backgroundIncomeLabel.text = "\(incomeEarned.toCurrency())"
    }
    
    // MARK: NSCoding
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
