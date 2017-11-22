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
    func checkUpgraes() {
        
    }
    var curA: Int = 0;
    var fixture: Fixture? {
        set(val) {
            
        }
        get {
            return nil;
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
