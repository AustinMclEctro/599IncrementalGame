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
    var logo: UIImageView;
    override init(frame: CGRect) {
        curALabel = UILabel(frame: CGRect(x: 0, y: 20, width: frame.width/3, height: 20))
        curALabel.textAlignment = NSTextAlignment.center
        var height = min(frame.height, 50.0)
        let logoWidth = (183/77)*height
        
        logo = UIImageView(frame: CGRect(x: (frame.width/2)-(logoWidth/2), y: 10, width: logoWidth, height: height))
        logo.image = UIImage(named: "colidr");
        super.init(frame: frame);
        self.backgroundColor = .black;
        curALabel.text = "F";
        self.addSubview(curALabel)
        self.addSubview(logo)
        self.curALabel.textColor = .white;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func upgradeCurrencyA(to: Int) {
        curALabel.text = "$"+String(to);
    }
    
}

