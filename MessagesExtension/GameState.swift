//
//  GameState.swift
//  ExOh
//
//  Created by Jake Hirzel on 9/7/16.
//  Copyright © 2016 Jake Hirzel. All rights reserved.
//
//  Abstract: Structs to hold game state information.

import Foundation

// Struct to hold game info
struct GameInfo {
    var players: [String: String] = [:] // Stores UUIDstring and player's letter
    var newGame: Bool = true
    var lastMove: NewMove?
    var gameWon: Win?
    var gameBoard: [[String]] = Array(repeating: Array(repeating: "?", count: 3), count: 3)
}

// Struct to hold data for each move
struct NewMove {
    var playerUUID: String = "99"
    var playerLetter: String = "99"
    var columnPlayed: Int = 99
    var rowPlayed: Int = 99
}

// Struct to hold win data
struct Win {
    var isWin: Bool = false
    var winType: String? = nil
    var winIndex: Int? = nil
}

// Struct to hold move list
struct GameHistory {
    var moveList: [NewMove]
}
