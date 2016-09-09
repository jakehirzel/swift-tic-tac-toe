//
//  MoveParser.swift
//  ExOh
//
//  Created by Jake Hirzel on 9/7/16.
//  Copyright © 2016 Jake Hirzel. All rights reserved.
//
//  A Class to parse the back-and-forth between the View(s)/ViewController(s) and the GameLogic.

import Foundation
import UIKit

class MoveParser {
    
    func parseCoordinates(playerNumber: Int, spacePlayed: UIButton) -> (NewMove) {
        
        // Pull the coordinates from the User Defined Runtime Attributes for the button in IB
        let buttonTag = spacePlayed.tag
        
        // Declare variables for column and row coordinates
        var columnPlayed = 99
        var rowPlayed = 99
        
        // Parse out coordinates from keyValue
        switch buttonTag {
        case 0:
            columnPlayed = 0
            rowPlayed = 0
        case 1:
            columnPlayed = 1
            rowPlayed = 0
        case 2:
            columnPlayed = 2
            rowPlayed = 0
        case 3:
            columnPlayed = 0
            rowPlayed = 1
        case 4:
            columnPlayed = 1
            rowPlayed = 1
        case 5:
            columnPlayed = 2
            rowPlayed = 1
        case 6:
            columnPlayed = 0
            rowPlayed = 2
        case 7:
            columnPlayed = 1
            rowPlayed = 2
        case 8:
            columnPlayed = 2
            rowPlayed = 2
        default:
            print("Invalid Button Tag!")
        }
        
        // Create a NewMove
        let move = NewMove(playerNumber: playerNumber, columnPlayed: columnPlayed, rowPlayed: rowPlayed)
        
        return move
        
    }
    
}


