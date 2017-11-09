//
//  CurrencyFormat.swift
//  IncrementalGame
//
//  Created by Ben Grande on 2017-10-26.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import Foundation
extension Int {
    func toCurrency() -> String {
        let symbols = ["µJ","mJ","J","kJ","MJ","GJ","TJ"]
        
        var val = Double(self)
        var suffix: Double
        
        switch self {
        case 0...999:
            suffix = 0
        case 1000...999_999:
            val /= 1000
            suffix = 1
        case 1_000_000...999_999_999:
            val /= 1_000_000
            suffix = 2
        case 1_000_000_000...999_999_999_999:
            val /= 1_000_000_000
            suffix = 3
        case 1_000_000_000_000...999_999_999_999_999:
            val /= 1_000_000_000_000
            suffix = 4
        case 1_000_000_000_000_000...999_999_999_999_999_999:
            val /= 1_000_000_000_000_000
            suffix = 5
        default:
            val /= 1_000_000_000_000_000_000
            suffix = 6
        }
        
        let display = String(format: "%.4g ", val) + symbols[Int(suffix)]
        
        return display
    }
}
