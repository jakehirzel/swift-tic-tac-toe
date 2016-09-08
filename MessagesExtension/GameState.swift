//
//  GameState.swift
//  ExOh
//
//  Created by Jake Hirzel on 9/7/16.
//  Copyright © 2016 Jake Hirzel. All rights reserved.
//
//  Abstract: A singleton class to hold game state information during play.

import Foundation
import Messages

class GameState {
    
    // Struct to hold player info
    struct PlayerInfo {
        let playerOneID: UUID
        let playerOneLetter: Character
        let playerTwoID: UUID
        let playerTwoLetter: Character
    }
    
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
    
    static let sharedInstance = GameState()
    
}
