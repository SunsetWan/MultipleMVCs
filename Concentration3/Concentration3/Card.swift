//
//  Card.swift
//  Concentration3
//
//  Created by sunsetwan on 2019/3/5.
//  Copyright © 2019 sunsetwan. All rights reserved.
//

import Foundation

// Hashable inherits from Equatable
struct Card: Hashable{
    
    // implement Equatable protocol
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
     //return a computed hashValue, but deprecated as a Hashable requirement. To conform to Hashable, implement the hash(into:) requirement instead
    //var hashValue: Int {return  identifier}
    
    // upgrade to Swift 5.0
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.identifier)
    }

    var isFaceUp: Bool = false
    var isMatched: Bool = false
    var identifier =  getUniqueIdentifier()
    
    private static var uniqueIdentifier: Int = 0
    private static func getUniqueIdentifier() -> Int{
        uniqueIdentifier += 1
        return uniqueIdentifier
    }
}

