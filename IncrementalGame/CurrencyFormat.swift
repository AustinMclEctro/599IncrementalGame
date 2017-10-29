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
        var types = ["aJ", "bJ", "cJ", "dJ", "eJ", "fJ", "gJ", "hJ"];
        var val = 0.0;
        if (self != 0) {
            // ln(100) = 4.60517018599;
            // val = log Base 100 self

            val = log(Double(self))/4.60517018599
            
        }
        
        var typeIndex = Int(floor(val));
        
        var total = Int(Double(self)/(pow(100, Double(typeIndex))))
        if (types.count <= typeIndex-1) {
            return String(describing: total);
        }
        return String(describing: total)+types[typeIndex];
    }
}
