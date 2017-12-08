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
    
    // MARK: Properties
    
    //var curABar: ProgressBar;
    var logo: UIImageView;
    //var currentShapes: CurrentShapes;
    //var progressStore: ProgressStore
    var currencyLabel: UILabel;
    var inactiveRateLabel: UILabel;
    var currencyImage: UIImageView;
    var feedbackGenerator = UIImpactFeedbackGenerator();
    
    
    // MARK: Initializers
    
    
    override init(frame: CGRect) {
        let height = min(frame.height, 50.0)
        let navButtonsHeight: CGFloat = 20.0
        // Configure currency label
        var progressBarFrame = CGRect(x: 30, y: 30, width: height, height: height);
        // TODO - remove menu buttons too?
        let roomLeft = min(frame.height-height-navButtonsHeight, frame.width);
        // TODO: remove if successful - had the progress bar in the left corner
        //if (roomLeft > 100) {
        progressBarFrame = CGRect(x: (frame.width/2)-((roomLeft-20)/2), y: height+10, width: roomLeft-20, height: roomLeft-20)
        //}
        /*curABar = ProgressBar(frame: progressBarFrame)
        curABar.valLabel.textColor = .white;*/
        currencyLabel = UILabel(frame: CGRect(x: 0, y: height+10, width: frame.width, height: 50))
        currencyLabel.textColor = .white;
        currencyLabel.textAlignment = .center;
        
        currencyImage = UIImageView(frame: CGRect(x: (frame.width/2)-100, y: height+10, width: 30, height: 50))
        currencyImage.image = UIImage(named: "PowerCurrency");
        
        // Configure inactive rate label
        inactiveRateLabel = UILabel(frame: CGRect(x: 0, y: height+70, width: frame.width, height: 20));
        inactiveRateLabel.textColor = .white;
        inactiveRateLabel.textAlignment = .center;
        inactiveRateLabel.text = "Passive: -/second" 
        
        // Configure logo
        let logoWidth = (183/77)*height
        logo = UIImageView(frame: CGRect(x: (frame.width/2)-(logoWidth/2), y: 10, width: logoWidth, height: height))
        logo.image = UIImage(named: "colidr");
        
        super.init(frame: frame);
        
        self.backgroundColor = .black;
        self.addSubview(currencyLabel);
        self.addSubview(inactiveRateLabel)
        self.addSubview(currencyImage)
        currencyLabel.font = currencyLabel.font.withSize(50)
        //self.addSubview(curABar)
        self.addSubview(logo)
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
        //curABar.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longPress)))
    }

    
    // MARK: Functions
    
    
    @objc func tap(sender: UITapGestureRecognizer) {
        /*if !curABar.frame.contains(sender.location(in: self)) {
            return;
        }*/
        feedbackGenerator.prepare();
        feedbackGenerator.impactOccurred();
        
    }
    
    
    /// Updates the currency label to a new value.
    ///
    /// - Parameter to: The new currency value.
    func upgradeCurrencyA(to: Int) {
        //curABar.currency = to;
        var cur = to.toCurrency();
        var len = cur.count.distance(to: 0);
        currencyImage.frame = CGRect(x: (frame.width/2)-50.0+(CGFloat(len)*10.0), y: currencyImage.frame.minY, width: currencyImage.frame.width, height: currencyImage.frame.height)
        currencyLabel.text = cur
    }
    
    
    /// Updates the inactive income rate label
    ///
    /// - Parameter amount: The rate at which inactive income is generated.
    func updateInactiveIncomeRate(rate: Int) {
        inactiveRateLabel.text = "Passive: \(rate.toCurrency())/second"
    }
    
    
    // MARK: NSCoding
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

