//
//  Fixture.swift
//  IncrementalGame
//
//  Created by Andrew Groeneveldt on 2017-10-22.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import Foundation
import SpriteKit

/// Fixtures, such as the vortex, used in gameplay.
class Fixture: GameObject {
    
    // MARK: Properties
    
    var zoneSize: CGSize    // TO SAVE
    var inZone: Zone        // TO SAVE
    var upgradeLevel = 0    // TO SAVE
    var border: SKShapeNode?
    let borderLineWidth: CGFloat = 20
    
    
    // MARK: Initializers
    
    
    init(type: ObjectType, at: CGPoint, inZone: Zone, zoneSize: CGSize, upgradeLevel: Int? = nil, strength: Float? = nil, bonusAreaAlpha: CGFloat? = nil) {
        
        self.inZone = inZone
        self.zoneSize = zoneSize
        
        // Load optional values
        if upgradeLevel != nil { self.upgradeLevel = upgradeLevel! }
        
        super.init(type: type, at: at, zoneSize: zoneSize)
        
        self.physicsBody?.categoryBitMask = 4
        self.physicsBody?.contactTestBitMask = 1
        self.physicsBody?.collisionBitMask = 1
        
        // settings specific to each type of fixture
        switch objectType {
            case .Bonus:
                self.physicsBody = SKPhysicsBody(circleOfRadius: dimension*2)
                let sizing = (objectType.getImage()?.size.width)!
                let bonusArea = SKShapeNode(circleOfRadius: sizing)
                bonusArea.setScale(2)
                bonusArea.fillColor = .green
                
                if let bAA = bonusAreaAlpha {
                    bonusArea.alpha = bAA
                } else {
                    bonusArea.alpha = 0.05
                }
                
                self.addChild(bonusArea)
                self.physicsBody?.categoryBitMask = 8
                self.physicsBody?.collisionBitMask = 0
            case .Graviton:
                let grav = SKFieldNode.radialGravityField()
                grav.categoryBitMask = 1
                grav.isEnabled = true
                
                if let s = strength {
                    grav.strength = s
                } else {
                    grav.strength = 35
                }
                
                grav.isExclusive = false
                grav.falloff = 0.7
                self.addChild(grav)
            case .Vortex:
                let vort = SKFieldNode.vortexField()
                vort.categoryBitMask = 1
                vort.isEnabled = true
                
                if let s = strength {
                    vort.strength = s
                } else {
                    vort.strength = 10
                }
                
                vort.isExclusive = false
                self.addChild(vort)
            default:
                return
        }
        
        self.physicsBody?.isDynamic = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.usesPreciseCollisionDetection = true
        let rangeX = SKRange(lowerLimit: (dimension*2), upperLimit: (zoneSize.width-(dimension*2)))
        let rangeY = SKRange(lowerLimit: (dimension*2), upperLimit: (zoneSize.height-(dimension*2)))
        let conX = SKConstraint.positionX(rangeX)
        let conY = SKConstraint.positionY(rangeY)
        self.constraints = [conX,conY]
        
        //TODO: Probably implement a separate border for highlighting. Do this for shape, but for fixtures, this will be the only border.
        // Setup border for highlighting upgrade focus (only used for such for Fixtures).
        border = SKShapeNode(circleOfRadius: self.size.width * 20)
        border?.lineWidth = borderLineWidth * 3
        border?.strokeColor = UIColor.yellow
        addChild(border!)
    }
    
    
    // MARK: Functions
    
    
    func focus() {
        border?.lineWidth = borderLineWidth
    }
    
    
    func unfocus() {
        border?.lineWidth = 0
    }
    
    // return price of next upgrade
    func upgradePrice() -> Int {
        guard canUpgrade() else {return -1}
        return objectType.getUpgradePriceFix(upgradeLevel)
    }
    
    // return availability of next upgrade
    func canUpgrade() -> Bool {
        return upgradeLevel < 5
    }
    
    // perform an upgrade
    func upgrade() {
        guard canUpgrade() else {return}
        inZone.pIG.feed(portion: objectType.getPigRateFix(upgradeLevel))
        upgradeLevel += 1
        switch objectType {
        case .Graviton, .Vortex:
            if let force = self.children[0] as? SKFieldNode {
                force.strength *= 1.25
            }
        case .Bonus:
            if let bonusArea = self.children[0] as? SKShapeNode {
                bonusArea.alpha += 0.05
            }
        default:
            return
        }
    }
    
    
    // MARK: NSCoding

    
    /// Keys used to reference the properties in memory
    struct PropertyKey {
        static let objectType = "objectType"
        static let lastPosition = "lastPosition"
        static let upgradeLevel = "upgradeLevel"
        static let strength = "strength"
        static let bonusAreaAlpha = "bonusAreaAlpha"
        static let zone = "zone"
        static let zoneSize = "zoneSize"
    }
    
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        try? (aCoder as! NSKeyedArchiver).encodeEncodable(objectType, forKey: PropertyKey.objectType)
        aCoder.encode(self.position, forKey: PropertyKey.lastPosition)
        aCoder.encode(self.upgradeLevel, forKey: PropertyKey.upgradeLevel)
        aCoder.encode(self.inZone, forKey: PropertyKey.zone)
        aCoder.encode(self.zoneSize, forKey: PropertyKey.zoneSize)
        switch objectType {
            case .Graviton, .Vortex:
                if let force = self.children[0] as? SKFieldNode {
                    aCoder.encode(force.strength, forKey: PropertyKey.strength)
                }
            case .Bonus:
                if let bonusArea = self.children[0] as? SKShapeNode {
                    aCoder.encode(bonusArea.alpha, forKey: PropertyKey.bonusAreaAlpha)
                }
            default:
                break
        }
    }
    
    
    required convenience init?(coder aDecoder: NSCoder) {
        let loadedObjectType = (aDecoder as! NSKeyedUnarchiver).decodeDecodable(ObjectType.self, forKey: PropertyKey.objectType)
        var loadedStrength: Float? = nil
        var loadedBonusAreaAlpha: CGFloat? = nil
        switch loadedObjectType! {
            case .Graviton, .Vortex:
                loadedStrength = aDecoder.decodeFloat(forKey: PropertyKey.strength)
            case .Bonus:
                loadedBonusAreaAlpha = aDecoder.decodeObject(forKey: PropertyKey.bonusAreaAlpha) as? CGFloat
            default:
                break
        }
        let loadedLastPosition = aDecoder.decodeCGPoint(forKey: PropertyKey.lastPosition)
        let loadedZone = aDecoder.decodeObject(forKey: PropertyKey.zone) as! Zone
        let loadedZoneSize = aDecoder.decodeCGSize(forKey: PropertyKey.zoneSize)
        let loadedUpgradeLevel = aDecoder.decodeInteger(forKey: PropertyKey.upgradeLevel)
        
        self.init(type: loadedObjectType!, at: loadedLastPosition, inZone: loadedZone, zoneSize: loadedZoneSize, upgradeLevel: loadedUpgradeLevel, strength: loadedStrength, bonusAreaAlpha: loadedBonusAreaAlpha)
    }
}
