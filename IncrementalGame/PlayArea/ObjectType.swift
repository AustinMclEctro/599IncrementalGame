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
    
    
    /// Retrieves the price for the ObjectType.
    ///
    /// - Returns: The price for the ObjectType.
    func getPrice() -> Int {
        switch self {
        case .Triangle:
            return 100
        case .Square:
            return 200
        case .Pentagon:
            return 300
        case .Hexagon:
            return 400
        case .Circle:
            return 500
        case .Star:
            return 600
        case .Bumper:
            return 1000
        case .Graviton:
            return 2000
        case .Vortex:
            return 3000
        default:
            return 0
        }
    }
    
    
    /// Gets the point value for the ObjectType.
    ///
    /// - Returns: The points earned on each collision for the ObjectType.
    func getPoints() -> Int {
        switch self {
        case .Triangle:
            return 3
        case .Square:
            return 4
        case .Pentagon:
            return 5
        case .Hexagon:
            return 6
        case .Circle:
            return 7
        case .Star:
            return 8
        default:
            return 0
        }
    }
    
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
        case .Circle:
            soundFile = "CircleHit"
        case .Star:
            soundFile = "StarHit"
        case .Bumper:
            return
        case .Graviton:
            return
        case .Vortex:
            return
        default:
            return
        }
        
        let sound = SKAction.playSoundFileNamed(soundFile, waitForCompletion: false)
        
        object.run(sound)
    }
    
}

