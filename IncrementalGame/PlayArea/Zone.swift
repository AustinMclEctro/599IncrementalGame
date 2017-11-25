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
    
    struct PigRates {
        static let newZone = 50
        static let upgradeA = [0, 10, 20, 30] // [Lvl0, Lvl1, Lvl2, Lvl3, Lvl4, Lvl5]
        static let upgradeB = [0, 10, 20, 30, 40, 50, 60, 70] // LOOK: Adjust passive rates here
    }
    
    var motionManager = CMMotionManager()
    var maxShapes = 3
    let minVel: CGFloat = 250
    var allowedObjects: Set<ObjectType> = []
    var gravityX: Double = 0
    var gravityY: Double = 0
    var pIG = PassiveIncomeGenerator(backgroundRate: PassiveIncomeGenerator.Rates.defaultBackground, inactiveRate: PassiveIncomeGenerator.Rates.defaultInactive)
    var upgradeALevel = 0
    var upgradeBLevel = 0
    var timer = Timer();
    var lastGravX: Double = 0;
    var lastGravY: Double = 0;
    var hapticXLightGenerator = UISelectionFeedbackGenerator()
    var hapticLightGenerator = UIImpactFeedbackGenerator(style: .light);
    var hapticMediumGenerator = UIImpactFeedbackGenerator(style: .medium);
    var hapticHeavyGenerator = UIImpactFeedbackGenerator(style: .heavy);
    
    init(size: CGSize, children: [SKNode], pIG: PassiveIncomeGenerator?, allowedObjects: Set<ObjectType>?) {
        
        super.init(size: size)
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
        let background = SKSpriteNode(imageNamed: "DefaultSquares")
        background.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        background.scale(to: frame.size);
        self.addChild(background)
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
            self.pIG = PassiveIncomeGenerator(backgroundRate: PassiveIncomeGenerator.Rates.defaultBackground, inactiveRate: PigRates.newZone)
        }
    }
    
    
    func canUpgradeA() -> Bool {
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
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        if let accelData = motionManager.accelerometerData {
            physicsWorld.gravity = CGVector(dx: (accelData.acceleration.x - gravityX) * 50, dy: (accelData.acceleration.y - gravityY) * 50)
        }
 
    }
    
    @objc func resetGravity() {
        if let accelData = motionManager.accelerometerData {
            if abs(accelData.acceleration.x - lastGravX) < 0.1 && abs(accelData.acceleration.y - lastGravY) < 0.1 {
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
        hapticFor(contact: contact);
        if contact.bodyA.velocity.magnitudeSquared() > minVel || contact.bodyB.velocity.magnitudeSquared() > minVel {
            //var hit: Shape? = nil
            //var maxPoints: Int = 0
            if let playArea = view as? PlayArea {
                if let one = contact.bodyA.node as? Shape {
                    //maxPoints = one.getPoints()
                    //hit = one
                    playArea.gained(amount: one.getPoints())
                    //soundFor(one)
                    one.getType().playCollisionSound(one)
                    one.animateCollision()
                }
                
                if let two = contact.bodyB.node as? Shape {
                    //let points = two.getPoints()
                    playArea.gained(amount: two.getPoints())
                    //if points > maxPoints {
                        //hit = two
                    //}
                    //soundFor(two)
                    two.getType().playCollisionSound(two)
                    two.animateCollision()
                }
            
                //hit?.animateCollision()
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
        return shapeCount < maxShapes
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

