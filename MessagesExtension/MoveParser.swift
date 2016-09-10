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
    
    // Create a NewMove from info passed in by the button
    
    func parseCoordinates(playerLetter: String, spacePlayed: UIButton) -> (NewMove) {
        
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
        let move = NewMove(playerLetter: playerLetter, columnPlayed: columnPlayed, rowPlayed: rowPlayed)
        
        return move
        
    }
    
    // Encode a URL from GameInfo to populate outgoing message.url using URLComponents()
    
    func encodeURL(gameInfo: GameInfo) -> URL {
        
        // Create empty instance of URLComponents()
        var urlComponents = URLComponents()
        
        // Set base values
        urlComponents.scheme = "https"
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
        
        // Add the players to the query
        for player in gameInfo.players {
            urlComponents.queryItems?.append(URLQueryItem(name: player.key, value: player.value))
        }
        
        // Return the URL
        return urlComponents.url!
        
//        let escapedAddress = String(describing: gameInfo).addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
//        let prefixForURL = "https://www.jakehirzel.com?"
//        let stringURL = prefixForURL + escapedAddress
//        let returnURL = URL(string: stringURL)
//        return returnURL!
        
    }
    
    // Decode incoming message.url and return loadable GameInfo
    
    func decodeURL(url: URL) -> GameInfo {
        
        // Initialize instance of URLComponents() passing in an existing URL
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        
        // Initialize a new GameInfo struct to hold the URL info
        var gameInfo = GameInfo()
        
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
            default:
                gameInfo.players[queryItem.element.name] = queryItem.element.value
            }
            
        }
        
        // Return GameInfo
        return gameInfo
        
    }
    
}


