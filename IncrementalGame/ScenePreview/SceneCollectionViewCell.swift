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
    override init(frame: CGRect) {
        
        super.init(frame: frame);
        backgroundColor = .red;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
