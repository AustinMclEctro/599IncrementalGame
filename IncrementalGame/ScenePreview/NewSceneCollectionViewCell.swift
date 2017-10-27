//
//  NewSceneCollectionViewCell.swift
//  IncrementalGame
//
//  Created by Ben Grande on 2017-10-26.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import Foundation
import UIKit

class NewSceneCollectionViewCell: UICollectionViewCell {
    var newSceneButton: UIButton;
    var newScenePrice: UILabel;
    override init(frame: CGRect) {
        newSceneButton = UIButton(frame: CGRect(x: frame.width/4, y: 0, width: frame.width/2, height: frame.width/2))
        newScenePrice = UILabel(frame: CGRect(x: 0, y: frame.height/2, width: frame.width, height: frame.height/2))
        newScenePrice.textAlignment = .center
        
        super.init(frame: frame);
        newSceneButton.setImage(UIImage(named: "NewButton"), for: .normal)
        newScenePrice.textColor = .green;
        newScenePrice.text = "";
        self.addSubview(newSceneButton)
        self.addSubview(newScenePrice)
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
