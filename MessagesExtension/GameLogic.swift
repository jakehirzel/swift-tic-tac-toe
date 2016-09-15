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
    
    // Create gameInfo instance
    var gameInfo = GameInfo()
    
    // To play a turn
    func playTurn(board: inout [[String]], move: NewMove) -> Bool {
        
        // Check that there has not already been a play during this turn
        if gameInfo.lastMove != nil {
            print("Already played this round!")
            return false
        }
        
        // Check for anything out of bounds
        guard move.columnPlayed < 3 && move.rowPlayed < 3 else {
            print("Game limited to 3 x 3 square!")
            return false
        }
        
        // Check for occupied square
        guard board[move.columnPlayed][move.rowPlayed] == "?" else {
            print("Square already occupied!")
            return false
        }
        
        // Record the valid play in the board array
        board[move.columnPlayed][move.rowPlayed] = move.playerLetter
        
        // Record the valid play in lastMove in gameInfo
        gameInfo.lastMove = move
        
        // If we've made it this far:
        return true
        
    }
    
    // To check for a win
    func checkForWin(board: [[String]], move: NewMove) -> (isWin: Bool, winType: String?, winIndex: Int?) {
        
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
            if square == move.playerLetter {
                columnCount += 1
            }
        }
        
        // Check row
        for column in board {
            if column[move.rowPlayed] == move.playerLetter {
                rowCount += 1
            }
        }
        
        // Check forward slash diagonal
        while forwardSlashHorizontalCoord < sideLength && board[forwardSlashHorizontalCoord][forwardSlashVerticalCoord] == move.playerLetter {
            
            // Increment the coordinates and count
            forwardSlashHorizontalCoord += 1
            forwardSlashVerticalCoord -= 1
            forwardSlashDiagonalCount += 1
            
        }
        
        // Check backward slash diagonal
        while backwardSlashHorizontalCoord < sideLength && board[backwardSlashHorizontalCoord][backwardSlashVerticalCoord] == move.playerLetter {
            
            // Increment/decrement the coordinates and count
            backwardSlashHorizontalCoord += 1
            backwardSlashVerticalCoord += 1
            backwardSlashDiagonalCount += 1
            
        }
        
        // Check for column win
        if columnCount == sideLength {
            print("Won in column: \(move.columnPlayed)")
            return (isWin: true, winType: "column", winIndex: move.columnPlayed)
        }
        
        // Check for row win
        if rowCount == sideLength {
            print("Won in row: \(move.rowPlayed)")
            return (isWin: true, winType: "row", winIndex: move.rowPlayed)
        }
        
        // Check for forward slash win
        if forwardSlashDiagonalCount == sideLength {
            print("Won on the forward diagonal!")
            return (isWin: true, winType: "forwardDiagonal", winIndex: nil)
        }
        
        // Check for backward slash win
        if backwardSlashDiagonalCount == sideLength {
            print("Won on the backward diagonal!")
            return (isWin: true, winType: "backwardDiagonal", winIndex: nil)
        }
                
        // If no win:
        return (isWin: false, winType: nil, winIndex: nil)
        
    }
    
    // Check for an empty board
    func checkForEmptyBoard(board: [[String]]) -> Bool {
        
        // Assume the board is empty, any conflict will change to false
        var boardEmpty = true
        for column in board {
            for row in column {
                if row != "?" {
                    boardEmpty = false
                }
            }
        }
        return boardEmpty
    }
    
}


