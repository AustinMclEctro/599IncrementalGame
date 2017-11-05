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
    var newSceneButton: UIImageView;
    var newScenePrice: UILabel;
    private var _isNew: Bool = true;
    var isNew: Bool {
        set(val) {
            // TODO - change to upgrade cell
            if (val) {
                self.backgroundColor = .clear;
            }
            else {
                self.backgroundColor = .blue;
            }
            _isNew = val;
        }
        get {
            return _isNew;
        }
    }
    override init(frame: CGRect) {
        newSceneButton = UIImageView(frame: CGRect(x: frame.width/4, y: 0, width: frame.width/2, height: frame.width/2))
        newScenePrice = UILabel(frame: CGRect(x: 0, y: frame.height/2, width: frame.width, height: frame.height/2))
        newScenePrice.textAlignment = .center
        
        super.init(frame: frame);
        newSceneButton.image = UIImage(named: "NewButton");
        newScenePrice.textColor = .green;
        newScenePrice.text = "";
        self.addSubview(newSceneButton)
        self.addSubview(newScenePrice)
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
