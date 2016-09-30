//
//  Player.swift
//  Flip
//
//  Created by Thang Le Tan on 9/26/16.
//  Copyright © 2016 Thang Le Tan. All rights reserved.
//

import UIKit
import GameplayKit

class Player: NSObject {
    // create two players, black and white, and store them in a static array
    
    static let allPlayers = [Player(stone: .black), Player(stone: .white)]
    
    var stoneColor: StoneColor
    
    init(stone: StoneColor) {
        stoneColor = stone
    }
    
    var opponent: Player {
        if stoneColor == .black {
            return Player.allPlayers[1]
        } else {
            return Player.allPlayers[0]
        }
    }
    
}
