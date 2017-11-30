//
//  StoreItem.swift
//  IncrementalGame
//
//  Created by Ben Grande on 2017-11-10.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import Foundation
import SpriteKit


class StoreItem: SKSpriteNode {
    
    var objectType: ObjectType
    var object: GameObject?
    var unlocked = false;
    var priceLabel: SKLabelNode;
    convenience init(obj: GameObject) {
        self.init(objType: obj.objectType);
        object = obj;
    }
    init(objType: ObjectType) {
        objectType = objType
        // Configure the appearance of the object
        let im = objectType.getImage() ?? UIImage()
        let texture = SKTexture(image: im)
        unlocked = false;
        
        priceLabel = SKLabelNode(text: "TEST")
        priceLabel.color = .white
        priceLabel.fontSize = 20
        priceLabel.horizontalAlignmentMode = .center;
        priceLabel.verticalAlignmentMode = .center;
        priceLabel.fontName = "AvenirNext-Bold"
        super.init(texture: texture, color: UIColor.clear, size: im.size)
        priceLabel.position = CGPoint(x: position.x, y: position.y-10);
        self.isUserInteractionEnabled = true
        self.addChild(priceLabel);
    }
    func canUpgrade(_ zone: Zone) {
        
        if (self.objectType == nil) {
            return;
        }
        
        if !zone.allowedObjects.contains(self.objectType) {
            unlocked = false;
            let lock = UIImage(named: "Lock") ?? UIImage();
            self.texture = SKTexture(image: lock);
            priceLabel.text = "";//objectType.getUnlockPrice().toCurrency();
        }
        else {
            unlocked = true;
            let im = objectType.getImage() ?? UIImage()
            self.texture = SKTexture(image: im);
            priceLabel.text = objectType.getPrice().toCurrency();
        }
    }
    override func copy() -> Any {
        if (object != nil) {
            let storeItem = StoreItem(obj: self.object!);
            storeItem.size = self.size;
            storeItem.position = self.position;
            return storeItem
        }
        else {
            let storeItem = StoreItem(objType: self.objectType);
            storeItem.size = self.size;
            storeItem.position = self.position;
            return storeItem
        }
    }
    
    // MARK: NSCoding
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
