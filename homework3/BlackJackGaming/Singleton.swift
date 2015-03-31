//
//  Singleton.swift
//  BlackJackGaming
//
//  Created by Dong Li on 3/1/15.
//  Copyright (c) 2015 Dong Li. All rights reserved.
//

import Foundation

class Singleton {
    
    var player1: Player = Player(name: "You")
    var player2: Player = Player(name: "Friend")
    var player3: Player = Player(name: "Chris")
    var player4: Player = Player(name: "Daniel")
    var player5: Player = Player(name: "Elissa")
    var players = [Player(name: "You"),Player(name: "Friend"),Player(name: "Chirs"),Player(name: "Daniel"),Player(name: "Elissa")]
    class var sharedInstance: Singleton {
        
        struct Static {
            static let instance: Singleton = Singleton()
        }
        return Static.instance
    }
}