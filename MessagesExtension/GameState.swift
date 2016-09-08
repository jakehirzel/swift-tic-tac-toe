//
//  GameState.swift
//  ExOh
//
//  Created by Jake Hirzel on 9/7/16.
//  Copyright © 2016 Jake Hirzel. All rights reserved.
//
//  Abstract: A singleton class to hold game state information during play.

import Foundation

class GameState {
    
    // Struct to hold data for each move
    struct NewMove {
        let player: Int
        let column: Int
        let row: Int
    }
    
    // Struct to hold move list
    struct GameHistory {
        var moveList: [NewMove]
    }
    
}
