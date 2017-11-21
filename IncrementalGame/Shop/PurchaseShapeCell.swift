//
//  PurchaseShapeCell.swift
//  IncrementalGame
//
//  Created by Ben Grande on 2017-11-20.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import Foundation
import UIKit

class PurchaseShapeCell: ShopCollectionViewCell {
    var label: UILabel;
    var toggleShop: () -> Void = {
        
    }
    override init(frame: CGRect) {
        label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        label.text = "Buy A Shape";
        super.init(frame: frame)
        self.layer.cornerRadius = 15;
        self.layer.borderColor = appColor.cgColor;
        self.layer.borderWidth = 2.0
        label.textAlignment = .center
        label.textColor = .white;
        label.autoresizingMask = .flexibleHeight;
        
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        label.numberOfLines = 0;
        label.font = label.font.withSize(20)
        
        label.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.autoresizesSubviews = true;
        self.addSubview(label);
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapPurchase)))
    }
    @objc func tapPurchase(sender: UITapGestureRecognizer) {
        if (sender.state == .ended) {
            toggleShop();
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
