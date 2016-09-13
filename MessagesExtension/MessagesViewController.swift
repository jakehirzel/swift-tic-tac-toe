//
//  MessagesViewController.swift
//  MessagesExtension
//
//  Created by Jake Hirzel on 9/7/16.
//  Copyright © 2016 Jake Hirzel. All rights reserved.
//
//  Abstract: The root view controller shown by the messages app.

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController {
    
    // MARK: Properties
    
    @IBOutlet var squareCollection: [UIButton]!
    @IBOutlet weak var boardView: UIView!
    @IBOutlet weak var expandedInstructionLabel: UILabel!
    
    // Initialize instance of MoveParser and GameLogic; set up new board
    let parser = MoveParser()
    let game = GameLogic()
    
    // MARK: MSMessagesAppViewController Lifecycle
    
    override func willBecomeActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the inactive to active state.
        // This will happen when the extension is about to present UI.
    
        // Use this method to configure the extension and restore previously stored state.
    }
    
    override func didBecomeActive(with conversation: MSConversation) {
        
        // Make instruction line visible
        if presentationStyle == .expanded && expandedInstructionLabel.isHidden == true {
            expandedInstructionLabel.isHidden = false
        }
        
        // Check for existing conversation URL
        guard conversation.selectedMessage?.url != nil else {
            
            // Set the board to ? for a new game
            for square in squareCollection {
                square.setTitle("?", for: UIControlState.normal)
            }
            
            // Claim the "X" and associate it with local UUID
            game.gameInfo.players[conversation.localParticipantIdentifier.uuidString] = "X"
            
            return
            
        }
        
        // Assign URL values to local gameInfo
        game.gameInfo = parser.decodeURL(url: (conversation.selectedMessage?.url)!)
        
        // If the second player hasn't played yet, fill UUID into Player Two and claim "Y"
        if game.gameInfo.players[conversation.localParticipantIdentifier.uuidString] == nil {
            game.gameInfo.players[conversation.localParticipantIdentifier.uuidString] = "Y"
        }
        
        // Update view to reflect previous plays
        redrawBoard(gameInfo: game.gameInfo)
        
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
//    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
//        
//        // Implement shake to undo
//        if motion == .motionShake && game.gameInfo.lastMove != nil {
//            
//            // Reset the coordinates from lastMove in the board array to ?
//            game.gameInfo.gameBoard[(game.gameInfo.lastMove?.columnPlayed)!][(game.gameInfo.lastMove?.rowPlayed)!] = "?"
//            
//            // Redraw the board from the array
//            redrawBoard(gameInfo: game.gameInfo)
//            
//            // Make lastMove = nil
//            game.gameInfo.lastMove = nil
//            
//        }
//    
//    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called before the extension transitions to a new presentation style.
        
        // Make instruction line visible
        if presentationStyle == .expanded && expandedInstructionLabel.isHidden == true {
            expandedInstructionLabel.isHidden = false
        }
        
    }
    
    // MARK: - Other Conversation Handling
    
    override func didResignActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dissmises the extension, changes to a different
        // conversation or quits Messages.
        
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
    }
   
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device.
        
        // Use this method to trigger UI updates in response to the message.
        
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user taps the send button.
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
    
        // Use this to clean up state related to the deleted message.
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called after the extension transitions to a new presentation style.
        
        // Use this method to finalize any behaviors associated with the change in presentation style.
        
    }
    
    // MARK: Button Updates
    
    // Redraw the board from gameInfo
    func redrawBoard(gameInfo: GameInfo) {
        for button in squareCollection {
            switch button.tag {
            case 0:
                button.setTitle(String(gameInfo.gameBoard[0][0]), for: UIControlState.normal)
            case 1:
                button.setTitle(String(gameInfo.gameBoard[1][0]), for: UIControlState.normal)
            case 2:
                button.setTitle(String(gameInfo.gameBoard[2][0]), for: UIControlState.normal)
            case 3:
                button.setTitle(String(gameInfo.gameBoard[0][1]), for: UIControlState.normal)
            case 4:
                button.setTitle(String(gameInfo.gameBoard[1][1]), for: UIControlState.normal)
            case 5:
                button.setTitle(String(gameInfo.gameBoard[2][1]), for: UIControlState.normal)
            case 6:
                button.setTitle(String(gameInfo.gameBoard[0][2]), for: UIControlState.normal)
            case 7:
                button.setTitle(String(gameInfo.gameBoard[1][2]), for: UIControlState.normal)
            case 8:
                button.setTitle(String(gameInfo.gameBoard[2][2]), for: UIControlState.normal)
            default:
                return
            }
        }
    }
    
    // MARK: Actions
    
    @IBAction func squareTapped(_ sender: UIButton) {
        
        let playerLetter = game.gameInfo.players[(activeConversation?.localParticipantIdentifier.uuidString)!]!
        
        let move = parser.parseCoordinates(playerLetter: playerLetter, spacePlayed: sender)
        let validMove = game.playTurn(board: &game.gameInfo.gameBoard, move: move)
        
        if validMove == true {

            // Change the label on the square
            sender.setTitle(playerLetter, for: UIControlState.normal)

            // Check for a win
            let win = game.checkForWin(board: game.gameInfo.gameBoard, move: move)
            
            // Process a win, if true
            if win == true {
                print("You win!")
            }
            
            // Add 0.5s delay to generating the message, for animations to complete
            let when = DispatchTime.now() + 0.5
            DispatchQueue.main.asyncAfter(deadline: when){
                
                // Create a message
                let message = MSMessage()
                
                // Create a layout
                let layout = MSMessageTemplateLayout()
                
                // Create and assign the image for the message bubble
                
                // Begins ImageContect and assigns actual image size in points (pixels per scale)
                UIGraphicsBeginImageContextWithOptions(CGSize(width: 150, height: 175), false, 6.0)
                
                // Creates image of full boardView at size shown and placed at x/y coords from top left within above image image size -- will have black borders if above line set to false, white if true
                self.boardView.drawHierarchy(in: CGRect(x: 0, y: 25, width: 150, height: 150), afterScreenUpdates: false)

                // Assign image to layout
                layout.image = UIGraphicsGetImageFromCurrentImageContext()
                
                // Ends ImageContext
                UIGraphicsEndImageContext()

//                self.boardView.layer.render(in: UIGraphicsGetCurrentContext()!)
//                
//                let context = UIGraphicsGetCurrentContext()
//                
//                let origin = CGPoint(
//                    x: (280 - 180) / 2,
//                    y: (280 - 180) / 2)
//                
//                UIColor.white.setFill()
//                context!.fill(CGRect(x: 0, y: 0, width: 220, height: 220))
//                
//                let newImage = UIGraphicsGetImageFromCurrentImageContext()
//                UIGraphicsEndImageContext()
//
//                layout.image = newImage
                
                // Assign the appropriate caption
                if self.game.newGame == true {
                    layout.caption = "Tap to join me in a game of ExOh! (I'm Ex and you're Oh!)"
                }
                else {
                    layout.caption = "Your turn!"
                }
                
                // Assign the layout to the message
                message.layout = layout
                
                // Assign the gameInfo URL
                message.url = self.parser.encodeURL(gameInfo: self.game.gameInfo)
                
                // If in expanded view, transition to compact view
                if self.presentationStyle == .expanded {
                    self.requestPresentationStyle(.compact)
                }
                
                // Insert the mesage into the conversation
                guard let conversation = self.activeConversation else { fatalError("Expected an active converstation!") }
                conversation.insert(message)
                
                
            }
            
        }
        
    }

}
