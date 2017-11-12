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
    convenience init(obj: GameObject) {
        self.init(objType: obj.objectType);
        object = obj;
    }
    init(objType: ObjectType) {
        objectType = objType
        // Configure the appearance of the object
        let im = objectType.getImage() ?? UIImage()
        let texture = SKTexture(image: im)
        
        super.init(texture: texture, color: UIColor.clear, size: im.size)
        
        self.isUserInteractionEnabled = true
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
