//
//  Shoe.swift
//  BlackJackGaming
//
//  Created by Dong Li on 3/1/15.
//  Copyright (c) 2015 Dong Li. All rights reserved.
//

import Foundation

class Shoe: Deck {
    
    var numOfDecks: Int
    
    init(numOfDecks: Int) {
        
        self.numOfDecks = numOfDecks
        super.init()
    }
    
    func makeNewShoe() {
        self.cards = []
        for i in 0..<numOfDecks {
            makeNewDeck()
        }
    }
    func shuffle() {
        let count = countElements(cards)
        for i in 0..<(count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            var c = Card()
            c = cards[i]
            cards[i] = cards[j]
            cards[j] = c
        }
    }
    func print() {
        println("\(numOfDecks)")
    }
}