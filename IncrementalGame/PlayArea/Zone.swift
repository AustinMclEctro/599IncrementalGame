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
    
    // MARK: Properties
    
    var motionManager = CMMotionManager()
    var shapeCapacity = 3                   // TO SAVE
    let maxCapacity = 12
    let minHit: CGFloat = 200 // lowered for demo
    var allowedObjects: Set<ObjectType> = []    // TO SAVE
    var gravityX: Double = 0
    var gravityY: Double = 0
    var pIG = PassiveIncomeGenerator(backgroundRate: PassiveIncomeGenerator.Rates.defaultBackground, inactiveRate: PassiveIncomeGenerator.Rates.defaultInactive)    // TO SAVE
    let basePigRate = 5
    var timer = Timer();
    var lastGravX: Double = 0;
    var lastGravY: Double = 0;
    var hapticXLightGenerator = UISelectionFeedbackGenerator()
    var hapticLightGenerator = UIImpactFeedbackGenerator(style: .light);
    var hapticMediumGenerator = UIImpactFeedbackGenerator(style: .medium);
    var hapticHeavyGenerator = UIImpactFeedbackGenerator(style: .heavy);
    
    var liquid: SKSpriteNode
    
    var cumulative: Int = 0     // TO SAVE
    //This needs to be set to the next multiple above the starting amount. 
    var lastCurrency = 100      // TO SAVE
    
    // TO SAVE - children should be saved
    
    
    
    // MARK: Initializers
    
    
    init(size: CGSize, children: [SKNode], pIG: PassiveIncomeGenerator?, allowedObjects: Set<ObjectType>? = nil, shapeCapacity: Int? = nil, cumulative: Int? = nil, lastCurrency: Int? = nil) {
        

        liquid = SKSpriteNode(color: .blue, size: CGSize(width: size.width, height: size.height))
        
        super.init(size: size)
        
        // Load zone properties
        
        if allowedObjects != nil { self.allowedObjects = allowedObjects! }
        if let sC = shapeCapacity { self.shapeCapacity = sC }
        if let c = cumulative { self.cumulative = c }
        if let lC = lastCurrency { self.lastCurrency = lC }
        
        if !children.isEmpty {
            for child in children {
                self.addChild(child)
            }
        }

        if pIG != nil {
            self.pIG = pIG!
        } else {
            self.pIG = PassiveIncomeGenerator(backgroundRate: PassiveIncomeGenerator.Rates.defaultBackground, inactiveRate: basePigRate)
        }
        
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
        boundary.categoryBitMask = 2
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
        
        // for Demo Only
        addAllowedObject(type: .Bonus)
        addAllowedObject(type: .Graviton)
        addAllowedObject(type: .Vortex)
    }
    
    
    // MARK: Functions
    
    
    func getCumulative() -> Int {
        return cumulative
    }
    
    
    func updateProgress(money: Int) {
        cumulative += money
        if cumulative > lastCurrency {
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
                emitter?.removeFromParent()
            })
            
            let moveBot = SKAction.moveTo(y: -size.height + size.height*0.1, duration: 0.5)
            let celebrate = SKAction.sequence([moveTop,addEmitter,wait,remove, moveBot])
            liquid.run(celebrate)
            
            //Post the notification that the area is upgraded
            let data: [String: ObjectType] = ["Shape": getNextShape()!]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notification.Name.celebration), object: nil, userInfo: data)
            
            
        } else {
            let percent = CGFloat(cumulative)/CGFloat(lastCurrency)
            let moveAction = SKAction.moveTo(y: -size.height + percent*size.height, duration: 0.5)
            liquid.run(moveAction)
        }
    }
    
    
    func getNextShape() -> ObjectType? {
        for shape in ObjectType.types {
            if !canAdd(type: shape){
                return shape
            }
        }
        return nil
    }
    
    
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
        // one contact body will always be a shape so forced downcasting ok
        
        // turn on bonus for shape entering bonus zone
        if contact.bodyA.categoryBitMask == 8 {
            let shape = contact.bodyB.node as! Shape
            let fix = contact.bodyA.node as! Fixture
            shape.bonusValue = Int((Float(fix.upgradeLevel+1)*Float(shape.pointValue)/10.0)+0.5)
            return
        }
        if contact.bodyB.categoryBitMask == 8 {
            let shape = contact.bodyA.node as! Shape
            let fix = contact.bodyB.node as! Fixture
            shape.bonusValue = Int((Float(fix.upgradeLevel+1)*Float(shape.pointValue)/10.0)+0.5)
            return
        }
        
        guard contact.collisionImpulse > minHit else {return}
        hapticFor(contact: contact);
        if let playArea = view as? PlayArea {
            if let one = contact.bodyA.node as? Shape {
                playArea.gained(amount: one.getPoints())
                if (UserDefaults.standard.bool(forKey: SettingsBundleKeys.Sound)) {one.getType().playCollisionSound(one)}
                one.animateCollision()
            }
            
            if let two = contact.bodyB.node as? Shape {
                playArea.gained(amount: two.getPoints())
                if (UserDefaults.standard.bool(forKey: SettingsBundleKeys.Sound)) {two.getType().playCollisionSound(two)}
                two.animateCollision()
            }
        }
    }
    
    
    func didEnd(_ contact: SKPhysicsContact) {
        let categoryA = contact.bodyA.categoryBitMask
        let categoryB = contact.bodyB.categoryBitMask
        guard categoryA == 8 || categoryB == 8 else {return} // don't care unless shape leaving bonus zone
        
        // turn off bonus for shape leaving bonus zone
        if categoryA == 8 {
            (contact.bodyB.node as! Shape).bonusValue = 0
        } else {
            (contact.bodyA.node as! Shape).bonusValue = 0
        }
    }
    
    
    /// Returns a Boolean indicating whether the ObjectType can be added. Only allowed objects
    /// below the maximum permitted amount of items under that ObjectType can be added.
    ///
    /// - Parameter type: The ObjectType (triange, vortex, etc.)
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
        let shape = Shape(type: of, at: at, zoneSize: size, inZone: self);
        addChild(shape);
        pIG.feed(portion: shape.objectType.getPigRateNew());
        let data: [String: Zone] = ["zone": self]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notification.Name.shapesChanged), object: nil, userInfo: data)
        let playAddShapeSound = SKAction.playSoundFileNamed("ShapeCreation", waitForCompletion: false)
        if (UserDefaults.standard.bool(forKey: SettingsBundleKeys.Sound)) {shape.run(playAddShapeSound)}
        return shape;
    }
    
    
    func addFixture(of: ObjectType, at: CGPoint) -> Fixture? {
        guard canAdd(type: of) else {return nil}
        let fix = Fixture(type: of, at: at, inZone: self, zoneSize: size);
        addChild(fix);
        pIG.feed(portion: fix.objectType.getPigRateNew());
        removeAllowedObject(type: of)
        let data: [String: Zone] = ["zone": self]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notification.Name.shapesChanged), object: nil, userInfo: data)
        let playAddFixtureSound = SKAction.playSoundFileNamed("FixtureCreation", waitForCompletion: false)
        if (UserDefaults.standard.bool(forKey: SettingsBundleKeys.Sound)) {fix.run(playAddFixtureSound)}
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
        guard canIncreaseCapacity() else {return -1}
        return 100
    }
    
    
    /// Adds an ObjectType to the allowedObjects array.
    ///
    /// - Parameter type: The ObjectType (triange, vortex, etc.)
    func addAllowedObject(type: ObjectType) {
        allowedObjects.insert(type)
    }
    
    
    /// Removes an ObjectType to the allowedObjects array.
    ///
    /// - Parameter type: The ObjectType (triange, vortex, etc.)
    func removeAllowedObject(type: ObjectType) {
        allowedObjects.remove(type)
    }
    
    
    // MARK: NSCoding
    
    
    /// Keys used to reference the properties in memory
    struct PropertyKey {
        static let size = "size"
        static let children = "children"
        static let allowedObjects = "allowedObjects"
        static let shapeCapacity = "shapeCapacity"
        static let cumulative = "cumulative"
        static let lastCurrency = "lastCurrency"
        static let pIG = "pIG"
    }
    
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(size, forKey: PropertyKey.size)
        aCoder.encode(pIG, forKey: PropertyKey.pIG)
        try? (aCoder as! NSKeyedArchiver).encodeEncodable(Array(allowedObjects), forKey: PropertyKey.allowedObjects)
        aCoder.encode(self.shapeCapacity, forKey: PropertyKey.shapeCapacity)
        aCoder.encode(self.cumulative, forKey: PropertyKey.cumulative)
        aCoder.encode(self.lastCurrency, forKey: PropertyKey.lastCurrency)
        
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
        let loadedSize = aDecoder.decodeCGSize(forKey: PropertyKey.size)
        let loadedChildren = aDecoder.decodeObject(forKey: PropertyKey.children) as! [SKNode]
        let loadedAllowedObjects = Set((aDecoder as! NSKeyedUnarchiver).decodeDecodable([ObjectType].self, forKey: PropertyKey.allowedObjects)!)
        let loadedPIG = aDecoder.decodeObject(forKey: PropertyKey.pIG) as! PassiveIncomeGenerator
        let loadedShapeCapacity = aDecoder.decodeInteger(forKey: PropertyKey.shapeCapacity)
        let loadedCumulative = aDecoder.decodeInteger(forKey: PropertyKey.cumulative)
        let loadedLastCurrency = aDecoder.decodeInteger(forKey: PropertyKey.lastCurrency)
        
        self.init(size: loadedSize, children: loadedChildren, pIG: loadedPIG, allowedObjects: loadedAllowedObjects, shapeCapacity: loadedShapeCapacity, cumulative: loadedCumulative, lastCurrency: loadedLastCurrency)
    }
}


extension CGVector {
    func magnitudeSquared() -> CGFloat {
        return (self.dx * self.dx) + (self.dy * self.dy)
    }
}

