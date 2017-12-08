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
    
    //var emitter = SKEmitterNode(fileNamed: "MyParticle.sks")
    //var withSize: CGSize // REFACTOR: Might need to remove
    var inZone: Zone
    var pointValue = 0
    var bonusValue = 0
    var upgradeALevel = 0
    var upgradeBLevel = 0
    var upgradeCLevel = 0
    var pointsLabel = SKLabelNode(fontNamed: "PingFangSC-Light")    // for upgradeA
    var border: SKShapeNode?                                        // for upgradeB
    let borderLineWidth: CGFloat = 8
    
    
    // MARK: Initializers
    
    
    override init(type: ObjectType, at: CGPoint, inZone: Zone) {
        self.inZone = inZone
        
        super.init(type: type, at: at, inZone: inZone)
        //super.setUp(at: at, withSize: withSize)
        
        self.pointValue = objectType.getPoints(upgradeALevel)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = true
        self.physicsBody?.restitution = 0.2
        self.physicsBody?.angularDamping = 0.5
        self.physicsBody?.friction = 0.5
        self.physicsBody?.linearDamping = 0.8
        self.physicsBody?.mass = 1
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.categoryBitMask = 1
        self.physicsBody?.contactTestBitMask = 1|2|4|8
        self.physicsBody?.collisionBitMask = 1|2|4
        let rangeX = SKRange(lowerLimit: (dimension/2)-5, upperLimit: (inZone.size.width-(dimension/2)+5))
        let rangeY = SKRange(lowerLimit: (dimension/2)-5, upperLimit: (inZone.size.height-(dimension/2)+5))
        let rangeD = SKRange(upperLimit: inZone.size.width * 0.6) // Need to tweak value still!!!!
        let conX = SKConstraint.positionX(rangeX)
        let conY = SKConstraint.positionY(rangeY)
        let conD = SKConstraint.distance(rangeD, to: CGPoint(x: inZone.size.width * 0.5, y: inZone.size.width * 0.5), in: inZone)
        self.constraints = [conX,conY,conD]

        //emitter?.particleTexture = SKTexture(image: self.getType().getImage()!)
        //emitter?.numParticlesToEmit = 10
        //emitter?.particleLifetime = 0.25
        //emitter?.position = CGPoint(x:self. , y:self.size.height/2)
        //emitter?.particleSize = CGSize(width: 40, height: 40)
        //emitter?.targetNode = inZone
        //self.addChild(emitter!)
        
        // Setup points label
        pointsLabel.text = String(pointValue)
        pointsLabel.fontSize = 75
        pointsLabel.fontColor = UIColor.white
        pointsLabel.horizontalAlignmentMode = .center
        pointsLabel.verticalAlignmentMode = .top
        self.addChild(pointsLabel)
        
        setupShapeBorder()
        
        self.color = SKColor.black      // set so it can be blended into (to make darker) for upgradeC
        self.colorBlendFactor = 0
    }
    
    
    // MARK: Functions
    
    
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
        var cg = scene?.view?.texture(from: sh)?.cgImage()
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
        var cg = scene?.view?.texture(from: sh)?.cgImage()
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
        var cg = scene?.view?.texture(from: sh)?.cgImage()
        if (cg != nil) {
            return UIImage(cgImage: cg!)
        }
        else{
            return self.objectType.getImage()!
        }
    }
    
    
    func softCopy() -> Shape {
        let sh = Shape(type: self.objectType, at: CGPoint(), inZone: self.inZone);
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
    
    
    /// Animates the collision after being passed an emitter node by setting the proper duration,
    /// adding a child node and then letting the animation play before removing itself
    ///
    /// - Parameter collisionEmitter: The SKEmitterNode that contains the settings for the animation.
    func animateCollision() {
        // Set up a sequence animation which deletes its node after completion.
        //let duration = Double((emitter?.particleLifetime)!*CGFloat((emitter?.numParticlesToEmit)!))
        //emitter?.resetSimulation()
        //emitter?.advanceSimulationTime(duration)
        removeAction(forKey: "pulse")
        let pulseIn = SKAction.scale(to: CGSize(width: dimension*0.5, height: dimension*0.5), duration: 0.05)
        let pulseOut = SKAction.scale(to: CGSize(width: dimension, height: dimension), duration: 0.05)
        let pulse = SKAction.sequence([pulseIn,pulseOut])
        run(pulse, withKey: "pulse")
    }
    
    
    // Called from ShopCollectionView to show which shape has upgrade focus.
    // TODO: Maybe make the focus a separate border around the shape, away from the main border?
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
    
    
    func canUpgradeA() -> Bool {
        return upgradeALevel < 9
    }
    
    
    func canUpgradeB() -> Bool {
        return upgradeBLevel < 5
    }
    
    
    func canUpgradeC() -> Bool {
        return upgradeCLevel < 5
    }
    
    
    // Do upgradeA
    func upgradeA() {
        guard canUpgradeA() else {return}
        inZone.pIG.feed(portion: objectType.getPigRateA(upgradeALevel))
        upgradeALevel += 1
        pointValue = objectType.getPoints(upgradeALevel)
        updatePointsLabel()
    }
    
    
    // Do upgradeB
    func upgradeB() {
        guard canUpgradeB() else {return}
        inZone.pIG.feed(portion: objectType.getPigRateB(upgradeBLevel))
        upgradeBLevel += 1
        self.physicsBody?.restitution += 0.15
        drawUpgradeB()
    }
    
    
    // Do upgradeC
    func upgradeC() {
        guard canUpgradeC() else {return}
        inZone.pIG.feed(portion: objectType.getPigRateC(upgradeCLevel))
        upgradeCLevel += 1
        self.physicsBody?.linearDamping -= 0.15
        drawUpgradeC()
    }
    
    
    // Draw in shape border for bounce upgrade.
    func drawUpgradeB()
    {
        if(self.upgradeBLevel == 1){
            border?.lineWidth = 6
        }
        else{
            border?.glowWidth += CGFloat(self.upgradeBLevel * 3)
        }
    }
    
    
    // Darkens color of shape for reduced friction upgrade.
    func drawUpgradeC()
    {
        // @Austin, changed this from += 0.1 to variable dependent on upgradeCLevel :)
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
                CGPoint(x: 0, y: self.size.height * 2.2),                             // top
                CGPoint(x: -self.size.width * 2.2, y: self.size.height * 0.5),                           // left
                CGPoint(x: -self.size.width * 1.4, y: -self.size.height * 2.2),     // bottom-left
                CGPoint(x: self.size.width * 1.4, y: -self.size.height * 2.2),      // bottom-right
                CGPoint(x: self.size.width * 2.2, y: self.size.height * 0.5),                            // right
                CGPoint(x: 0, y: self.size.height * 2.2)                              // back to top
            ]
            border = SKShapeNode(points: &points, count: points.count)
            
        case .Hexagon:
            points = [
                CGPoint(x: -self.size.width * 1.2, y: self.size.height * 2),    // top-left
                CGPoint(x: -self.size.width * 2.2, y: 0),                          // left
                CGPoint(x: -self.size.width * 1.2, y: -self.size.height * 2),   // bottom-left
                CGPoint(x: self.size.width * 1.2, y: -self.size.height * 2),    // bottom-right
                CGPoint(x: self.size.width * 2.2, y: 0),                          // right
                CGPoint(x: self.size.width * 1.2, y: self.size.height * 2),    // top-right
                CGPoint(x: -self.size.width * 1.2, y: self.size.height * 2),    // back to top-left
            ]
            border = SKShapeNode(points: &points, count: points.count)
            
            //case .Octagon:
            //shape = drawOctagon()
            
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
        static let zone = "zone"
    }
    
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        try? (aCoder as! NSKeyedArchiver).encodeEncodable(objectType, forKey: PropertyKey.objectType)
        aCoder.encode(self.position, forKey: PropertyKey.lastPosition)
        aCoder.encode(self.inZone, forKey: PropertyKey.zone)
    }
    
    
    required convenience init?(coder aDecoder: NSCoder) {
        let objectType = (aDecoder as! NSKeyedUnarchiver).decodeDecodable(ObjectType.self, forKey: PropertyKey.objectType)
        let lastPosition = aDecoder.decodeCGPoint(forKey: PropertyKey.lastPosition)
        let zone = aDecoder.decodeObject(forKey: PropertyKey.zone) as! Zone
        
        self.init(type: objectType!, at: lastPosition, inZone: zone)
    }
}
