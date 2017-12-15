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
    
    // MARK: Properties
    // Setter for _curA to update whether each shape/fixture is blacked out or not
    private var _curA: Int = 0;
    var curA: Int {
        set(val) {
            if val < curA {
                // Makes all shapes black
                blackout()
            }
            _curA = val;
            // Colours in required shapes (can afford, add and if capacity is not reached)
            updateStores();
            if let controller = superview as? MasterView {
                let zone = controller.playArea.getZone();
                if (!zone.canIncreaseCapacity()) {
                    upgradeZoneAButton.text = "Max Zone Capacity Reached"
                }
                else {
                    // The Zone capacity upgrade label - Need to make more visible!!!
                    let zoneUpPrice = zone.increaseCapacityPrice();
                    if (_curA < zoneUpPrice) {
                        upgradeZoneAButton.fontColor = .gray
                    }
                    else {
                        upgradeZoneAButton.fontColor = .white
                    }
                    // We will make this more visible
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
    var selectedNode: StoreItem?;
    var tempSelectedNode: StoreItem?;
    
    
    // MARK: Initializers
    
    
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

    
    // MARK: Functions
    // Note: originally the fixtures and shapes were in same view. To avoid complete redesign, kept in same view but in different nodes
    // First setup of shapes, only called once
    func setupStoreShapes() {
        let storeNode = shapeNode;
        var counter = 7*CGFloat.pi/8;
        let incr = -(3*CGFloat.pi/4)/CGFloat(items[0].count) // Base the spacing on the shapes not fixtures
        let halfWidth = frame.width/2;
        
        let imSize = CGSize(width: (frame.width/8.5), height: (frame.width/8.5))
        let hypot = halfWidth - (imSize.width/2)
        for child in storeNode.children {
            child.removeFromParent()
        }
        // iterates through shapes and adds them to correct location
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
    
    // Sets up all store fixtures, should only call once
    func setupStoreFixtures() {
        let storeNode = fixtureNode;
        var counter = 7*CGFloat.pi/8;
        let incr = -(3*CGFloat.pi/4)/CGFloat(items[0].count) // Base the spacing on the shapes not fixtures
        let halfWidth = frame.width/2;
        
        let imSize = CGSize(width: (frame.width/8.5), height: (frame.width/8.5))
        let hypot = halfWidth - (imSize.width/2)
        for child in storeNode.children {
            child.removeFromParent()
        }
        // Iterates through all fixtures and places
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
    
    // Animates the 'growing' of the shape node holding the shapes/fixtures
    func animateIn() {
        let storeNode = isShape ? shapeNode : fixtureNode;
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
    
    // Shrinks the node holding shapes/fixtures
    func animateOut(callback: @escaping ()->Void) {
        let storeNode = isShape ? shapeNode : fixtureNode;
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
        let items = isShape ? self.items[0] : self.items[1]
        if let controller = superview as? MasterView {
            for x in items {
                // Make all allowed shapes blacked out (otherwise they are locks and should be blue)
                if (controller.playArea.getZone().allowedObjects.contains(x.objectType)) {
                    x.color = UIColor.black;
                    x.priceLabel.fontColor = .white;
                    x.colorBlendFactor = 1.0;
                }
                else {
                    x.priceLabel.fontColor = .black;
                    x.colorBlendFactor = 0;
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
            return 0
        }
    }
    
    // Colours in all shapes/fixtures that can possibly be added
    func updateStores() {
    
        if let controller = superview as? MasterView {
            
            if (nextLowestRing1 < items[0].count) && isShape {
                // If zone is full and we are adding shapes, then black them all out
                if (controller.playArea.getZone().zoneFull()) {
                    return;
                }
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
        if !(controller.playArea.getZone().allowedObjects.contains(item.objectType)) {
        //if (!(controller.playArea.getZone().canAdd(type: item.objectType))) {
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
    // Creates animation for 'celebration' with sparks
    func shapeAchieved(objectType: ObjectType) {
        for shape in items[0] {
            if shape.objectType == objectType {
                let emitter = SKEmitterNode(fileNamed: "MyParticle.sks")
                emitter?.particleTexture = SKTexture(image: shape.objectType.getImage()!)
                emitter?.numParticlesToEmit = 25
                emitter?.particleLifetime = 1.0
                emitter?.position = CGPoint(x:0, y:0)
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
        // Updates entire view to reflect changes
        blackout()
        let when = DispatchTime.now() + 2 // Keep shop open for 2 seconds then close
        DispatchQueue.main.asyncAfter(deadline: when) {
            if let controller = self.superview as? MasterView {
                controller.closeShop();
            }
        }
    }
    
    // Checks if shape/fixture added, or if label pressed
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
                    if nodes[ind] is SKLabelNode {
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
    
    // Checks if shape/fixture dragged
    @objc func drag(sender: UIPanGestureRecognizer) {
        let storeNode = isShape ? shapeNode : fixtureNode;
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
                                // TODO: Add wiggle animation?
                                return;
                            }
                            selectedNode = node;
                            self.selectedNode!.removeFromParent();
                            self.tempSelectedNode = selectedNode!.copy() as? StoreItem;
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
                    let loc = sender.location(in: controller)
                    if (selectedNode != nil) && controller.playArea.frame.contains(loc) {
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
    
    
    // MARK: NSCoding
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
