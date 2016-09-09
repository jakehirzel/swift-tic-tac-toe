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
        
        let columnPlayed = 0
        let rowPlayed = 0
        let move = NewMove(playerNumber: playerNumber, columnPlayed: columnPlayed, rowPlayed: rowPlayed)
        
        return move
        
    }
    
}


