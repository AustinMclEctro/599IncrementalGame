//
//  ObjectType.swift
//  IncrementalGame
//
//  Created by Ben Grande on 2017-10-05.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import UIKit
import SpriteKit


/// An enumeration containing all the possible objects that can be used
/// used within the play area.
enum ObjectType: String, Codable {
    
    case Triangle
    case Square
    case Pentagon
    case Hexagon
    case Octagon
    case Circle
    case Bumper
    case Graviton
    case Vortex
    
    struct triangle {
        static let points = [3,4,5,6,7,8,9,10,11,12]
        static let price = 100
        static let pigRateNew = 1
        static let upgradePriceA = [3,4,5,6,7,8,9,10,11]
        static let pigRateA = [3,4,5,6,7,8,9,10,11]
        static let upgradePriceB = [3,4,5,6,7]
        static let pigRateB = [3,4,5,6,7]
        static let upgradePriceC = [3,4,5,6,7]
        static let pigRateC = [3,4,5,6,7]
    }
    
    struct square {
        static let points = [3,4,5,6,7,8,9,10,11,12]
        static let price = 100
        static let pigRateNew = 1
        static let upgradePriceA = [3,4,5,6,7,8,9,10,11]
        static let pigRateA = [3,4,5,6,7,8,9,10,11]
        static let upgradePriceB = [3,4,5,6,7]
        static let pigRateB = [3,4,5,6,7]
        static let upgradePriceC = [3,4,5,6,7]
        static let pigRateC = [3,4,5,6,7]
    }
    
    struct pentagon {
        static let points = [3,4,5,6,7,8,9,10,11,12]
        static let price = 100
        static let pigRateNew = 1
        static let upgradePriceA = [3,4,5,6,7,8,9,10,11]
        static let pigRateA = [3,4,5,6,7,8,9,10,11]
        static let upgradePriceB = [3,4,5,6,7]
        static let pigRateB = [3,4,5,6,7]
        static let upgradePriceC = [3,4,5,6,7]
        static let pigRateC = [3,4,5,6,7]
    }
    
    struct hexagon {
        static let points = [3,4,5,6,7,8,9,10,11,12]
        static let price = 100
        static let pigRateNew = 1
        static let upgradePriceA = [3,4,5,6,7,8,9,10,11]
        static let pigRateA = [3,4,5,6,7,8,9,10,11]
        static let upgradePriceB = [3,4,5,6,7]
        static let pigRateB = [3,4,5,6,7]
        static let upgradePriceC = [3,4,5,6,7]
        static let pigRateC = [3,4,5,6,7]
    }
    
    struct octagon {
        static let points = [3,4,5,6,7,8,9,10,11,12]
        static let price = 100
        static let pigRateNew = 1
        static let upgradePriceA = [3,4,5,6,7,8,9,10,11]
        static let pigRateA = [3,4,5,6,7,8,9,10,11]
        static let upgradePriceB = [3,4,5,6,7]
        static let pigRateB = [3,4,5,6,7]
        static let upgradePriceC = [3,4,5,6,7]
        static let pigRateC = [3,4,5,6,7]
    }
    
    struct circle {
        static let points = [3,4,5,6,7,8,9,10,11,12]
        static let price = 100
        static let pigRateNew = 1
        static let upgradePriceA = [3,4,5,6,7,8,9,10,11]
        static let pigRateA = [3,4,5,6,7,8,9,10,11]
        static let upgradePriceB = [3,4,5,6,7]
        static let pigRateB = [3,4,5,6,7]
        static let upgradePriceC = [3,4,5,6,7]
        static let pigRateC = [3,4,5,6,7]
    }
    
    struct bumper {
        static let price = 700
        static let pigRateNew = 7
        static let upgradePriceFix = [3,4,5,6,7]
        static let pigRateFix = [3,4,5,6,7]
    }
    
    struct graviton {
        static let price = 700
        static let pigRateNew = 7
        static let upgradePriceFix = [3,4,5,6,7]
        static let pigRateFix = [3,4,5,6,7]
    }
    
    struct vortex {
        static let price = 700
        static let pigRateNew = 7
        static let upgradePriceFix = [3,4,5,6,7]
        static let pigRateFix = [3,4,5,6,7]
    }
    
    
    /// Retrieves the type for the ObjectType (fixture or shape).
    ///
    /// - Returns: true if fixture.
    func isFixture() -> Bool {
        let fixtures: [ObjectType] = [.Bumper, .Graviton, .Vortex]
        return fixtures.index(of: self) != nil;
    }
    
    /// Retrieves the image for the ObjectType.
    ///
    /// - Returns: A UIImage object for the ObjectType.
    func getImage() -> UIImage? {
        return UIImage(named: String(describing: self))
    }
    
    func getUnlockPrice() -> Int { // don't need under new mechanics?
        switch self {
        case .Triangle:
            return 1000
        case .Square:
            return 2000
        case .Pentagon:
            return 3000
        case .Hexagon:
            return 4000
        case .Octagon:
            return 5001
        case .Circle:
            return 6000
        case .Bumper:
            return 10000
        case .Graviton:
            return 20000
        case .Vortex:
            return 30000
        default:
            return 0
        }
    }
    /// Retrieves the price for the ObjectType.
    ///
    /// - Returns: The price for the ObjectType.
    func getPrice() -> Int {
        switch self {
        case .Triangle:
            return triangle.price
        case .Square:
            return square.price
        case .Pentagon:
            return pentagon.price
        case .Hexagon:
            return hexagon.price
        case .Octagon:
            return octagon.price
        case .Circle:
            return circle.price
        case .Bumper:
            return bumper.price
        case .Graviton:
            return graviton.price
        case .Vortex:
            return vortex.price
        default:
            return 0
        }
    }
    
    func getPigRateNew() -> Int {
        switch self {
        case .Triangle:
            return triangle.pigRateNew
        case .Square:
            return square.pigRateNew
        case .Pentagon:
            return pentagon.pigRateNew
        case .Hexagon:
            return hexagon.pigRateNew
        case .Octagon:
            return octagon.pigRateNew
        case .Circle:
            return circle.pigRateNew
        case .Bumper:
            return bumper.pigRateNew
        case .Graviton:
            return graviton.pigRateNew
        case .Vortex:
            return vortex.pigRateNew
        default:
            return 0
        }
    }
    
    
    /// Gets the point value for the ObjectType.
    ///
    /// - Returns: The points earned on each collision for the ObjectType.
    func getPoints(_ level: Int) -> Int {
        switch self {
        case .Triangle:
            return triangle.points[level]
        case .Square:
            return square.points[level]
        case .Pentagon:
            return pentagon.points[level]
        case .Hexagon:
            return hexagon.points[level]
        case .Octagon:
            return octagon.points[level]
        case .Circle:
            return circle.points[level]
        default:
            return 0
        }
    }
    
    func getUpgradePriceA(_ level: Int) -> Int {
        switch self {
        case .Triangle:
            return triangle.upgradePriceA[level]
        case .Square:
            return square.upgradePriceA[level]
        case .Pentagon:
            return pentagon.upgradePriceA[level]
        case .Hexagon:
            return hexagon.upgradePriceA[level]
        case .Octagon:
            return octagon.upgradePriceA[level]
        case .Circle:
            return circle.upgradePriceA[level]
        default:
            return 0
        }
    }
    
    func getUpgradePriceB(_ level: Int) -> Int {
        switch self {
        case .Triangle:
            return triangle.upgradePriceB[level]
        case .Square:
            return square.upgradePriceB[level]
        case .Pentagon:
            return pentagon.upgradePriceB[level]
        case .Hexagon:
            return hexagon.upgradePriceB[level]
        case .Octagon:
            return octagon.upgradePriceB[level]
        case .Circle:
            return circle.upgradePriceB[level]
        default:
            return 0
        }
    }
    
    func getUpgradePriceC(_ level: Int) -> Int {
        switch self {
        case .Triangle:
            return triangle.upgradePriceC[level]
        case .Square:
            return square.upgradePriceC[level]
        case .Pentagon:
            return pentagon.upgradePriceC[level]
        case .Hexagon:
            return hexagon.upgradePriceC[level]
        case .Octagon:
            return octagon.upgradePriceC[level]
        case .Circle:
            return circle.upgradePriceC[level]
        default:
            return 0
        }
    }
    
    func getUpgradePriceFix(_ level: Int) -> Int {
        switch self {
        case .Bumper:
            return bumper.upgradePriceFix[level]
        case .Graviton:
            return graviton.upgradePriceFix[level]
        case .Vortex:
            return vortex.upgradePriceFix[level]
        default:
            return 0
        }
    }
    
    func getPigRateA(_ level: Int) -> Int {
        switch self {
        case .Triangle:
            return triangle.pigRateA[level]
        case .Square:
            return square.pigRateA[level]
        case .Pentagon:
            return pentagon.pigRateA[level]
        case .Hexagon:
            return hexagon.pigRateA[level]
        case .Octagon:
            return octagon.pigRateA[level]
        case .Circle:
            return circle.pigRateA[level]
        default:
            return 0
        }
    }
    
    func getPigRateB(_ level: Int) -> Int {
        switch self {
        case .Triangle:
            return triangle.pigRateB[level]
        case .Square:
            return square.pigRateB[level]
        case .Pentagon:
            return pentagon.pigRateB[level]
        case .Hexagon:
            return hexagon.pigRateB[level]
        case .Octagon:
            return octagon.pigRateB[level]
        case .Circle:
            return circle.pigRateB[level]
        default:
            return 0
        }
    }
    
    func getPigRateC(_ level: Int) -> Int {
        switch self {
        case .Triangle:
            return triangle.pigRateC[level]
        case .Square:
            return square.pigRateC[level]
        case .Pentagon:
            return pentagon.pigRateC[level]
        case .Hexagon:
            return hexagon.pigRateC[level]
        case .Octagon:
            return octagon.pigRateC[level]
        case .Circle:
            return circle.pigRateC[level]
        default:
            return 0
        }
    }
    
    func getPigRateFix(_ level: Int) -> Int {
        switch self {
        case .Bumper:
            return bumper.pigRateFix[level]
        case .Graviton:
            return graviton.pigRateFix[level]
        case .Vortex:
            return vortex.pigRateFix[level]
        default:
            return 0
        }
    }
    
    // Plays collision sound for a given object.
    func playCollisionSound(_ object: GameObject) {
        var soundFile: String
        
        switch self {
        case .Triangle:
            soundFile = "TriangleHit.mp3"
        case .Square:
            soundFile = "SquareHit"
        case .Pentagon:
            soundFile = "PentagonHit"
        case .Hexagon:
            soundFile = "HexagonHit"
        case .Octagon:
            soundFile = "OctagonHit"
        case .Circle:
            soundFile = "CircleHit"
        default:
            return
        }
            
        let sound = SKAction.playSoundFileNamed(soundFile, waitForCompletion: false)
        object.run(sound)
        
    }
    
}

