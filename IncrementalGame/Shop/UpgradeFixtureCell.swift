//
//  UpgradeFixtureCell.swift
//  IncrementalGame
//
//  Created by Ben Grande on 2017-11-20.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import Foundation
import UIKit

class UpgradeFixtureCell: ShopCollectionViewCell {
    
    // MARK: Properties
    
    private var _curA: Int = 0;
    // Change the appearance if cur> price
    var curA: Int {
        set(val) {
            _curA = val;
            if (fixture == nil) {
                return;
            }
            if (fixture!.upgradePrice() > _curA || !fixture!.canUpgrade()) {
                self.addSubview(foreground)
            }
            else {
                foreground.removeFromSuperview();
            }
            
        }
        get {
            return _curA;
        }
    };
    
    var fixtureButton: UIButton;
    var fixturePrice: UILabel;
    var _fixture: Fixture?;
    var foreground: UIView;
    
    var fixture: Fixture? {
        set(val) {
            // Creates one fixture button with one image (only one path for fixtures)
            _fixture = val;
            fixturePrice.text = val?.upgradePrice().toCurrency();
            fixtureButton.setImage(val?.getType().getImage(), for: .normal)
            self.addSubview(fixtureButton);
            self.addSubview(fixturePrice);
            
        }
        get {
            return _fixture;
        }
    }
    
    var upgradeFixture: (Fixture) -> Void = {
        _ in
    }
    
    override var frame: CGRect {
        set(val) {
            super.frame = val;
            // Resizes the frame. Autolayout wasnt working for some reason
            foreground.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
            fixtureButton.frame = CGRect(x: (val.width/4), y: (val.height/2)-25, width: 50, height: 50)
            fixturePrice.frame = CGRect(x: (val.width/4)+50, y: val.height-30, width: frame.width-(val.width/4)-50, height: 30)
        }
        get {
            return super.frame;
        }
    }
    
    
    // MARK: Initializers
    
    
    override init(frame: CGRect) {
        foreground = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        foreground.backgroundColor = UIColor.black.withAlphaComponent(0.3);
        fixtureButton = UIButton(frame: CGRect(x: (frame.width/2)-25, y: (frame.height/2)-25, width: 50, height: 50))
        fixturePrice = UILabel(frame: CGRect(x: 0, y: frame.height-30, width: frame.width, height: 30))
        fixturePrice.textAlignment = .center;
        fixturePrice.textColor = .white;
        super.init(frame: frame)
        
        self.layer.borderColor = appColor.cgColor;
        self.layer.borderWidth = 2.0
        self.layer.cornerRadius = 15;
        self.autoresizesSubviews = true;
        
        fixtureButton.addTarget(self, action: #selector(upgradeFixt), for: .touchUpInside);
    }

    
    // MARK: Functions
    
    
    func checkUpgraes() {
        // TODO
    }
    
    
    @objc func upgradeFixt(sender: UIButton) {
        // Calls upwards on the stack - upgradeFixture is defined by ShopCollectionView which is defined by MasterView
        if (_fixture != nil) {
            upgradeFixture(_fixture!);
        }
    }
    
    
    // MARK: NSCoding
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
