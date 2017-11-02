//
//  InfoPanel.swift
//  IncrementalGame
//
//  Created by Ben Grande on 2017-10-05.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import Foundation
import UIKit


/// The view at the top of the game screen that is used to display information
/// related to the game including the game logo and the user's current score.
class InfoPanel: UIView {
    
    var curABar: ProgressBar;
    var logo: UIImageView;
    
    override init(frame: CGRect) {
        let height = min(frame.height, 50.0)
        let navButtonsHeight: CGFloat = 60.0
        // Configure currency label
        var progressBarFrame = CGRect(x: 30, y: 30, width: height, height: height);
        // TODO - remove menu buttons too?
        let roomLeft = min(frame.height-height-navButtonsHeight, frame.width);
        
        if (roomLeft > 100) {
            progressBarFrame = CGRect(x: (frame.width/2)-((roomLeft-20)/2), y: height+10, width: roomLeft-20, height: roomLeft-20)
        }
        curABar = ProgressBar(frame: progressBarFrame)
        curABar.valLabel.textColor = .white;
        // Configure logo
        let logoWidth = (183/77)*height
        logo = UIImageView(frame: CGRect(x: (frame.width/2)-(logoWidth/2), y: 10, width: logoWidth, height: height))
        logo.image = UIImage(named: "colidr");
        super.init(frame: frame);
        self.backgroundColor = .black;
        self.addSubview(curABar)
        self.addSubview(logo)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// Updates the currency label to a new value.
    ///
    /// - Parameter to: The new currency value.
    func upgradeCurrencyA(to: Int) {
        curABar.currency = to;
    }
    
}

