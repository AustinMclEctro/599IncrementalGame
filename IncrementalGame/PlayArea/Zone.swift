//
//  Zone.swift
//  IncrementalGame
//
//  Created by Andrew Groeneveldt on 10-06-2017.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import UIKit
import SpriteKit
import CoreMotion

class Zone: SKScene, SKPhysicsContactDelegate {
    
    var motionManager = CMMotionManager()
    var shapeCapacity = 3
    let maxCapacity = 12
    let minHit: CGFloat = 750
    var allowedObjects: Set<ObjectType> = []
    var gravityX: Double = 0
    var gravityY: Double = 0
    var pIG = PassiveIncomeGenerator(backgroundRate: PassiveIncomeGenerator.Rates.defaultBackground, inactiveRate: PassiveIncomeGenerator.Rates.defaultInactive)
    let basePigRate = 5
    var upgradeALevel = 0
    var upgradeBLevel = 0
    var timer = Timer();
    var lastGravX: Double = 0;
    var lastGravY: Double = 0;
    var hapticXLightGenerator = UISelectionFeedbackGenerator()
    var hapticLightGenerator = UIImpactFeedbackGenerator(style: .light);
    var hapticMediumGenerator = UIImpactFeedbackGenerator(style: .medium);
    var hapticHeavyGenerator = UIImpactFeedbackGenerator(style: .heavy);
    
    var liquid: SKSpriteNode
    var lastCurrency = 100

    
    //var seconds: Double = 0 // for testing collision rates only, not for production
    //var hits: Double = 0 // for testing collision rates only, not for production
    
    init(size: CGSize, children: [SKNode], pIG: PassiveIncomeGenerator?, allowedObjects: Set<ObjectType>?) {
        liquid = SKSpriteNode(color: .blue, size: CGSize(width: size.width, height: size.height))
        
        super.init(size: size)
        //Add progress "Liquid"
        liquid.position = CGPoint(x: size.width/2, y: -size.height)
        liquid.anchorPoint = CGPoint(x: 0.5, y: 0)
        //liquid.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: 10), center: CGPoint(x: 0, y: liquid.size.height/2));
        //liquid.physicsBody?.pinned = true;
        //liquid.physicsBody?.angularDamping = 1.0
        
        //backgroundColor = SKColor.black
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(resetGravity), userInfo: nil, repeats: true);
        motionManager.startAccelerometerUpdates()
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        let boundRect = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        let boundPath = UIBezierPath(roundedRect: boundRect, cornerRadius: 75.0)
        let boundary = SKPhysicsBody(edgeLoopFrom: boundPath.cgPath)
        boundary.friction = 1
        boundary.categoryBitMask = 1
        boundary.contactTestBitMask = 1
        boundary.collisionBitMask = 1
        boundary.usesPreciseCollisionDetection = true
        self.physicsBody = boundary
        let outline = SKShapeNode(path: boundPath.cgPath)
        outline.lineWidth = 5
        outline.fillColor = .clear
        outline.strokeColor = .white
        outline.glowWidth = 1.5
        self.addChild(liquid)
        self.addChild(outline)
        
        addAllowedObject(type: .Triangle)
        addAllowedObject(type: .Bumper)
        
        // Load zone properties
        if !children.isEmpty {
            for child in children {
                self.addChild(child)
            }
        }
        if allowedObjects != nil {
            self.allowedObjects = allowedObjects!
        }
        if pIG != nil {
            self.pIG = pIG!
        } else {
            self.pIG = PassiveIncomeGenerator(backgroundRate: PassiveIncomeGenerator.Rates.defaultBackground, inactiveRate: basePigRate)
        }
    }
    
    func updateProgress(money: Int) {
        if money > lastCurrency {
            lastCurrency = lastCurrency * 10
            let moveTop = SKAction.moveTo(y: 0, duration: 0.5)
            let emitter = SKEmitterNode(fileNamed: "MyParticle.sks")
            emitter?.particleTexture = SKTexture(imageNamed: "Octagon")
            emitter?.numParticlesToEmit = 30
            emitter?.particleLifetime = 0.5
            emitter?.position = CGPoint(x: size.width/2, y: size.height-10)
            emitter?.particleSize = CGSize(width:80, height: 80)
            let addEmitter = SKAction.run({
                self.addChild(emitter!)
            })
            let wait = SKAction.wait(forDuration: 1)
            let remove = SKAction.run({
                self.removeFromParent()
            })
            
            let moveBot = SKAction.moveTo(y: -size.height + size.height*0.1, duration: 0.5)
            let celebrate = SKAction.sequence([moveTop,addEmitter,wait,remove, moveBot])
            liquid.run(celebrate)
            
        } else {
            let percent = CGFloat(money)/CGFloat(lastCurrency)
            let moveAction = SKAction.moveTo(y: -size.height + percent*size.height, duration: 0.5)
            liquid.run(moveAction)
        }
    }
    
    /*func canUpgradeA() -> Bool {
        return upgradeALevel < 3
    }
    
    func upgradeA() {
        guard canUpgradeA() else {return}
        upgradeALevel += 1
        pIG.feed(portion: PigRates.upgradeA[upgradeALevel])
        maxShapes += 3
    }
    
    func canUpgradeB() -> Bool {
        return upgradeBLevel < 7
    }
    func upgradeB(objectType: ObjectType) {
        addAllowedObject(type: objectType)
    }
    func upgradeB() {
        upgradeBLevel += 1
        pIG.feed(portion: PigRates.upgradeB[upgradeBLevel])
        switch upgradeBLevel {
        case 1:
            addAllowedObject(type: .Square)
        case 2:
            addAllowedObject(type: .Graviton)
        case 3:
            addAllowedObject(type: .Pentagon)
        case 4:
            addAllowedObject(type: .Hexagon)
        case 5:
            addAllowedObject(type: .Vortex)
        case 6:
            addAllowedObject(type: .Circle)
        case 7:
            addAllowedObject(type: .Star)
        default:
            return
        }
    }*/
    
    func getPassiveRate() -> Int {
        return pIG.inactiveRate
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if let accelData = motionManager.accelerometerData {
            physicsWorld.gravity = CGVector(dx: (accelData.acceleration.x - gravityX) * 50, dy: (accelData.acceleration.y - gravityY) * 50)
        }
 
    }
    
    @objc func resetGravity() {
        if let accelData = motionManager.accelerometerData {
            if abs(accelData.acceleration.x - lastGravX) < 0.05 && abs(accelData.acceleration.y - lastGravY) < 0.05 {
                gravityX = (gravityX + accelData.acceleration.x) / 2.0
                gravityY = (gravityY + accelData.acceleration.y) / 2.0
            }
            lastGravX = accelData.acceleration.x
            lastGravY = accelData.acceleration.y
        }
        //seconds += 1 // for testing collision rates only, not for production
        //print(hits/seconds) // for testing collision rates only, not for production
    }
    
    func hasSounds() -> Bool {
        return false;
    }
    
    func hapticFor(contact: SKPhysicsContact) {
        let hasHaptics = UserDefaults.standard.bool(forKey: SettingsBundleKeys.Vibration);
        if hasHaptics {
            let fakeFA = contact.bodyA.angularVelocity*contact.bodyA.mass;
            let fakeFB = contact.bodyB.angularVelocity*contact.bodyB.mass;
            
            let totFakeF = abs(fakeFA)+abs(fakeFB);
            if (totFakeF < 5) {
                return;
            }
            if totFakeF < 10 {
                hapticXLightGenerator.prepare()
                hapticXLightGenerator.selectionChanged()
            }
            else if (totFakeF < 15) {
                hapticLightGenerator.prepare()
                hapticLightGenerator.impactOccurred()
            }
            else if (totFakeF < 25) {
                hapticMediumGenerator.prepare()
                hapticMediumGenerator.impactOccurred()
            }
            else {
                hapticHeavyGenerator.prepare()
                hapticHeavyGenerator.impactOccurred()
            }
        }
        
    }
    
    func soundFor(_ object: GameObject) {
        let hasSound = UserDefaults.standard.bool(forKey: SettingsBundleKeys.Sound);
        if hasSound {
            object.getType().playCollisionSound(object)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        //print(contact.collisionImpulse) // testing only
        guard contact.collisionImpulse > minHit else {return}
        hapticFor(contact: contact);
        if let playArea = view as? PlayArea {
            if let one = contact.bodyA.node as? Shape {
                playArea.gained(amount: one.getPoints())
                //hits += 1 // for testing collision rates only, not for production
                one.getType().playCollisionSound(one)
                one.animateCollision()
            }
            
            if let two = contact.bodyB.node as? Shape {
                playArea.gained(amount: two.getPoints())
                //hits += 1 // for testing collision rates only, not for production
                two.getType().playCollisionSound(two)
                two.animateCollision()
            }
        }
    }
    
    /// Returns a Boolean indicating whether the ObjectType can be added. Only allowed objects
    /// below the maximum permitted amount of items under that ObjectType can be added.
    ///
    /// - Parameter type: The ObjectType (triange, bumper, etc.)
    /// - Returns: True if the object can be added, otherwise false.
    func canAdd(type: ObjectType) -> Bool {
        guard allowedObjects.contains(type) else {return false}
        
        guard !type.isFixture() else {return true}
        
        var shapeCount = 0
        
        // Get and check shape count
        for object in self.children {
            if object is Shape {
                shapeCount += 1
            }
        }
        return shapeCount < shapeCapacity
    }
    
    func addShape(of: ObjectType, at: CGPoint) -> Shape? {
        guard canAdd(type: of) else {return nil}
        let shape = Shape(type: of, at: at, inZone: self);
        addChild(shape);
        pIG.feed(portion: shape.objectType.getPigRateNew());
        let data: [String: Zone] = ["zone": self]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notification.Name.shapesChanged), object: nil, userInfo: data)
        return shape;
    }
    
    func addFixture(of: ObjectType, at: CGPoint) -> Fixture? {
        guard canAdd(type: of) else {return nil}
        let fix = Fixture(type: of, at: at, inZone: self);
        addChild(fix);
        pIG.feed(portion: fix.objectType.getPigRateNew());
        removeAllowedObject(type: of)
        let data: [String: Zone] = ["zone": self]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notification.Name.shapesChanged), object: nil, userInfo: data)
        return fix
    }
    
    func canIncreaseCapacity() -> Bool {
        return shapeCapacity < maxCapacity
    }
    
    func increaseShapeCapacity() {
        guard canIncreaseCapacity() else {return}
        shapeCapacity += 1
    }
    
    func increaseCapacityPrice() -> Int {
        return 100
    }
    
    /// Adds an ObjectType to the allowedObjects array.
    ///
    /// - Parameter type: The ObjectType (triange, bumper, etc.)
    func addAllowedObject(type: ObjectType) {
        allowedObjects.insert(type)
    }
    
    
    /// Removes an ObjectType to the allowedObjects array.
    ///
    /// - Parameter type: The ObjectType (triange, bumper, etc.)
    func removeAllowedObject(type: ObjectType) {
        allowedObjects.remove(type)
    }
    
    
    // MARK: NSCoding
    
    /// Keys used to reference the properties in memory
    struct PropertyKey {
        static let size = "size"
        static let children = "children"
        static let allowedObjects = "allowedObjects"
        static let pIG = "pIG"
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(size, forKey: PropertyKey.size)
        aCoder.encode(pIG, forKey: PropertyKey.pIG)
        try? (aCoder as! NSKeyedArchiver).encodeEncodable(Array(allowedObjects), forKey: PropertyKey.allowedObjects)
        
        //Save only GameObjects
        var childrenToSave = [SKNode]()
        for child in children {
            if let gameObject = child as? GameObject {
                childrenToSave.append(gameObject)
            }
        }
        aCoder.encode(childrenToSave, forKey: PropertyKey.children)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let size = aDecoder.decodeCGSize(forKey: PropertyKey.size)
        let children = aDecoder.decodeObject(forKey: PropertyKey.children) as! [SKNode]
        let allowedObjects = Set((aDecoder as! NSKeyedUnarchiver).decodeDecodable([ObjectType].self, forKey: PropertyKey.allowedObjects)!)
        let pIG = aDecoder.decodeObject(forKey: PropertyKey.pIG) as! PassiveIncomeGenerator
        self.init(size: size, children: children, pIG: pIG, allowedObjects: allowedObjects)
    }
}

extension CGVector {
    func magnitudeSquared() -> CGFloat {
        return (self.dx * self.dx) + (self.dy * self.dy)
    }
}

