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
    override init(frame: CGRect) {
        imagePreview = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height));
        super.init(frame: frame);
        self.addSubview(imagePreview);
        backgroundColor = .red;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
