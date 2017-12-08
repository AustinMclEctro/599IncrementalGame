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
    
    // MARK: Properties
    
    var newSceneButton: UIImageView;
    var newScenePrice: UILabel;
    private var _isNew: Bool = true;
    var isNew: Bool {
        set(val) {
            // TODO - change to upgrade cell
            if (val) {
                self.addSubview(newSceneButton);
                self.addSubview(newScenePrice);
                upgradeA.removeFromSuperview();
                upgradeB.removeFromSuperview();
            }
            else {
                self.newSceneButton.removeFromSuperview();
                self.newScenePrice.removeFromSuperview();
                self.addSubview(upgradeA);
                self.addSubview(upgradeB);
            }
            _isNew = val;
        }
        get {
            return _isNew;
        }
    }
    
    var upgradeA = UIView();
    var upgradeB = UIView();
    
    
    // MARK: Initializers
    
    
    override init(frame: CGRect) {
        let upgradeImage = UIImageView();
        upgradeImage.image = UIImage(named: "ShapeUpgrade");
        let size = upgradeImage.image?.size;
        upgradeImage.frame = CGRect(x: 0, y: 0, width: frame.width/2, height: (frame.width/2)*(size!.height/size!.width));
        upgradeA.addSubview(upgradeImage);
        let upgradeLabel = UILabel(frame: CGRect(x: frame.width/2, y: 0, width: frame.width/2, height: frame.height/2));
        upgradeLabel.text = "+ -$0";
        upgradeLabel.textColor = .white;
        upgradeA.addSubview(upgradeLabel);
        
        let upgradeLabel2 = UILabel(frame: CGRect(x: frame.width/2, y: 0, width: frame.width/2, height: frame.height/2));
        upgradeLabel2.text = "+ -$0";
        upgradeLabel2.textColor = .white;
        upgradeB.frame = CGRect(x: 0, y: frame.height/2, width: frame.width, height: frame.height/2);
        upgradeB.addSubview(upgradeLabel2);
        
        newSceneButton = UIImageView(frame: CGRect(x: frame.width/4, y: 0, width: frame.width/2, height: frame.width/2))
        newScenePrice = UILabel(frame: CGRect(x: 0, y: frame.height/2, width: frame.width, height: frame.height/2))
        newScenePrice.textAlignment = .center
        
        super.init(frame: frame);
        newSceneButton.image = UIImage(named: "NewButton");
        newScenePrice.textColor = appColor//;.green;
        newScenePrice.text = "";
        self.addSubview(newSceneButton)
        self.addSubview(newScenePrice)
    }

    
    // MARK: NSCoding
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
