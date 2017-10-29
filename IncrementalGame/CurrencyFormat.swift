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
        // TODO:
        /* - Need a faster way of doing this
         - Actual units
         - use everywhere (shop)
         
         */
        var types = ["aJ", "bJ", "cJ", "dJ"];
        var val = 0.0;
        if (self != 0) {
            val = log(Double(self))/log(100.0)
        }
        
        var typeIndex = Int(floor(val));
        
        var total = Int(Double(self)/(pow(100, Double(typeIndex))))
        return String(describing: total)+types[typeIndex];
    }
}
