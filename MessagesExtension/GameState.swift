//
//  GameState.swift
//  ExOh
//
//  Created by Jake Hirzel on 9/7/16.
//  Copyright © 2016 Jake Hirzel. All rights reserved.
//
//  Abstract: Structs to hold game state information.

import Foundation
import Messages

// Struct to hold player info
struct PlayerInfo {
    let playerOneID: UUID
    let playerOneLetter: Character
    let playerTwoID: UUID
    let playerTwoLetter: Character
}

// Struct to hold data for each move
struct NewMove {
    let playerNumber: Int
    let columnPlayed: Int
    let rowPlayed: Int
}

// Struct to hold move list
struct GameHistory {
    var moveList: [NewMove]
}
