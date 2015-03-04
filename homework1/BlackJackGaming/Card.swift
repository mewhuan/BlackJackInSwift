//
//  Card.swift
//  BlackJack
//
//  Created by Dong Li on 2/16/15.
//  Copyright (c) 2015 Dong Li. All rights reserved.
//

import Foundation
import UIKit

class Card: NSObject {
    
    enum Suit: Character {
        case Spades = "♠", Hearts = "♡", Diamonds = "♢", Clubs = "♣"
        static let allSuits = [Spades, Hearts, Diamonds,Clubs]
    }
    
    enum Rank: Int {
        case Two = 2, Three, Four, Five, Six, Seven, Eight, Nine, Ten
        case Jack, Queen, King, Ace
        static let allRanks = [Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Jack, Queen, King, Ace]
        struct Values {
            let first: Int, second: Int?
        }
        var values: Values {
            switch self {
            case .Ace:
                return Values(first: 1, second: 11)
            case .Jack, .Queen, .King:
                return Values(first: 10, second: nil)
            default:
                return Values(first: self.rawValue, second: nil)
            }
        }
    }
    
    var cardLabel: UILabel
    
    let rank: Rank, suit: Suit
    
    override init () {
        self.suit = .Spades
        self.rank = .Ace
        self.cardLabel = UILabel()
        super.init()
    }
    
    init (rank: Rank, suit: Suit) {
        
        self.rank = rank
        self.suit = suit
        self.cardLabel = UILabel()
        super.init()
        self.cardLabel.text = self.description
        self.cardLabel.font = UIFont(name: "Arial", size: 15)
    }

    override var description: String {
        var output = "\(suit.rawValue)"
        switch rank {
        case .Jack:
            output += "J"
        case .Queen:
            output += "Q"
        case .King:
            output += "K"
        case .Ace:
            output += "A"
        default:
            output += "\(rank.rawValue)"
        }
        return output
    }
}