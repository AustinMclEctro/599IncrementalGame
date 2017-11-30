//
//  LiquidView.swift
//  IncrementalGame
//
//  Created by Ben Grande on 2017-11-23.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import Foundation
import SpriteKit

class LiquidView: SKView {
    var visEf: UIVisualEffectView;
    override init(frame: CGRect) {
        visEf = UIVisualEffectView(frame: CGRect(x: 5, y: 5, width: frame.width-10, height: frame.height-10))
        super.init(frame: frame);
        self.autoresizesSubviews = true;
        
        visEf.effect = UIBlurEffect(style: .dark)
        visEf.layer.cornerRadius = 75;
        presentScene(LiquidContainer(size: frame.size))
        visEf.clipsToBounds = true
        self.clipsToBounds = true;
        self.layer.cornerRadius = 75;
        self.addSubview(visEf)
        visEf.layoutMargins = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

