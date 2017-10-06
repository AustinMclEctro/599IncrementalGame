//
//  InfoPanel.swift
//  IncrementalGame
//
//  Created by Ben Grande on 2017-10-05.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import Foundation
import UIKit

class InfoPanel: UIView {
    var curALabel: UILabel;
    override init(frame: CGRect) {
        curALabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: frame.height))
        super.init(frame: frame);
        curALabel.text = "F";
        self.addSubview(curALabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func upgradeCurrencyA(to: Int) {
        curALabel.text = "$"+String(to);
    }
   
}
