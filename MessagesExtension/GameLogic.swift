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
    
    func playTurn(board: inout [[Int]], playerNumber: Int, columnPlayed: Int, rowPlayed: Int) {
        
        // Check for anything out of bounds
        guard columnPlayed < 3 && rowPlayed < 3 else {
            print("Game limited to 3 x 3 square!")
            return
        }
        
        // Check for occupied square
        guard board[columnPlayed][rowPlayed] == 0 else {
            print("Square already occupied!")
            return
        }
        
        // Record a valid play
        board[columnPlayed][rowPlayed] = playerNumber
        
        // Check for a win
        checkForWin(board: board, playerNumber: playerNumber, columnPlayed: columnPlayed, rowPlayed: rowPlayed)
        
    }
    
    func checkForWin(board: [[Int]], playerNumber: Int, columnPlayed: Int, rowPlayed: Int) {
        
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
        for square in board[columnPlayed] {
            if square == playerNumber {
                columnCount += 1
            }
        }
        
        // Check row
        for column in board {
            if column[rowPlayed] == playerNumber {
                rowCount += 1
            }
        }
        
        // Check forward slash diagonal
        while board[forwardSlashHorizontalCoord][forwardSlashVerticalCoord] == playerNumber {
            
            // Increment the coordinates and count
            forwardSlashHorizontalCoord += 1
            forwardSlashVerticalCoord -= 1
            forwardSlashDiagonalCount += 1
            
        }
        
        // Check backward slash diagonal
        while board[backwardSlashHorizontalCoord][backwardSlashVerticalCoord] == playerNumber {
            
            // Increment/decrement the coordinates and count
            backwardSlashHorizontalCoord += 1
            backwardSlashVerticalCoord += 1
            backwardSlashDiagonalCount += 1
            
        }
        
        // Check for column win
        if columnCount == sideLength {
            print("Won in column: \(columnPlayed)")
        }
        
        // Check for row win
        if rowCount == sideLength {
            print("Won in row: \(rowPlayed)")
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
    
}
