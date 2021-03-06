//
//  ShopCollectionViewCell.swift
//  IncrementalGame
//
//  Created by Ben Grande on 2017-11-20.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import Foundation
import UIKit

class ShopCollectionViewCell: UICollectionViewCell {
    
    // MARK: Properties
    
    var acceptsTouches: Bool = false;

    
    // MARK: Initializers
    
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.backgroundColor = .black
    }
    
    
    // MARK: Functions
    
    // Need an equal function to see if center is the same as left
    override func isEqual(_ object: Any?) -> Bool {
        if let shape = self as? UpgradeShapeCell {
            if let shape2 = object as? UpgradeShapeCell {
                let sh2 = shape2.shape
                let sh1 = shape.shape;
                if (sh1?.objectType != sh2?.objectType) {
                    return false
                }
                if sh1?.upgradeALevel == sh2?.upgradeALevel && sh1?.upgradeBLevel == sh2?.upgradeBLevel && sh1?.upgradeCLevel == sh2?.upgradeCLevel {
                    return true;
                }
                return true;
            }
            return false;
        }
        else if let fixture = self as? UpgradeFixtureCell {
            if let fixture2 = object as? UpgradeFixtureCell {
                return fixture2.fixture?.objectType == fixture.fixture?.objectType
            }
        }
        return false
    }
    
    
    // MARK: NSCoding
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
