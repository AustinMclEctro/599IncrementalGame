//
//  File.swift
//  IncrementalGame
//
//  Created by Michael Lee on 2017-10-30.
//  Copyright © 2017 Ben Grande. All rights reserved.
//

import Foundation


/// Used to store information about the current player
class Player: NSObject, NSCoding {
    // MARK: Properties
    var id: Int // TODO: Create an ID generator
    var lastLogin = Date()
    var lastLogout = Date()
    
    init(id: Int) {
        self.id = id;
    }
  
    init(id: Int, lastLogin: Date, lastLogout: Date) {
        self.id = id;
        self.lastLogin = lastLogin
        self.lastLogout = lastLogout
    }
    
    // MARK: NSCoding
    
    /// Keys used to reference the properties in memory
    struct PropertyKey {
        static let id = "id"
        static let lastLogin = "lastLogin"
        static let lastLogout = "lastLogout"
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: PropertyKey.id)
        aCoder.encode(lastLogin, forKey: PropertyKey.lastLogin)
        aCoder.encode(lastLogout, forKey: PropertyKey.lastLogout)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeInteger(forKey: PropertyKey.id)
        let lastLogin = aDecoder.decodeObject(forKey: PropertyKey.lastLogin) as! Date
        let lastLogout = aDecoder.decodeObject(forKey: PropertyKey.lastLogin) as! Date
        self.init(id: id, lastLogin: lastLogin, lastLogout: lastLogout)
    }
}
