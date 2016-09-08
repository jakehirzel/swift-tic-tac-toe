//
//  BoardMaintenance.swift
//  ExOh
//
//  Created by Jake Hirzel on 9/7/16.
//  Copyright © 2016 Jake Hirzel. All rights reserved.
//
//  Abstract: A class to handle setup, teardown, and maintenance of the game board

import Foundation

class BoardMaintenance {
    
    // Create a new game board
    func newBoard() -> [[Int]] {
        let newBoard = Array(repeating: Array(repeating: 0, count: 3), count: 3)
        return newBoard
    }

}
