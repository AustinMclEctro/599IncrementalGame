//
//  Shape.swift
//  IncrementalGame
//
//  Created by Andrew Groeneveldt on 2017-10-22.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import Foundation
import SpriteKit


/// Shape objects, such as the triangle and square, used for gameplay. 
class Shape: GameObject {
    
    // MARK: Properties
    
    var zoneSize: CGSize
    var inZone: Zone        // TO SAVE
    var pointValue = 0      // TO SAVE - MAYBE NOT AS SET FROM UPGRADELEVELA IN INIT
    var bonusValue = 0      // TO SAVE
    var upgradeALevel = 0   // TO SAVE
    var upgradeBLevel = 0   // TO SAVE
    var upgradeCLevel = 0   // TO SAVE
    var pointsLabel = SKLabelNode(fontNamed: "PingFangSC-Light")    // for upgradeA
    var border: SKShapeNode?                                        // for upgradeB
    let borderLineWidth: CGFloat = 8
    
    
    // MARK: Initializers
    
    
    init(type: ObjectType, at: CGPoint, zoneSize: CGSize, inZone: Zone, pointValue: Int? = nil, bonusValue: Int? = nil, upgradeALevel: Int? = nil, upgradeBLevel: Int? = nil, upgradeCLevel: Int? = nil, restitution: CGFloat? = nil, linearDampening: CGFloat? = nil) {
        
        self.inZone = inZone
        self.zoneSize = zoneSize
        
        super.init(type: type, at: at, zoneSize: zoneSize)
        
        // Get saved values
        if let pV = pointValue { self.pointValue = pV }
        if let bV = bonusValue { self.bonusValue = bV }
        if let uAL = upgradeALevel { self.upgradeALevel = uAL }
        if let uBL = upgradeBLevel { self.upgradeBLevel = uBL }
        if let uCL = upgradeCLevel { self.upgradeCLevel = uCL }
        
        if let r = restitution {
            self.physicsBody?.restitution = r
        } else {
            self.physicsBody?.restitution = 0.2
        }
        if let lD = linearDampening {
            self.physicsBody?.linearDamping = lD
        } else {
            self.physicsBody?.linearDamping = 0.8
        }
        
        self.pointValue = objectType.getPoints(self.upgradeALevel)
        
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = true
        self.physicsBody?.angularDamping = 0.5
        self.physicsBody?.friction = 0.5
        self.physicsBody?.mass = 1
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.categoryBitMask = 1
        self.physicsBody?.contactTestBitMask = 1|2|4|8
        self.physicsBody?.collisionBitMask = 1|2|4
        
        let rangeX = SKRange(lowerLimit: (dimension/2)-5, upperLimit: (zoneSize.width-(dimension/2)+5))
        let rangeY = SKRange(lowerLimit: (dimension/2)-5, upperLimit: (zoneSize.height-(dimension/2)+5))
        let rangeD = SKRange(upperLimit: zoneSize.width * 0.6) // Need to tweak value still!!!!
        let conX = SKConstraint.positionX(rangeX)
        let conY = SKConstraint.positionY(rangeY)
        let conD = SKConstraint.distance(rangeD, to: CGPoint(x: zoneSize.width * 0.5, y: zoneSize.width * 0.5), in: inZone)
        self.constraints = [conX,conY,conD]

        
        // Setup points label
        pointsLabel.text = String(self.pointValue)
        pointsLabel.fontSize = 75
        pointsLabel.fontColor = UIColor.white
        pointsLabel.horizontalAlignmentMode = .center
        pointsLabel.verticalAlignmentMode = .top
        self.addChild(pointsLabel)
        
        setupShapeBorder()
        
        self.color = SKColor.black      // set so it can be blended into (to make darker) for upgradeC
        self.colorBlendFactor = 0
        
        drawUpgradeB()
        drawUpgradeC()
    }
    
    
    // MARK: Functions
    
    
    // get images for shape upgraded to next level to display as upgrade button
    func nextUpgradeANode() -> UIImage {
        if (!self.canUpgradeA()) {
            return self.objectType.getImage()!
        }
        let sh = softCopy()
        sh.upgradeALevel += 1;
        sh.pointValue = sh.objectType.getPoints(sh.upgradeALevel)
        sh.updatePointsLabel()
        sh.drawUpgradeB()
        sh.drawUpgradeC()
        let cg = scene?.view?.texture(from: sh)?.cgImage()
        if (cg != nil) {
            return UIImage(cgImage: cg!)
        }
        else{
            return self.objectType.getImage()!
        }
    }
    
    func nextUpgradeBNode() -> UIImage {
        if (!self.canUpgradeB()) {
            return self.objectType.getImage()!
        }
        let sh = softCopy()
        
        sh.upgradeBLevel += 1;
        sh.pointValue = sh.objectType.getPoints(sh.upgradeALevel)
        sh.updatePointsLabel()
        sh.drawUpgradeB()
        sh.drawUpgradeC()
        let cg = scene?.view?.texture(from: sh)?.cgImage()
        if (cg != nil) {
            return UIImage(cgImage: cg!)
        }
        else{
            return self.objectType.getImage()!
        }
    }
    
    func nextUpgradeCNode() -> UIImage {
        if (!self.canUpgradeC()) {
            return self.objectType.getImage()!
        }
        let sh = softCopy()
        sh.upgradeCLevel += 1;
        sh.pointValue = sh.objectType.getPoints(sh.upgradeALevel)
        sh.updatePointsLabel()
        sh.drawUpgradeB()
        sh.drawUpgradeC()
        let cg = scene?.view?.texture(from: sh)?.cgImage()
        if (cg != nil) {
            return UIImage(cgImage: cg!)
        }
        else{
            return self.objectType.getImage()!
        }
    }
    
    
    func softCopy() -> Shape {
        let sh = Shape(type: self.objectType, at: CGPoint(), zoneSize: self.zoneSize, inZone: self.inZone);
        sh.upgradeALevel = self.upgradeALevel;
        sh.upgradeBLevel = self.upgradeBLevel;
        sh.upgradeCLevel = self.upgradeCLevel;
        return sh;
    }
    
    
    func getPoints() -> Int {
        return pointValue + bonusValue
    }
    
    
    func updatePointsLabel()
    {
        pointsLabel.text = String(pointValue)
    }
    
    
    // play a breif animation on shapes when they collide
    func animateCollision() {
        removeAction(forKey: "pulse")
        let pulseIn = SKAction.scale(to: CGSize(width: dimension*0.5, height: dimension*0.5), duration: 0.05)
        let pulseOut = SKAction.scale(to: CGSize(width: dimension, height: dimension), duration: 0.05)
        let pulse = SKAction.sequence([pulseIn,pulseOut])
        run(pulse, withKey: "pulse")
    }
    
    
    // Called from ShopCollectionView to show which shape has upgrade focus.
    // TODO: Maybe make the focus a separate border around the shape, away from the main border
    func focus() {
        // Put in place a temp border if the shape has no upgradeB
        if(border?.lineWidth == 0) { border?.lineWidth = borderLineWidth }

        border?.strokeColor = UIColor.yellow
    }
    
    
    // Undoes shape upgrade focus.
    func unfocus() {
        if(self.upgradeBLevel == 0) { border?.lineWidth = 0 }
        else { border?.lineWidth = borderLineWidth }
        
        border?.strokeColor = UIColor.white
    }
    
    
    // MARK: Upgrade Methods
    
    
    // get the next upgrade price
    func upgradePriceA() -> Int {
        guard canUpgradeA() else {return -1}
        return objectType.getUpgradePriceA(upgradeALevel)
    }
    
    func upgradePriceB() -> Int {
        guard canUpgradeB() else {return -1}
        return objectType.getUpgradePriceB(upgradeBLevel)
    }
    
    func upgradePriceC() -> Int {
        guard canUpgradeC() else {return -1}
        return objectType.getUpgradePriceC(upgradeCLevel)
    }
    
    
    // returns if another upgrade level is available
    func canUpgradeA() -> Bool {
        return upgradeALevel < 9
    }
    
    func canUpgradeB() -> Bool {
        return upgradeBLevel < 5
    }
    
    func canUpgradeC() -> Bool {
        return upgradeCLevel < 5
    }
    
    // plays a brief burst effect when a shape is upgraded
    func animateUpgrade() {
        let emitter = SKEmitterNode(fileNamed: "MyParticle.sks")
        emitter?.particleTexture = self.texture
        emitter?.numParticlesToEmit = 30
        emitter?.particleLifetime = 0.4
        emitter?.particleSpeed = 1000
        emitter?.emissionAngleRange = CGFloat.pi/2
        emitter?.emissionAngleRange = 2*CGFloat.pi
        emitter?.position = CGPoint(x: size.width/2, y: size.height/2)
        emitter?.particleSize = CGSize(width:100, height: 100)
        let addEmitter = SKAction.run({
            self.addChild(emitter!)
        })
        let wait = SKAction.wait(forDuration: 1)
        let remove = SKAction.run({
            emitter?.removeFromParent()
        })
        let celebrate = SKAction.sequence([addEmitter,wait,remove])
        self.run(celebrate)
    }
    
    // Do upgradeA
    func upgradeA() {
        guard canUpgradeA() else {return}
        inZone.pIG.feed(portion: objectType.getPigRateA(upgradeALevel))
        upgradeALevel += 1
        pointValue = objectType.getPoints(upgradeALevel)
        updatePointsLabel()
        animateUpgrade()
    }
    
    
    // Do upgradeB
    func upgradeB() {
        guard canUpgradeB() else {return}
        inZone.pIG.feed(portion: objectType.getPigRateB(upgradeBLevel))
        upgradeBLevel += 1
        self.physicsBody?.restitution += 0.15
        drawUpgradeB()
        animateUpgrade()
    }
    
    
    // Do upgradeC
    func upgradeC() {
        guard canUpgradeC() else {return}
        inZone.pIG.feed(portion: objectType.getPigRateC(upgradeCLevel))
        upgradeCLevel += 1
        self.physicsBody?.linearDamping -= 0.15
        drawUpgradeC()
        animateUpgrade()
    }
    
    
    // Draw in shape border for bounce upgrade.
    func drawUpgradeB()
    {
        if(self.upgradeBLevel == 1){
            border?.lineWidth = 6
        }
        else{
            border?.glowWidth = CGFloat(self.upgradeBLevel * 3)
        }
    }
    
    
    // Darkens color of shape for reduced friction upgrade.
    func drawUpgradeC()
    {
        self.colorBlendFactor = CGFloat(self.upgradeCLevel)*0.1
    }
    
    
    // Draws an SKShapeNode border around the given shape.
    // Relevant for upgradeB.
    func setupShapeBorder()
    {
        var points: [CGPoint]
        switch self.getType() {
        case .Triangle:
            points = [
                CGPoint(x: 0, y: self.size.height * 2),                           // top
                CGPoint(x: -self.size.width * 2.4, y: -self.size.height * 2),     // bottom-left
                CGPoint(x: self.size.width * 2.4, y: -self.size.height * 2),      // bottom-right
                CGPoint(x: 0, y: self.size.height * 2)                            // back to top
            ]
            border = SKShapeNode(points: &points, count: points.count)
            
        case .Square:
            points = [
                CGPoint(x: -self.size.width * 2.4, y: self.size.height * 2.4),      // top-left
                CGPoint(x: -self.size.width * 2.4, y: -self.size.height * 2.4),     // bottom-left
                CGPoint(x: self.size.width * 2.4, y: -self.size.height * 2.4),      // bottom-right
                CGPoint(x: self.size.width * 2.4, y: self.size.height * 2.4),       // top-right
                CGPoint(x: -self.size.width * 2.4, y: self.size.height * 2.4)       // back to top-left
            ]
            border = SKShapeNode(points: &points, count: points.count)
            
        case .Pentagon:
            points = [
                CGPoint(x: 0, y: self.size.height * 2.2),                           // top
                CGPoint(x: -self.size.width * 2.2, y: self.size.height * 0.5),      // left
                CGPoint(x: -self.size.width * 1.4, y: -self.size.height * 2.2),     // bottom-left
                CGPoint(x: self.size.width * 1.4, y: -self.size.height * 2.2),      // bottom-right
                CGPoint(x: self.size.width * 2.2, y: self.size.height * 0.5),       // right
                CGPoint(x: 0, y: self.size.height * 2.2)                            // back to top
            ]
            border = SKShapeNode(points: &points, count: points.count)
            
        case .Hexagon:
            points = [
                CGPoint(x: -self.size.width * 1.2, y: self.size.height * 2),    // top-left
                CGPoint(x: -self.size.width * 2.2, y: 0),                       // left
                CGPoint(x: -self.size.width * 1.2, y: -self.size.height * 2),   // bottom-left
                CGPoint(x: self.size.width * 1.2, y: -self.size.height * 2),    // bottom-right
                CGPoint(x: self.size.width * 2.2, y: 0),                        // right
                CGPoint(x: self.size.width * 1.2, y: self.size.height * 2),     // top-right
                CGPoint(x: -self.size.width * 1.2, y: self.size.height * 2)     // back to top-left
            ]
            border = SKShapeNode(points: &points, count: points.count)
            
        case .Octagon:
            points = [
                CGPoint(x: -self.size.width, y: self.size.height * 2.5),   // top-left
                CGPoint(x: -self.size.width * 2.5, y: self.size.height),     // left-up
                CGPoint(x: -self.size.width * 2.5, y: -self.size.height),    // left-down
                CGPoint(x: -self.size.width, y: -self.size.height * 2.5),      // bottom-left
                CGPoint(x: self.size.width, y: -self.size.height * 2.5),       // bottom-right
                CGPoint(x: self.size.width * 2.5, y: -self.size.height),     // right-down
                CGPoint(x: self.size.width * 2.5, y: self.size.height),      // right-up
                CGPoint(x: self.size.width, y: self.size.height * 2.5),        // top-right
                CGPoint(x: -self.size.width, y: self.size.height * 2.5)        // back to top-left
            ]
            border = SKShapeNode(points: &points, count: points.count)
            
        case .Circle:
            border = SKShapeNode(circleOfRadius: self.size.width * 2.5)
            
        default:
            return
        }
        border?.lineWidth = 0       // set this higher when one upgrade has been done
        border?.lineCap = CGLineCap.round
        border?.lineJoin = CGLineJoin.round
        addChild(border!)
    }
    
    
    // MARK: NSCoding

    
    /// Keys used to reference the properties in memory
    struct PropertyKey {
        static let objectType = "objectType"
        static let lastPosition = "lastPosition"
        static let pointsValue = "pointsValue"
        static let bonusValue = "bonusValue"
        static let upgradeALevel = "upgradeALevel"
        static let upgradeBLevel = "upgradeBLevel"
        static let upgradeCLevel = "upgradeCLevel"
        static let restitution = "restitution"
        static let linearDampening = "linearDampening"
        static let zone = "zone"
        static let zoneSize = "zoneSize"
    }
    
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        try? (aCoder as! NSKeyedArchiver).encodeEncodable(objectType, forKey: PropertyKey.objectType)
        aCoder.encode(self.position, forKey: PropertyKey.lastPosition)
        aCoder.encode(self.pointValue, forKey: PropertyKey.pointsValue)
        aCoder.encode(self.bonusValue, forKey: PropertyKey.bonusValue)
        aCoder.encode(self.upgradeALevel, forKey: PropertyKey.upgradeALevel)
        aCoder.encode(self.upgradeBLevel, forKey: PropertyKey.upgradeBLevel)
        aCoder.encode(self.upgradeCLevel, forKey: PropertyKey.upgradeCLevel)
        aCoder.encode(self.physicsBody?.restitution, forKey: PropertyKey.restitution)
        aCoder.encode(self.physicsBody?.linearDamping, forKey: PropertyKey.linearDampening)
        aCoder.encode(self.inZone, forKey: PropertyKey.zone)
        aCoder.encode(self.zoneSize, forKey: PropertyKey.zoneSize)
    }
    
    
    required convenience init?(coder aDecoder: NSCoder) {        
        let loadedObjectType = (aDecoder as! NSKeyedUnarchiver).decodeDecodable(ObjectType.self, forKey: PropertyKey.objectType)
        let loadedLastPosition = aDecoder.decodeCGPoint(forKey: PropertyKey.lastPosition)
        let loadedPointValue = aDecoder.decodeInteger(forKey: PropertyKey.pointsValue)
        let loadedBonusValue = aDecoder.decodeInteger(forKey: PropertyKey.bonusValue)
        let loadedUpgradeALevel = aDecoder.decodeInteger(forKey: PropertyKey.upgradeALevel)
        let loadedUpgradeBLevel = aDecoder.decodeInteger(forKey: PropertyKey.upgradeBLevel)
        let loadedUpgradeCLevel = aDecoder.decodeInteger(forKey: PropertyKey.upgradeCLevel)
        let loadedRestitution = aDecoder.decodeObject(forKey: PropertyKey.restitution) as! CGFloat
        let loadedLinearDampening = aDecoder.decodeObject(forKey: PropertyKey.linearDampening) as! CGFloat
        let loadedZone = aDecoder.decodeObject(forKey: PropertyKey.zone) as! Zone
        let loadedSize = aDecoder.decodeCGSize(forKey: PropertyKey.zoneSize)
        
        self.init(type: loadedObjectType!, at: loadedLastPosition, zoneSize: loadedSize, inZone: loadedZone, pointValue: loadedPointValue, bonusValue: loadedBonusValue, upgradeALevel: loadedUpgradeALevel, upgradeBLevel: loadedUpgradeBLevel, upgradeCLevel: loadedUpgradeCLevel, restitution: loadedRestitution, linearDampening: loadedLinearDampening)
    }
}
