//
//  ProgressStore.swift
//  IncrementalGame
//
//  Created by Ben Grande on 2017-11-10.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import Foundation
import SpriteKit

class ProgressStore: SKView {
    private var _curA: Int = 0;
    var curA: Int {
        set(val) {
            if val < curA {
                blackout()
            }
            _curA = val;
            updateStores();
            if let controller = superview as? MasterView {
                var zone = controller.playArea.getZone();
                if (!zone.canIncreaseCapacity()) {
                    upgradeZoneAButton.text = "Max Zone Capacity Reached"
                }
                else {
                    let zoneUpPrice = zone.increaseCapacityPrice();
                    if (_curA < zoneUpPrice) {
                        upgradeZoneAButton.fontColor = .gray
                    }
                    else {
                        upgradeZoneAButton.fontColor = .white
                    }
                    upgradeZoneAButton.text = "Upgrade Zone Capacity to "+String(describing: zone.shapeCapacity+1)+" for "+zoneUpPrice.toCurrency()
                }
            }
            

        }
        get {
            return _curA;
        }
    }
    var shapeNode: SKShapeNode;
    var fixtureNode: SKShapeNode;
    var isShape = true;
    var items: [[StoreItem]];
    let feedbackGenerator = UIImpactFeedbackGenerator();
    
    var upgradeZoneAButton: SKLabelNode;
    
    override init(frame: CGRect) {
        
        shapeNode = SKShapeNode(ellipseIn: CGRect(x: 0, y: 0, width: frame.width, height: frame.height));
        fixtureNode = SKShapeNode(ellipseIn: CGRect(x: 0, y: 0, width: frame.width, height: frame.height));
        
        // Add all Shapes and Fixtures in enum
        var items1: [StoreItem] = []
        var items2: [StoreItem] = []
        
        for type in ObjectType.types {
            if type.isFixture() {
                items2.append(StoreItem(objType: type))
            } else {
                items1.append(StoreItem(objType: type))
            }
        }
        
        items = [items1,items2]
        
        
        
        // Adds all the items to the store data
        /*items = [
            [ // RING 1
                StoreItem(objType: .Triangle),
                StoreItem(objType: .Square),
                StoreItem(objType: .Pentagon),
                StoreItem(objType: .Hexagon),
                StoreItem(objType: .Octagon),
                StoreItem(objType: .Circle),
            ],
            [ // RING 2
                StoreItem(objType: .Bonus),
                StoreItem(objType: .Graviton),
                StoreItem(objType: .Vortex),
            ]
        ]*/
        
        upgradeZoneAButton = SKLabelNode(text: "Upgrade Zone Capacity to ");
        // @Austin - how can we make this more visible?
        upgradeZoneAButton.fontSize = 15;
        
        
        super.init(frame: frame);
        
        
        
        
        shapeNode.fillColor = appColor.withAlphaComponent(0.3);
        fixtureNode.fillColor = appColor.withAlphaComponent(0.3);
        presentScene(SKScene(size: frame.size));
        
        
        self.backgroundColor = .clear;
        scene?.backgroundColor = .clear
        
        setupStoreShapes();
        setupStoreFixtures()
        shapeNode.xScale = 0.1
        shapeNode.yScale = 0.1
        
        fixtureNode.xScale = 0.1
        fixtureNode.yScale = 0.1
        shapeNode.position = CGPoint(x: (frame.width/2)-(shapeNode.frame.width/2), y: (frame.height/2)-(shapeNode.frame.height/2))
        fixtureNode.position = CGPoint(x: (frame.width/2)-(fixtureNode.frame.width/2), y: (frame.height/2)-(fixtureNode.frame.height/2))
        
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(drag)));
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
        
        
    }

    func setupStoreShapes() {
        var storeNode = shapeNode;
        var counter = 7*CGFloat.pi/8;
        var incr = -(3*CGFloat.pi/4)/CGFloat(items[0].count) // Base the spacing on the shapes not fixtures
        var halfWidth = frame.width/2;
        
        let imSize = CGSize(width: (frame.width/8.5), height: (frame.width/8.5))
        let hypot = halfWidth - (imSize.width/2)
        for child in storeNode.children {
            child.removeFromParent()
        }
        for shape in items[0] {
            
            let x = cos(counter)*hypot
            let y = sin(counter)*hypot
            let pt = CGPoint(x: halfWidth+x, y: halfWidth+y);
            
            storeNode.addChild(shape);
            shape.physicsBody = nil;
            shape.color = .red
            
            shape.size = imSize
            shape.position = pt
            
            counter += incr
            
        }
        upgradeZoneAButton.position = CGPoint(x: halfWidth, y: halfWidth+10);
        upgradeZoneAButton.zPosition = 0;
        shapeNode.addChild(upgradeZoneAButton);
        upgradeZoneAButton.fontColor = .white;
        blackout();
    }
    func setupStoreFixtures() {
        var storeNode = fixtureNode;
        var counter = 7*CGFloat.pi/8;
        var incr = -(3*CGFloat.pi/4)/CGFloat(items[0].count) // Base the spacing on the shapes not fixtures
        var halfWidth = frame.width/2;
        
        let imSize = CGSize(width: (frame.width/8.5), height: (frame.width/8.5))
        let hypot = halfWidth - (imSize.width/2)
        for child in storeNode.children {
            child.removeFromParent()
        }
        for shape in items[1] {
            
            let x = cos(counter)*hypot
            let y = sin(counter)*hypot
            let pt = CGPoint(x: halfWidth+x, y: halfWidth+y);
            
            storeNode.addChild(shape);
            shape.physicsBody = nil;
            shape.color = .red
            
            shape.size = imSize
            shape.position = pt
            shape.zPosition = 10;
            counter += incr
            
        }
        
        blackout();
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func animateIn() {
        var storeNode = isShape ? shapeNode : fixtureNode;
        shapeNode.removeFromParent();
        fixtureNode.removeFromParent();
        scene?.addChild(storeNode);
        blackout()
        updateStores()
        let move = SKAction.move(to: CGPoint(x: 0, y: 0), duration:0.2)
        let scale = SKAction.scale(by: 10, duration: 0.2)
        
        storeNode.run(scale);
        storeNode.run(move);
        
    }
    func animateOut(callback: @escaping ()->Void) {
        var storeNode = isShape ? shapeNode : fixtureNode;
        let pos = storeNode.frame.width*(9/20) // half of a tenth of the width
        let move = SKAction.move(to: CGPoint(x: pos, y: pos), duration:0.45)
        
        let scale = SKAction.scale(by: 0.10, duration: 0.45)
        storeNode.run(scale);
        storeNode.run(move, completion: {
            storeNode.xScale = 0.1
            storeNode.yScale = 0.1
            storeNode.position = CGPoint(x: (self.frame.width/2)-(storeNode.frame.width/2), y: (self.frame.height/2)-(storeNode.frame.height/2))
            callback();
        })
        
    }
    func blackout() {
        // Makes all shapes black, then shows only the ones that can be added
        // Should be called only when needed (purchasing objects, changing zones)
        var items = isShape ? self.items[0] : self.items[1]
        if let controller = superview as? MasterView {
            for x in items {
                if controller.playArea.getZone().canAdd(type: x.objectType) {
                    x.color = UIColor.black;
                    x.priceLabel.fontColor = .white;
                    x.colorBlendFactor = 1.0;
                }
                else {
                    x.colorBlendFactor = 0.0;
                    if (x.objectType.isFixture()) {
                        x.priceLabel.fontColor = .white;
                    }
                    else {
                        x.priceLabel.fontColor = .black;
                    }
                }
                x.canUpgrade(controller.playArea.getZone());
            }
        }
        
            
        
        nextLowestRing1 = 0;
        nextLowestRing2 = 0;
        updateStores()
        
    }
    var nextLowestRing1 = 0;
    var nextLowestRing2 = 0;
    func getPriceOf(_ storeItem: StoreItem) -> Int {
        //
        if (storeItem.unlocked) {
            return storeItem.objectType.getPrice()
        }
        else {
            return storeItem.objectType.getUnlockPrice()
        }
    }
    func updateStores() {
    
        if let controller = superview as? MasterView {
            
            if (nextLowestRing1 < items[0].count) && isShape {
                var storeItem1 = items[0][nextLowestRing1];
                
                while (curA >= getPriceOf(storeItem1)) {
                    applyFilter(item: storeItem1, controller: controller);
                    nextLowestRing1 += 1;
                    if (nextLowestRing1 >= items[0].count) { // second loop condition
                        break;
                    }
                    storeItem1 = items[0][nextLowestRing1];
                }
            }
            else if (nextLowestRing2 < items[1].count) && !isShape {
                var storeItem2 = items[1][nextLowestRing2];
                while (curA >= getPriceOf(storeItem2)) {
                    applyFilter(item: storeItem2, controller: controller);
                    nextLowestRing2 += 1;
                    if (nextLowestRing2 >= items[1].count) {
                        break;
                    }
                    storeItem2 = items[1][nextLowestRing2];
                }
            }
            
        }
    }
    func applyFilter(item: StoreItem, controller: MasterView) {
        // Makes store items black or normal depending on ability to add
        if (!(controller.playArea.getZone().canAdd(type: item.objectType))) {
            /*if item.objectType.getUnlockPrice() > curA {
                item.color = UIColor.black;
                item.colorBlendFactor = 1.0;
                item.priceLabel.fontColor = .white;
            }
            else {*/
                item.color = UIColor.gray;
                item.colorBlendFactor = 0.0;
                item.priceLabel.fontColor = .black;
            //}
        }
        else if (item.objectType.getPrice() > curA) {
            item.color = UIColor.black;
            item.colorBlendFactor = 1.0;
            // Fixtures are black, shapes are white
            item.priceLabel.fontColor = .white;
        }
        else {
            item.color = UIColor.gray;
            item.colorBlendFactor = 0.0;
            item.priceLabel.fontColor = item.objectType.isFixture() ? .white : .black;
        }
    }
    var selectedNode: StoreItem?;
    var tempSelectedNode: StoreItem?;
    // @Luke - I tried to add an emitter and it didnt show up. Not really sure how it works
    func shapeAchieved(objectType: ObjectType) {
        for shape in items[0] {
            if shape.objectType == objectType {
                // TODO: Do some animation
                var emitter = SKEmitterNode(fileNamed: "MyParticle.sks")
                emitter?.particleTexture = SKTexture(image: shape.objectType.getImage()!)
                emitter?.numParticlesToEmit = 25
                emitter?.particleLifetime = 1.0
                emitter?.position = CGPoint(x:shape.size.width/2 , y:shape.size.height/2)
                emitter?.particleSize = CGSize(width: 40, height: 40)
                emitter?.emissionAngleRange = 10
                emitter?.targetNode = self.shapeNode
                
                let addEmitter = SKAction.run({
                    shape.addChild(emitter!)
                })
                let wait = SKAction.wait(forDuration: 1)
                let remove = SKAction.run({
                    emitter?.removeFromParent()
                })
                
                let sequence = SKAction.sequence([addEmitter, wait, remove])
                shape.run(sequence)
                
            }
        }
        blackout()
    }
    @objc func tap(sender: UITapGestureRecognizer) {
        
        if (sender.state == .ended) {
            let location = CGPoint(x: sender.location(in: self).x, y: frame.height-sender.location(in: self).y)
            let nodes = scene?.nodes(at: location) ?? []
            if (nodes.count > 0) {
                var ind = 0;
                while ind < nodes.count {
                    if let node = nodes[ind] as? StoreItem {
                        if let controller = self.superview as? MasterView {
                            feedbackGenerator.prepare();
                            feedbackGenerator.impactOccurred();
                            
                            controller.purchaseObject(of: node.objectType, sender: nil)
                            
                            return;
                        }
                    }
                    ind += 1;
                }
                ind = 0;
                while ind < nodes.count {
                    if let node = nodes[ind] as? SKLabelNode {
                        // TODO: Implement upgrade capacity
                        if let controller = self.superview as? MasterView {
                            controller.upgradeZone();
                            return;
                        }
                    }
                    ind += 1;
                }
            }
        }
    }
    @objc func drag(sender: UIPanGestureRecognizer) {
        var storeNode = isShape ? shapeNode : fixtureNode;
        switch sender.state {
        case .began:
            var location = CGPoint(x: sender.location(in: self).x, y: frame.height-sender.location(in: self).y)
            let nodes = scene?.nodes(at: location) ?? []
            if (nodes.count > 0) {
                print(nodes);
                var ind = 0;
                var nodeFound = false;
                while !nodeFound {
                    if let node = nodes[ind] as? StoreItem {
                        nodeFound = true;
                        if let controller = self.superview as? MasterView {
                            if !controller.playArea.getZone().allowedObjects.contains(node.objectType) {
                                // TODO: Add wiggle animation
                                return;
                            }
                            selectedNode = node;
                            self.selectedNode!.removeFromParent();
                            self.tempSelectedNode = selectedNode!.copy() as! StoreItem;
                            controller.playArea.scene?.addChild(self.tempSelectedNode!)
                            location = CGPoint(x: sender.location(in: controller.playArea).x, y: controller.playArea.frame.height-sender.location(in: controller.playArea).y)
                            self.tempSelectedNode?.position = location;
                            // TODO: Get size of object
                            //self.tempSelectedNode?.size = CGSize(
                            self.tempSelectedNode?.physicsBody?.isDynamic = false;
                            feedbackGenerator.prepare();
                            feedbackGenerator.impactOccurred();
                            break;
                        }
                    }
                    ind += 1;
                    if (ind >= nodes.count) {
                        break;
                    }
                }
            }
            
            break;
        case .changed:
            
            if let controller = superview as? MasterView {
                let location = CGPoint(x: sender.location(in: controller.playArea).x, y: controller.playArea.frame.height-sender.location(in: controller.playArea).y)
                if (tempSelectedNode != nil) {
                    tempSelectedNode?.position = location;
                }
            }
            break;
        default: // ended, canceled etc.
            
            
                if let controller = superview as? MasterView {
                    var loc = sender.location(in: controller)
                    if (selectedNode != nil) && controller.playArea.frame.contains(loc) {
                        let location = CGPoint(x: sender.location(in: controller.playArea).x, y: controller.playArea.frame.height-sender.location(in: controller.playArea).y)
                        feedbackGenerator.prepare();
                        feedbackGenerator.impactOccurred();
                        controller.purchaseObject(of: selectedNode!.objectType, sender: sender);
                    }
                    
                }
                
                
            
            if (selectedNode != nil) {
                storeNode.addChild(selectedNode!);
            }
            
            selectedNode = nil
            tempSelectedNode?.removeFromParent();
            tempSelectedNode = nil;
            break;
        }
    }
}
