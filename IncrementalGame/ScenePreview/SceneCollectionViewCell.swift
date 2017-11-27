//
//  SceneCollectionViewCell.swift
//  IncrementalGame
//
//  Created by Ben Grande on 2017-10-26.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import Foundation
import UIKit

class SceneCollectionViewCell: UICollectionViewCell {
    
    var image: UIImage? {
        set(val) {
            imagePreview.image = val;
        }
        get {
            return imagePreview.image;
        }
    }
    var imagePreview: UIImageView;
    var inactiveRateLabel: UILabel;
    
    override init(frame: CGRect) {
        
        // Configure preview of zone
        imagePreview = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height - 20)); // - 20 for passive rate label

        // Configure passive rate label
        inactiveRateLabel = UILabel(frame: CGRect(x: 0, y: frame.height - 15, width: frame.width, height: 15))
        inactiveRateLabel.text = "Passive Rate"  // TODO: Get passive rate
        inactiveRateLabel.textColor = UIColor.white
        inactiveRateLabel.textAlignment = NSTextAlignment.center
        inactiveRateLabel.isHidden = false
        
        super.init(frame: frame);
        self.addSubview(inactiveRateLabel)
        self.addSubview(imagePreview);
    }
    
    
    /// Sets the rate for the inactive rate label in the cell
    ///
    /// - Parameter rate: The inactive income rate
    func setInactiveRate(rate: Int) {
        inactiveRateLabel.text = "\(rate)/second"
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
