//
//  ObjectType.swift
//  IncrementalGame
//
//  Created by Ben Grande on 2017-10-05.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import Foundation
import SpriteKit
class GameObject: SKSpriteNode {
    var objectType: ObjectType;
    var touched: ((GameObject, Set<UITouch>, UIGestureRecognizerState) -> Void) = {
    _, _, _ in
    return
    };
    
    init(type: ObjectType) {
        objectType = type;
        let im = type.getImage() ?? UIImage()
        let texture = SKTexture(image: im)
        
        super.init(texture: texture, color: UIColor.clear, size: im.size);
        self.isUserInteractionEnabled = true;
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touched(self, touches, .began)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touched(self, touches, .changed)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touched(self, touches, .ended)
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touched(self, touches, .ended);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
enum ObjectType {
    case Circle;
    case Triangle;
    case Square;
    func getImage() -> UIImage? {
        return UIImage(named: String(describing: self));
    }
}
