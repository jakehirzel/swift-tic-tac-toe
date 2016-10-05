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
    func playTurn(board: inout [[String]], move: NewMove) -> (validPlay: Bool, instructionalMessage: String) {
        
        // Check that there has not already been a play during this turn
        if gameInfo.lastMove?.playerUUID == move.playerUUID {
            print("Already played this round!")
            return (false, "Aready played this round!")
        }
        
        // Check for anything out of bounds
        guard move.columnPlayed < 3 && move.rowPlayed < 3 else {
            print("Game limited to 3 x 3 square!")
            return (false, "Game limited to 3 x 3 square!")
        }
        
        // Check for occupied square
        guard board[move.columnPlayed][move.rowPlayed] == "?" else {
            print("Square already occupied!")
            return (false, "Sqaure already occupied!")
        }
        
        // Record the valid play in the board array
        board[move.columnPlayed][move.rowPlayed] = move.playerLetter
        
        // Record the valid play in lastMove in gameInfo
        gameInfo.lastMove = move
        
        // If we've made it this far:
        return (true, "")
        
    }
    
    // To undo a play
    func undoPlay() {
                
        // Reject if lastMove is nil
        guard gameInfo.lastMove != nil else {
            return
        }
        
        // Reset the coordinates from lastMove in the board array to ?
        gameInfo.gameBoard[(gameInfo.lastMove?.columnPlayed)!][(gameInfo.lastMove?.rowPlayed)!] = "?"
        
        // If board array is reset to all ?s, reset newGame to true
        if checkForEmptyBoard(board: gameInfo.gameBoard) == true {
            gameInfo.newGame = true
        }
        
        // Make lastMove = nil
        gameInfo.lastMove = nil
        
    }
    
    
    // To check for a win
    func checkForWin(board: [[String]], move: NewMove) -> Win {
        
        // Set side length
        let sideLength = board.count
        
        // Create an instance of a win object
        var winData = Win()
        
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
            winData.isWin = true
            winData.winType = "column"
            winData.winIndex = move.columnPlayed
            return winData
        }
        
        // Check for row win
        if rowCount == sideLength {
            print("Won in row: \(move.rowPlayed)")
            winData.isWin = true
            winData.winType = "row"
            winData.winIndex = move.rowPlayed
            return winData
        }
        
        // Check for forward slash win
        if forwardSlashDiagonalCount == sideLength {
            print("Won on the forward diagonal!")
            winData.isWin = true
            winData.winType = "forwardDiagonal"
            return winData
        }
        
        // Check for backward slash win
        if backwardSlashDiagonalCount == sideLength {
            print("Won on the backward diagonal!")
            winData.isWin = true
            winData.winType = "backwardDiagonal"
            return winData
        }
        
        // Check for a draw or no win at all
        for column in board {
            if column.contains("?") {
                
                // Return no win
                winData.isWin = false
                return winData
                
            }
            else {
                
                // Return a draw
                winData.isWin = true
                winData.winType = "draw"
                return winData
                
            }
            
        }
        
        // If all else fails:
        winData.isWin = false
        return winData
        
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


