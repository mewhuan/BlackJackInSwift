//
//  Hand.swift
//  BlackJackGaming
//
//  Created by Dong Li on 3/1/15.
//  Copyright (c) 2015 Dong Li. All rights reserved.
//

import Foundation

class Hand {
    
    var cards = [Card]()
    var score: Int = 1
    var bet: Int = 1
    var result = "Lose"
    
    init() {
        
    }
    
    func sumHand() -> Int {
        
        var sum = 0
        var numOfAce = 0
        for card in cards {
            if card.rank.values.second != nil {
                numOfAce++
                sum += 11
            } else {
                sum += card.rank.values.first
            }
        }
        while sum > 21 && numOfAce > 0 {
            sum -= 10
            numOfAce--
        }
        return sum
    }
}