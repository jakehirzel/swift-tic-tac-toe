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

// Struct to hold game info
struct GameInfo {
//    let playerOneID: UUID? = nil
//    let playerOneLetter: Character = "X"
//    let playerTwoID: UUID? = nil
//    let playerTwoLetter: Character = "O"
    var players: [String: String] = [:] // Stores UUIDstring and player's letter
    var newGame: Bool = true
    var lastMove: NewMove? = nil
    var gameBoard: [[String]] = Array(repeating: Array(repeating: "?", count: 3), count: 3)
}

// Struct to hold data for each move
struct NewMove {
    let playerLetter: String
    let columnPlayed: Int
    let rowPlayed: Int
}

// Struct to hold move list
struct GameHistory {
    var moveList: [NewMove]
}
