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
import Messages

class MoveParser {
    
    // Create a NewMove from info passed in by the button
    
    func parseCoordinates(playerUUID: String, playerLetter: String, spacePlayed: UIButton) -> (NewMove) {
        
        // Pull the tag for the button in IB
        let buttonTag = spacePlayed.tag
        
        // Declare variables for column and row coovarnates
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
        let move = NewMove(playerUUID: playerUUID, playerLetter: playerLetter, columnPlayed: columnPlayed, rowPlayed: rowPlayed)
        
        return move
        
    }
    
    // Encode a URL from GameInfo to populate outgoing message.url using URLComponents()
    
    func encodeURL(gameInfo: GameInfo) -> URL {
        
        // Create empty instance of URLComponents()
        var urlComponents = URLComponents()
        
        // Set base values
        urlComponents.scheme = "data"
        urlComponents.host = "www.jakehirzel.com"
        
        // Create the query string and add square values
        urlComponents.queryItems = [URLQueryItem(name: "squareZero", value: String(describing: gameInfo.gameBoard[0][0]))]
        urlComponents.queryItems?.append(URLQueryItem(name: "squareOne", value: String(describing: gameInfo.gameBoard[1][0])))
        urlComponents.queryItems?.append(URLQueryItem(name: "squareTwo", value: String(describing: gameInfo.gameBoard[2][0])))
        urlComponents.queryItems?.append(URLQueryItem(name: "squareThree", value: String(describing: gameInfo.gameBoard[0][1])))
        urlComponents.queryItems?.append(URLQueryItem(name: "squareFour", value: String(describing: gameInfo.gameBoard[1][1])))
        urlComponents.queryItems?.append(URLQueryItem(name: "squareFive", value: String(describing: gameInfo.gameBoard[2][1])))
        urlComponents.queryItems?.append(URLQueryItem(name: "squareSix", value: String(describing: gameInfo.gameBoard[0][2])))
        urlComponents.queryItems?.append(URLQueryItem(name: "squareSeven", value: String(describing: gameInfo.gameBoard[1][2])))
        urlComponents.queryItems?.append(URLQueryItem(name: "squareEight", value: String(describing: gameInfo.gameBoard[2][2])))
        
        // Add newGame
        urlComponents.queryItems?.append(URLQueryItem(name: "newGame", value: String(describing: gameInfo.newGame)))
        
        // Add gameWon
        urlComponents.queryItems?.append(URLQueryItem(name: "gameWon", value: String(describing: gameInfo.gameWon.isWin)))
        
        // If gameWon is true, add winType and winIndex
        if gameInfo.gameWon.isWin == true {
            urlComponents.queryItems?.append(URLQueryItem(name: "winType", value: gameInfo.gameWon.winType))
            if let winIndex = gameInfo.gameWon.winIndex {
                urlComponents.queryItems?.append(URLQueryItem(name: "winIndex", value: String(describing: winIndex)))
            }
        }
        
        // Add last move UUID
        urlComponents.queryItems?.append(URLQueryItem(name: "lastMoveUUID", value: gameInfo.lastMove!.playerUUID))
        
        // Add last move letter to the query
        urlComponents.queryItems?.append(URLQueryItem(name: "lastMoveLetter", value: gameInfo.lastMove!.playerLetter))
        
        // Add last move column
        urlComponents.queryItems?.append(URLQueryItem(name: "lastMoveColumn", value: String(describing: gameInfo.lastMove!.columnPlayed)))
        
        // Add last move row
        urlComponents.queryItems?.append(URLQueryItem(name: "lastMoveRow", value: String(describing: gameInfo.lastMove!.rowPlayed)))
        
        // Add the players to the query
        for player in gameInfo.players {
            urlComponents.queryItems?.append(URLQueryItem(name: player.key, value: player.value))
        }
        
        // Return the URL
        return urlComponents.url!
        
    }
    
    // Decode incoming message.url and return loadable GameInfo
    
    func decodeURL(url: URL) -> GameInfo {
        
        // Initialize instance of URLComponents() passing in an existing URL
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        
        // Initialize a new GameInfo struct to hold the URL info
        var gameInfo = GameInfo()
        
        // Create a NewMove insance to store last move data
        var lastMove = NewMove()
        
        // Iterate through queryItems and assign appropriate values to the GameInfo struct
        for (queryItem) in (urlComponents?.queryItems?.enumerated())! {
            
            switch queryItem.element.name {
            case "squareZero":
                gameInfo.gameBoard[0][0] = queryItem.element.value!
            case "squareOne":
                gameInfo.gameBoard[1][0] = queryItem.element.value!
            case "squareTwo":
                gameInfo.gameBoard[2][0] = queryItem.element.value!
            case "squareThree":
                gameInfo.gameBoard[0][1] = queryItem.element.value!
            case "squareFour":
                gameInfo.gameBoard[1][1] = queryItem.element.value!
            case "squareFive":
                gameInfo.gameBoard[2][1] = queryItem.element.value!
            case "squareSix":
                gameInfo.gameBoard[0][2] = queryItem.element.value!
            case "squareSeven":
                gameInfo.gameBoard[1][2] = queryItem.element.value!
            case "squareEight":
                gameInfo.gameBoard[2][2] = queryItem.element.value!
            case "newGame":
                gameInfo.newGame = Bool(queryItem.element.value!)!
            case "gameWon":
                gameInfo.gameWon.isWin = Bool(queryItem.element.value!)!
            case "winType":
                gameInfo.gameWon.winType = queryItem.element.value!
            case "winIndex":
                gameInfo.gameWon.winIndex = Int(queryItem.element.value!)!
            case "lastMoveUUID":
                lastMove.playerUUID = queryItem.element.value!
            case "lastMoveLetter":
                lastMove.playerLetter = queryItem.element.value!
            case "lastMoveColumn":
                lastMove.columnPlayed = Int(queryItem.element.value!)!
            case "lastMoveRow":
                lastMove.rowPlayed = Int(queryItem.element.value!)!
            default:
                gameInfo.players[queryItem.element.name] = queryItem.element.value
            }
            
        }
        
        // Assign lastMove move to gameInfo
        gameInfo.lastMove = lastMove
        
        // Return GameInfo
        return gameInfo
        
    }
    
    // Change checkForWin output into button IDs
    
    func parseWinButtons(winType: String, winIndex: Int?) -> (buttonTagOne: Int?, buttonTagTwo: Int?, buttonTagThree: Int?) {
        switch winType {
        case "column":
            
            switch winIndex {
            case 0?:
                return (0, 3, 6)
            case 1?:
                return (1, 4, 7)
            case 2?:
                return (2, 5, 8)
            default:
                return (nil, nil, nil)
            }
            
        case "row":
            
            switch winIndex {
            case 0?:
                return (0, 1, 2)
            case 1?:
                return (3, 4, 5)
            case 2?:
                return (6, 7, 8)
            default:
                return (nil, nil, nil)
            }
            
        case "forwardDiagonal":
            return (6, 4, 2)
        case "backwardDiagonal":
            return (0, 4, 8)
        default:
            return (nil, nil, nil)
        }
    }
    
}


