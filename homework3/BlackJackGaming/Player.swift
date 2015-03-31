//
//  player.swift
//  BlackJackGaming
//
//  Created by Dong Li on 3/1/15.
//  Copyright (c) 2015 Dong Li. All rights reserved.
//

import Foundation

class Player {
    
    var name: String
    var money: Int = 100
    var hands: [Hand] = []
    
    init(name: String) {
        self.name = name
        hands.append(Hand())
    }
}