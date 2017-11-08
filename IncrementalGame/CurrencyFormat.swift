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
        if val != 0 {
            suffix = floor(log(val)/6.90775527898214)
        } else {
            suffix = 0
        }
        val = val/(pow(1000,suffix))
        let display = String(format: "%.4g ", val) + symbols[Int(suffix)]
        
        return display
    }
}
