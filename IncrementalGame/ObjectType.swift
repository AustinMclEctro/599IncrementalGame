//
//  ObjectType.swift
//  IncrementalGame
//
//  Created by Ben Grande on 2017-10-05.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import UIKit

enum ObjectType {
    
    case Triangle
    case Square
    case Pentagon
    case Hexagon
    case Circle
    case Star
    case Bumper
    
    
    func getImage() -> UIImage? {
        return UIImage(named: String(describing: self))
    }
    
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
        default:
            return 0
        }
    }
    
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
        case .Bumper:
            return 0
        default:
            return 0
        }
    }
    
}

