//
//  Deck.swift
//  BlackJackGaming
//
//  Created by Dong Li on 3/1/15.
//  Copyright (c) 2015 Dong Li. All rights reserved.
//

import Foundation

class Deck {
    
    var cards: [Card]
    
    init(){
        cards = []
    }
    
    func makeNewDeck() {
        
        for suit in Card.Suit.allSuits {
            for rank in Card.Rank.allRanks {
                cards.append(Card(rank: rank, suit: suit))
            }
        }
    }
}