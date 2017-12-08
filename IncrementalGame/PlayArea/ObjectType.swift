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
    case Bonus
    case Graviton
    case Vortex
    
    
    // MARK: Constants
    
    
    static let types = [Triangle,Square,Pentagon,Hexagon,Octagon,Circle,Bonus,Graviton,Vortex]
    
    struct triangle {
        static let points = [20,21,22,23,24,25,26,27,28,29]
        static let price = 9000
        static let pigRateNew = 2
        static let upgradePriceA = [450,535,640,760,905,1075,1285,1530,1820]
        static let pigRateA = [0,0,0,0,0,0,0,0,1]
        static let upgradePriceB = [3600,4865,6585,8905,12045]
        static let pigRateB = [0,1,1,1,1]
        static let upgradePriceC = [900,1220,1645,2225,3010]
        static let pigRateC = [0,0,0,0,1]
    }
    
    struct square {
        static let points = [30,31,33,34,36,37,39,40,42,44]
        static let price = 18000
        static let pigRateNew = 3
        static let upgradePriceA = [900,1070,1275,1520,1810,2155,2570,3060,3640]
        static let pigRateA = [0,0,0,0,0,1,0,0,1]
        static let upgradePriceB = [7200,9735,13170,17810,24085]
        static let pigRateB = [1,1,1,1,2]
        static let upgradePriceC = [1800,2435,3290,4455,6020]
        static let pigRateC = [0,0,1,0,1]
    }
    
    struct pentagon {
        static let points = [50,52,55,57,60,62,65,67,70,73]
        static let price = 37500
        static let pigRateNew = 5
        static let upgradePriceA = [1875,2235,2660,3165,3770,4490,5350,6370,7585]
        static let pigRateA = [0,0,0,1,0,0,0,1,1]
        static let upgradePriceB = [15000,20285,27435,37100,50180]
        static let pigRateB = [2,2,2,2,2]
        static let upgradePriceC = [3750,5070,6860,9275,12545]
        static let pigRateC = [0,1,0,1,1]
    }
    
    struct hexagon {
        static let points = [80,84,88,92,96,100,104,108,112,116]
        static let price = 72000
        static let pigRateNew = 8
        static let upgradePriceA = [3600,4285,5105,6080,7240,8625,10270,12230,14565]
        static let pigRateA = [0,0,1,0,1,0,1,0,1]
        static let upgradePriceB = [28800,38950,52675,71235,96340]
        static let pigRateB = [3,3,3,3,4]
        static let upgradePriceC = [7200,9735,13170,17810,24085]
        static let pigRateC = [0,1,1,1,1]
    }
    
    struct octagon {
        static let points = [150,157,165,172,180,187,195,202,210,218]
        static let price = 180000
        static let pigRateNew = 15
        static let upgradePriceA = [9000,10720,12765,15200,18105,21560,25675,30575,36410]
        static let pigRateA = [0,1,1,0,1,1,1,1,1]
        static let upgradePriceB = [72000,97375,131685,178090,240850]
        static let pigRateB = [6,6,6,6,6]
        static let upgradePriceC = [18000,24345,32920,44525,60210]
        static let pigRateC = [1,2,1,2,2]
    }
    
    struct circle {
        static let points = [300,315,330,345,360,375,390,405,420,435]
        static let price = 675000
        static let pigRateNew = 30
        static let upgradePriceA = [33750,40195,47865,57000,67885,80840,96275,114650,136540]
        static let pigRateA = [1,2,1,2,1,2,1,2,2]
        static let upgradePriceB = [270000,365145,493820,667845,903190]
        static let pigRateB = [12,12,12,12,12]
        static let upgradePriceC = [67500,91285,123455,166960,225800]
        static let pigRateC = [3,3,3,3,3]
    }
    
    struct bonus {
        static let price = 1
        static let pigRateNew = 1
        static let upgradePriceFix = [3,4,5,6,7]
        static let pigRateFix = [3,4,5,6,7]
    }
    
    struct graviton {
        static let price = 1
        static let pigRateNew = 1
        static let upgradePriceFix = [3,4,5,6,7]
        static let pigRateFix = [3,4,5,6,7]
    }
    
    struct vortex {
        static let price = 1
        static let pigRateNew = 1
        static let upgradePriceFix = [3,4,5,6,7]
        static let pigRateFix = [3,4,5,6,7]
    }
    
    
    // MARK: Functions
    
    
    /// Retrieves the type for the ObjectType (fixture or shape).
    ///
    /// - Returns: true if fixture.
    func isFixture() -> Bool {
        let fixtures: [ObjectType] = [.Bonus, .Graviton, .Vortex]
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
        case .Bonus:
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
        case .Bonus:
            return bonus.price
        case .Graviton:
            return graviton.price
        case .Vortex:
            return vortex.price
        default:
            return -1
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
        case .Bonus:
            return bonus.pigRateNew
        case .Graviton:
            return graviton.pigRateNew
        case .Vortex:
            return vortex.pigRateNew
        default:
            return -1
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
            return -1
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
            return -1
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
            return -1
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
            return -1
        }
    }
    
    
    func getUpgradePriceFix(_ level: Int) -> Int {
        switch self {
        case .Bonus:
            return bonus.upgradePriceFix[level]
        case .Graviton:
            return graviton.upgradePriceFix[level]
        case .Vortex:
            return vortex.upgradePriceFix[level]
        default:
            return -1
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
            return -1
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
            return -1
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
            return -1
        }
    }
    
    
    func getPigRateFix(_ level: Int) -> Int {
        switch self {
        case .Bonus:
            return bonus.pigRateFix[level]
        case .Graviton:
            return graviton.pigRateFix[level]
        case .Vortex:
            return vortex.pigRateFix[level]
        default:
            return -1
        }
    }
    
    
    // Plays collision sound for a given object.
    func playCollisionSound(_ object: GameObject) {
        var soundFile: String
        
        switch self {
        case .Triangle:
            soundFile = "TriangleHit"
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

