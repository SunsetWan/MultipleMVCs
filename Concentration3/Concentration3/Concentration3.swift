//
//  Concentration3.swift
//  Concentration3
//
//  Created by sunsetwan on 2019/3/5.
//  Copyright © 2019 sunsetwan. All rights reserved.
//

import Foundation

class Concentration3 {
    
    var cards = [Card]()
    var numberOfPairsOfCards: Int
    var gameScore = 0
    var flipCount = 0
    var choosedCards: [Int] = []
    
    // computed property
    var identifierOfOneAndOnlyOneCard: Int? {
        get {
            // This closure expression is provided as the function or method's ONLY argument and I provide that expression as a trailing closure
//            let faceUpCardIndices = cards.indices.filter { cards[$0].isFaceUp }
//            return faceUpCardIndices.count == 1 ? faceUpCardIndices.first : nil
            
            //or using the power of extension, make this code segment even simpler
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
            
//            var foundIndex: Int?
//            for index in cards.indices {
//                if cards[index].isFaceUp {
//                    if foundIndex == nil {
//                        foundIndex = index
//                    } else {
//                        return nil
//                    }
//                }
//            }
//            return foundIndex
            
        }
        set(newValue) {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.init(\(numberOfPairsOfCards)): you must have at least one pair of cards")
        
        self.numberOfPairsOfCards = numberOfPairsOfCards
        for _ in 0..<numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        // TODO: Shuffle the cards
        cards = cards.shuffled()
    }
    
    
    
    func newGame() {
        cards = cards.shuffled()
        for index in cards.indices {
            cards[index].isFaceUp = false
            cards[index].isMatched = false
        }
        flipCount = 0
        gameScore = 0
        choosedCards = []
    }
    
    func chooseCard(at Index: Int) {
        assert(cards.indices.contains(Index), "Concentration.chooseCard(at: \(Index)): chosen index not in the cards")
        if !cards[Index].isMatched, !cards[Index].isFaceUp {
            // check if cards match using if-clause
            flipCount += 1
            
            // be prepared for starting matching when choosing two different cards
            if let matchIndex = identifierOfOneAndOnlyOneCard, matchIndex != Index {
                
                // now cards have implemented Hashable protocol, it's straightforward to understand the following code.
                if cards[matchIndex] == cards[Index] { // start matching officially
                    cards[matchIndex].isMatched = true
                    cards[Index].isMatched = true
                    gameScore += 2
                } else { // if cards don't match, scoring -1 point
                    if choosedCards.contains(cards[matchIndex].hashValue) {
                        gameScore -= 1
                    }
                    if choosedCards.contains(cards[Index].hashValue) {
                        gameScore -= 1
                    }
                } // finish matching work
                //Adding cards to opened cards
                if !choosedCards.contains(cards[Index].hashValue) {
                    choosedCards.append(cards[Index].hashValue)
                    //print("second card's hashValue is \(cards[Index].hashValue)")
                    //print("second card's Index: \(Index)")
                }
                if !choosedCards.contains(cards[matchIndex].hashValue) {
                    choosedCards.append(cards[matchIndex].hashValue)
                    //print("first card's hashValue is \(cards[matchIndex].hashValue)")
                    //print("first card's matchIndex: \(matchIndex)")
                }
                cards[Index].isFaceUp = true // flip the second card up
                //identifierOfOneAndOnlyOneCard = nil
            } else {
                // either no cards chosen or only one card chosen
//                for flipDownIndex in cards.indices {
//                    cards[flipDownIndex].isFaceUp = false // flip all cards down first
//                }
//                cards[Index].isFaceUp = true // flip the only one card up
                identifierOfOneAndOnlyOneCard = Index
            }
            
        }
    }
    
}

extension Collection {
    var oneAndOnly: Element? {
        // count and first are methods of Collection
        return count == 1 ? first : nil
    }
}


