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
    var cardImage: UIImage
    var cardImageView: UIImageView
    
    let rank: Rank, suit: Suit
    
    override init () {
        self.suit = .Spades
        self.rank = .Ace
        self.cardLabel = UILabel()
        self.cardImage = UIImage()
        self.cardImageView = UIImageView()
        super.init()
    }
    
    init (rank: Rank, suit: Suit) {
        
        self.rank = rank
        self.suit = suit
        self.cardLabel = UILabel()
        self.cardImage = UIImage()
        self.cardImageView = UIImageView()
        super.init()
        self.cardLabel.text = self.description
        self.cardLabel.font = UIFont(name: "Arial", size: 15)
        self.cardImage = UIImage(named: cardFace())!
        self.cardImageView.image = cardImage
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
    func cardFace() ->String {
        var output = ""
        var special = true
        switch rank {
        case .Jack:
            output += "jack"
        case .Queen:
            output += "queen"
        case .King:
            output += "king"
        case .Ace:
            output += "ace"
            special = false
        default:
            output += "\(rank.rawValue)"
            special = false
        }
        output += "_of_"
        switch suit {
        case .Clubs:
            output += "clubs"
        case .Diamonds:
            output += "diamonds"
        case .Hearts:
            output += "hearts"
        case .Spades:
            output += "spades"
        }
        if special {
            output += "2"
        }
        return output
    }
}