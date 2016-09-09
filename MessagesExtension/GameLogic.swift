//
//  GameLogic.swift
//  ExOh
//
//  Created by Jake Hirzel on 9/7/16.
//  Copyright © 2016 Jake Hirzel. All rights reserved.
//
//  Abstract: A class to define the gameplay logic.

import Foundation

class GameLogic {
    
    // Set variable to track new game status
    var newGame = true
    
    // Create a new board
    var board = Array(repeating: Array(repeating: 0, count: 3), count: 3)
    
    // Create an empty game history
    var history: GameHistory? = nil
    
    // To play a turn
    func playTurn(board: inout [[Int]], move: NewMove) -> Bool {
    
        // Check for anything out of bounds
        guard move.columnPlayed < 3 && move.rowPlayed < 3 else {
            print("Game limited to 3 x 3 square!")
            return false
        }
        
        // Check for occupied square
        guard board[move.columnPlayed][move.rowPlayed] == 0 else {
            print("Square already occupied!")
            return false
        }
        
        // Record a valid play in the board array and in the game history
        board[move.columnPlayed][move.rowPlayed] = move.playerNumber
        // TODO: add game history!
        
        // Check for a win
        checkForWin(board: board, move: move)
        
        // If we've made it this far:
        return true
        
    }
    
    // To check for a win
    func checkForWin(board: [[Int]], move: NewMove) {
        
        // Set side length
        let sideLength = board.count
        
        // Variables to track "winning" squares
        var columnCount = 0
        var rowCount = 0
        var forwardSlashDiagonalCount = 0
        var backwardSlashDiagonalCount = 0
        
        // Variables to track horizontal matrix positions
        var forwardSlashHorizontalCoord = 0
        var forwardSlashVerticalCoord = sideLength - 1
        var backwardSlashHorizontalCoord = 0
        var backwardSlashVerticalCoord = 0
        
        // Check column
        for square in board[move.columnPlayed] {
            if square == move.playerNumber {
                columnCount += 1
            }
        }
        
        // Check row
        for column in board {
            if column[move.rowPlayed] == move.playerNumber {
                rowCount += 1
            }
        }
        
        // Check forward slash diagonal
        while forwardSlashHorizontalCoord < sideLength && board[forwardSlashHorizontalCoord][forwardSlashVerticalCoord] == move.playerNumber {
            
            // Increment the coordinates and count
            forwardSlashHorizontalCoord += 1
            forwardSlashVerticalCoord -= 1
            forwardSlashDiagonalCount += 1
            
        }
        
        // Check backward slash diagonal
        while backwardSlashHorizontalCoord < sideLength && board[backwardSlashHorizontalCoord][backwardSlashVerticalCoord] == move.playerNumber {
            
            // Increment/decrement the coordinates and count
            backwardSlashHorizontalCoord += 1
            backwardSlashVerticalCoord += 1
            backwardSlashDiagonalCount += 1
            
        }
        
        // Check for column win
        if columnCount == sideLength {
            print("Won in column: \(move.columnPlayed)")
        }
        
        // Check for row win
        if rowCount == sideLength {
            print("Won in row: \(move.rowPlayed)")
        }
        
        // Check for forward slash win
        if forwardSlashDiagonalCount == sideLength {
            print("Won on the forward diagonal!")
        }
        
        // Check for backward slash win
        if backwardSlashDiagonalCount == sideLength {
            print("Won on the backward diagonal!")
        }
        
    }
    
    // Manage game history
    func addToHistory(move: NewMove, history: inout GameHistory) {
        
        // If newGame = true, add the entry and toggle to false
        if newGame == true {
            history.moveList.append(move)
            newGame = false
        }
            
        // Otherwise just add it
        else {
            history.moveList.append(move)
        }
        
    }
    
}

//    // To create a new game board array
//    func newBoard() -> [[Int]] {
//        let newBoard = Array(repeating: Array(repeating: 0, count: 3), count: 3)
//        return newBoard
//    }

