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
    case Circle
    case Star
    case Bumper
    case Graviton
    case Vortex
    
    struct points {
        static let triangle = [3,4,5,6,7,8,9,10,11,12]
        static let square = [4,5,6,7,8,9,10,11,12,13]
        static let pentagon = [5,6,7,8,9,10,11,12,13,14]
        static let hexagon = [6,7,8,9,10,11,12,13,14,15]
        static let circle = [7,8,9,10,11,12,13,14,15,16]
        static let star = [8,9,10,11,12,13,14,15,16,17]
    }
    struct upgradePriceA {
        static let triangle = [3,4,5,6,7,8,9,10,11]
        static let square = [4,5,6,7,8,9,10,11,12]
        static let pentagon = [5,6,7,8,9,10,11,12,13]
        static let hexagon = [6,7,8,9,10,11,12,13,14]
        static let circle = [7,8,9,10,11,12,13,14,15]
        static let star = [8,9,10,11,12,13,14,15,16]
    }
    struct upgradePriceB {
        static let triangle = [3,4,5,6,7]
        static let square = [4,5,6,7,8]
        static let pentagon = [5,6,7,8,9]
        static let hexagon = [6,7,8,9,10]
        static let circle = [7,8,9,10,11]
        static let star = [8,9,10,11,12]
    }
    struct upgradePriceC {
        static let triangle = [3,4,5,6,7]
        static let square = [4,5,6,7,8]
        static let pentagon = [5,6,7,8,9]
        static let hexagon = [6,7,8,9,10]
        static let circle = [7,8,9,10,11]
        static let star = [8,9,10,11,12]
    }
    struct upgradePriceFix {
        static let bumper = [3,4,5,6,7]
        static let graviton = [4,5,6,7,8]
        static let vortex = [5,6,7,8,9]
    }
    struct pigRateNew {
        static let triangle = 1
        static let square = 2
        static let pentagon = 3
        static let hexagon = 4
        static let circle = 5
        static let star = 6
        static let bumper = 7
        static let graviton = 8
        static let vortex = 9
    }
    struct price {
        static let triangle = 100
        static let square = 200
        static let pentagon = 300
        static let hexagon = 400
        static let circle = 500
        static let star = 600
        static let bumper = 700
        static let graviton = 800
        static let vortex = 900
    }
    struct pigRateA {
        static let triangle = [3,4,5,6,7,8,9,10,11,12]
        static let square = [4,5,6,7,8,9,10,11,12,13]
        static let pentagon = [5,6,7,8,9,10,11,12,13,14]
        static let hexagon = [6,7,8,9,10,11,12,13,14,15]
        static let circle = [7,8,9,10,11,12,13,14,15,16]
        static let star = [8,9,10,11,12,13,14,15,16,17]
    }
    struct pigRateB {
        static let triangle = [3,4,5,6,7,8]
        static let square = [4,5,6,7,8,9]
        static let pentagon = [5,6,7,8,9,10]
        static let hexagon = [6,7,8,9,10,11]
        static let circle = [7,8,9,10,11,12]
        static let star = [8,9,10,11,12,13]
    }
    struct pigRateC {
        static let triangle = [3,4,5,6,7,8]
        static let square = [4,5,6,7,8,9]
        static let pentagon = [5,6,7,8,9,10]
        static let hexagon = [6,7,8,9,10,11]
        static let circle = [7,8,9,10,11,12]
        static let star = [8,9,10,11,12,13]
    }
    struct pigRateFix {
        static let bumper = [3,4,5,6,7,8]
        static let graviton = [4,5,6,7,8,9]
        static let vortex = [5,6,7,8,9,10]
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
        case .Circle:
            return 5001
        case .Star:
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
            return price.triangle
        case .Square:
            return price.square
        case .Pentagon:
            return price.pentagon
        case .Hexagon:
            return price.hexagon
        case .Circle:
            return price.circle
        case .Star:
            return price.star
        case .Bumper:
            return price.bumper
        case .Graviton:
            return price.graviton
        case .Vortex:
            return price.vortex
        default:
            return 0
        }
    }
    
    func getPigRateNew() -> Int {
        switch self {
        case .Triangle:
            return pigRateNew.triangle
        case .Square:
            return pigRateNew.square
        case .Pentagon:
            return pigRateNew.pentagon
        case .Hexagon:
            return pigRateNew.hexagon
        case .Circle:
            return pigRateNew.circle
        case .Star:
            return pigRateNew.star
        case .Bumper:
            return pigRateNew.bumper
        case .Graviton:
            return pigRateNew.graviton
        case .Vortex:
            return pigRateNew.vortex
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
            return points.triangle[level]
        case .Square:
            return points.square[level]
        case .Pentagon:
            return points.pentagon[level]
        case .Hexagon:
            return points.hexagon[level]
        case .Circle:
            return points.circle[level]
        case .Star:
            return points.star[level]
        default:
            return 0
        }
    }
    
    func getUpgradePriceA(_ level: Int) -> Int {
        switch self {
        case .Triangle:
            return upgradePriceA.triangle[level]
        case .Square:
            return upgradePriceA.square[level]
        case .Pentagon:
            return upgradePriceA.pentagon[level]
        case .Hexagon:
            return upgradePriceA.hexagon[level]
        case .Circle:
            return upgradePriceA.circle[level]
        case .Star:
            return upgradePriceA.star[level]
        default:
            return 0
        }
    }
    
    func getUpgradePriceB(_ level: Int) -> Int {
        switch self {
        case .Triangle:
            return upgradePriceB.triangle[level]
        case .Square:
            return upgradePriceB.square[level]
        case .Pentagon:
            return upgradePriceB.pentagon[level]
        case .Hexagon:
            return upgradePriceB.hexagon[level]
        case .Circle:
            return upgradePriceB.circle[level]
        case .Star:
            return upgradePriceB.star[level]
        default:
            return 0
        }
    }
    
    func getUpgradePriceC(_ level: Int) -> Int {
        switch self {
        case .Triangle:
            return upgradePriceC.triangle[level]
        case .Square:
            return upgradePriceC.square[level]
        case .Pentagon:
            return upgradePriceC.pentagon[level]
        case .Hexagon:
            return upgradePriceC.hexagon[level]
        case .Circle:
            return upgradePriceC.circle[level]
        case .Star:
            return upgradePriceC.star[level]
        default:
            return 0
        }
    }
    
    func getUpgradePriceFix(_ level: Int) -> Int {
        switch self {
        case .Bumper:
            return upgradePriceFix.bumper[level]
        case .Graviton:
            return upgradePriceFix.graviton[level]
        case .Vortex:
            return upgradePriceFix.vortex[level]
        default:
            return 0
        }
    }
    
    func getPigRateA(_ level: Int) -> Int {
        switch self {
        case .Triangle:
            return pigRateA.triangle[level]
        case .Square:
            return pigRateA.square[level]
        case .Pentagon:
            return pigRateA.pentagon[level]
        case .Hexagon:
            return pigRateA.hexagon[level]
        case .Circle:
            return pigRateA.circle[level]
        case .Star:
            return pigRateA.star[level]
        default:
            return 0
        }
    }
    
    func getPigRateB(_ level: Int) -> Int {
        switch self {
        case .Triangle:
            return pigRateB.triangle[level]
        case .Square:
            return pigRateB.square[level]
        case .Pentagon:
            return pigRateB.pentagon[level]
        case .Hexagon:
            return pigRateB.hexagon[level]
        case .Circle:
            return pigRateB.circle[level]
        case .Star:
            return pigRateB.star[level]
        default:
            return 0
        }
    }
    
    func getPigRateC(_ level: Int) -> Int {
        switch self {
        case .Triangle:
            return pigRateC.triangle[level]
        case .Square:
            return pigRateC.square[level]
        case .Pentagon:
            return pigRateC.pentagon[level]
        case .Hexagon:
            return pigRateC.hexagon[level]
        case .Circle:
            return pigRateC.circle[level]
        case .Star:
            return pigRateC.star[level]
        default:
            return 0
        }
    }
    
    func getPigRateFix(_ level: Int) -> Int {
        switch self {
        case .Bumper:
            return pigRateFix.bumper[level]
        case .Graviton:
            return pigRateFix.graviton[level]
        case .Vortex:
            return pigRateFix.vortex[level]
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
        case .Circle:
            soundFile = "CircleHit"
        case .Star:
            soundFile = "StarHit"
        default:
            return
        }
            
        let sound = SKAction.playSoundFileNamed(soundFile, waitForCompletion: false)
        object.run(sound)
        
    }
    
}

