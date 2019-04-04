//
//  ViewController.swift
//  Concentration3
//
//  Created by sunsetwan on 2019/3/5.
//  Copyright © 2019 sunsetwan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Typealias
    // themeData is a Tuple which contains an Array of String, bgColor, cardColor
    // You can name the individual elements in a tuple when the tuple is defined
    // If you name the elements in a tuple, you can use the element names to access the values of those elements
    typealias themeData = (emoji: [String], backgroundColor: UIColor, cardColor: UIColor)
    
    var newTheme: themeData {
        let randomNumber = gameThemeSet.count.arc4random
        let key = Array(gameThemeSet.keys)[randomNumber]
        return gameThemeSet[key]!
    }
    
    var bgColor: UIColor = #colorLiteral(red: 0.2540834248, green: 0.2756176293, blue: 0.3027161956, alpha: 1)
    var cardColor: UIColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
    
    private lazy var game = Concentration3(numberOfPairsOfCards: numberOfPairsOfCards)
    
    // read-only computed property, don't need get{}
    var numberOfPairsOfCards: Int {
        return buttonCollection.count / 2
    }
    
    //TODO: add a 'Restart' button
    @IBAction private func startNewGame(_ sender: UIButton) {
        
        // decompose the tuple
        (emojiChoices, bgColor, cardColor) = newTheme
        
        // UIViewController has a property called view which is connected to the top-level view in the scene.
        view.backgroundColor = bgColor
        
        game.newGame()
        updateViewFromModel()
        emojiDictionary.removeAll()
        flipCountLabel.textColor = cardColor
        gameScoreLabel.textColor = cardColor
    }
    
    @IBOutlet private var buttonCollection: [UIButton]!
    
    @IBOutlet private weak var flipCountLabel: UILabel! {
        didSet {
            updateFlipCountLabel()
        }
    }
    
    // TODO: add Score Label
    @IBOutlet private weak var gameScoreLabel: UILabel!
    
    // observer
    //[IMPORTANT] if you initialize a variable, it doesn't invoke didSet only later setting this flipCount
    private(set) var flipCount = 0 {
        didSet {
            updateFlipCountLabel()
        }
    }
    
   private func updateFlipCountLabel() {
        let attributes: [NSAttributedString.Key: Any] = [
            .strokeWidth: 5.0,
            .strokeColor: UIColor.orange
        ]
        let attributedString = NSAttributedString(string: "Flips: \(flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }
    
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if let index = buttonCollection.firstIndex(of: sender) {
            game.chooseCard(at: index)
            updateViewFromModel()
        }
    }
    
    private lazy var emojiChoices = newTheme.emoji
    
    // make struct Card comform to Hashable protocol
    private var emojiDictionary = [Card: String]()
    
    var gameThemeSet: [String: themeData] = [
        "halloween" : (["👻", "🎃", "🍭", "😈", "🤡", "🍫", "🧟‍♂️", "💀"], #colorLiteral(red: 0.2540834248, green: 0.2756176293, blue: 0.3027161956, alpha: 1), #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)),
        "animals" : (["🐕", "🐈", "🐴", "🐭", "🐘", "🐷", "🐮", "🦁"], #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1), #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)),
        "faces":  (["😀", "🤪", "😬", "😭", "😎", "😍", "🤠", "😇", "🤩", "🤢"], #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1), #colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1)),
        "fruits": (["🍏", "🥑", "🍇", "🍒", "🍑", "🥝", "🍐", "🍎", "🍉", "🍌"], #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)),
        "transport": (["🚗", "🚓", "🚚", "🏍", "✈️", "🚜", "🚎", "🚲", "🚂", "🛴"], #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)),
        "sports": (["🏊🏽‍♀️", "🤽🏻‍♀️", "🤾🏾‍♂️", "⛹🏼‍♂️", "🏄🏻‍♀️", "🚴🏻‍♀️", "🚣🏿‍♀️", "⛷", "🏋🏿‍♀️", "🤸🏼‍♂️"], #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1), #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1))
    ]
    
    
    private func emojiFactory(for card: Card) -> String {
        
        if emojiDictionary[card] == nil , emojiChoices.count > 0 {
            
            // it's not easy to understand what's going in there.
//            let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices[themeIndex].count)))
            
            //var sequentialIndex = 0
            
            emojiDictionary[card] = emojiChoices.remove(at: emojiChoices.count.arc4random)
            //sequentialIndex += 1
        }
        return emojiDictionary[card] ?? "?"
    }
    
    private func updateViewFromModel() {
        flipCountLabel.text = "Flips: \(game.flipCount)"
        gameScoreLabel.text = "Score: \(game.gameScore)"
        for index in buttonCollection.indices {
            let card = game.cards[index]
            let button = buttonCollection[index]
            if card.isFaceUp {
                button.setTitle(emojiFactory(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : cardColor
                
            }
        }
    }
    
}

extension Int { // what if self <= 0 ?
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
