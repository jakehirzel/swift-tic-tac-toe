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
    @IBOutlet weak var instructionLabel: UILabel!
    
    @IBOutlet weak var buttonOne: UIButton!
    @IBOutlet weak var buttonTwo: UIButton!
    @IBOutlet weak var buttonThree: UIButton!

    
    // Initialize instance of MoveParser, GameLogic, and ButtonBehavior; set up new board
    let parser = MoveParser()
    var game = GameLogic()
    var buttonBehavior = ButtonBehavior()
        
    // Create a Bool to track when a user presses "Send"
    var didYouSend = false
    
    // Track the message session
    var currentSession: MSSession?
    
    // MARK: MSMessagesAppViewController Lifecycle
    
    override func didBecomeActive(with conversation: MSConversation) {
        
        loadGame(conversation: conversation)
        
        // Disable undo and change instructionLabel and buttons if already played
        if game.gameInfo.lastMove?.playerUUID == conversation.localParticipantIdentifier.uuidString {
            didYouSend = true
            instructionLabel.text = "Already played!"
            buttonBehavior.drawButtons(buttons: [buttonOne: .close, buttonTwo: .hidden, buttonThree: .hidden])
        }
        
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user taps the send button.
        
        // Set didYouSend to true
        didYouSend = true
        
        // Dismiss the app
        dismiss()
        
    }
    
    // MARK: - Other View/Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the inactive to active state.
        // This will happen when the extension is about to present UI.
        
        // Use this method to configure the extension and restore previously stored state.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called before the extension transitions to a new presentation style.
    }
    
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called after the extension transitions to a new presentation style.
        
        // Use this method to finalize any behaviors associated with the change in presentation style.
        
    }
    
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
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
    
        // Use this to clean up state related to the deleted message.
    }
    
    override func willSelect(_ message: MSMessage, conversation: MSConversation) {
        // Handle the case of message being selected in the transcript when the extension is already loaded
        
        // This doesn't seem to work -- gets called on send rather than on selection of message
        
    }
    
    // MARK: Convenience
    
    // Load a game in a conversation
    func loadGame(conversation: MSConversation) {
        
        // Check for existing conversation URL
        guard conversation.selectedMessage?.url != nil else {
            
            // Set the board to ? for a new game and make sure all letters are white
            for square in squareCollection {
                square.setTitle("?", for: UIControlState.normal)
                square.setTitleColor(UIColor.white, for: UIControlState.normal)
            }
            
            // Set the buttons for regular play
            buttonBehavior.drawButtons(buttons: [buttonOne: .play, buttonTwo: .undo, buttonThree: .hidden])
            
            // Claim the "X" and associate it with local UUID
            game.gameInfo.players[conversation.localParticipantIdentifier.uuidString] = "X"
            
            return
            
        }
        
        // Otherwise, overwrite local gameInfo with URL values
        game.gameInfo = parser.decodeURL(url: (conversation.selectedMessage?.url)!)
        
        // Redraw the board to reflect previous plays
        redrawBoard(gameInfo: game.gameInfo)
        
        // If the game is won, show the win, and adjust buttons to allow for a new game
        if game.gameInfo.gameWon.isWin == true {
            
            if game.gameInfo.gameWon.winType == "draw" {
                
                // Update instructionLabel
                instructionLabel.text = "It's a draw!"
                
            }
                
            else {
                
                // Parse the button ids for the win
                let winButtonIDs = parser.parseWinButtons(winType: (game.gameInfo.gameWon.winType!), winIndex: game.gameInfo.gameWon.winIndex)
                
                // Draw the "win" in black
                drawTheWin(buttonOne: winButtonIDs.buttonTagOne!, buttonTwo: winButtonIDs.buttonTagTwo!, buttonThree: winButtonIDs.buttonTagThree!)
                
                // Update the instructionLabel
                instructionLabel.text = "Game Over!"
                
            }
            
            // Update the buttons
            buttonBehavior.drawButtons(buttons: [buttonOne: .newGame, buttonTwo: .close, buttonThree: .hidden])
            
        }
            
            // Otherwise get ready for another round
        else {
            
            // If this is player two and the first play, fill UUID into players, claim "O", set newGame to false
            if game.gameInfo.players[conversation.localParticipantIdentifier.uuidString] == nil {
                game.gameInfo.players[conversation.localParticipantIdentifier.uuidString] = "O"
                game.gameInfo.newGame = false
            }
            
            // Assign the session info from the incoming message
            currentSession = conversation.selectedMessage?.session
            
            // Set the buttons for regular play
            buttonBehavior.drawButtons(buttons: [buttonOne: .play, buttonTwo: .undo, buttonThree: .hidden])
            
        }
        
    }
    
    // Redraw the board from gameInfo
    func redrawBoard(gameInfo: GameInfo) {
        for button in squareCollection {
            
            // Reset color to white (for case of undo before win is sent)
            button.setTitleColor(UIColor.white, for: UIControlState.normal)
            
            // Reset button title letter to match gameBoard array values
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
    
    // Update the instructionLabel with a fadeOut() / fadeIn()
    func crossfadeLabel(label: UILabel, newText: String) {
        
        // Fade out the label
        label.fadeOut()
        
        // Update the text
        label.text = newText
        
        // Fade in the label
        label.fadeIn()
        
    }
    
    // Draw the win
    func drawTheWin(buttonOne: Int, buttonTwo: Int, buttonThree: Int) {
        for button in squareCollection {
            switch button.tag {
            case buttonOne:
                button.setTitleColor(UIColor.black, for: UIControlState.normal)
            case buttonTwo:
                button.setTitleColor(UIColor.black, for: UIControlState.normal)
            case buttonThree:
                button.setTitleColor(UIColor.black, for: UIControlState.normal)
            default:
                continue
            }
        }
    }
    
    // Create a message and insert in the conversation
    func createNewMessage() {
        
        // Add 0.5s delay to generating the message, for animations to complete
        let when = DispatchTime.now() + 0.5
        DispatchQueue.main.asyncAfter(deadline: when) { [unowned self] in
            
            // Create a message session if one does not exist
            if self.currentSession == nil {
                self.currentSession = MSSession()
            }
            
            // Create a message
            let message = MSMessage(session: self.currentSession!)
            
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
            
            // Assign the appropriate caption
            if self.game.gameInfo.newGame == true {
                layout.caption = "Tap to join me in a game of ExOh! (I'm Ex and you're Oh!)"
                self.game.gameInfo.newGame = false
            }
            else if self.game.gameInfo.gameWon.isWin == true {
                layout.caption = "I win!"
            }
            else {
                layout.caption = "$\(self.activeConversation!.localParticipantIdentifier.uuidString) played. Your turn!"
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
            conversation.insert(message, completionHandler: nil)
        
        }
    
    }

    // MARK: Actions

    @IBAction func squareTapped(_ sender: UIButton) {
        
        // Get player UUID
        let playerUUID = activeConversation?.localParticipantIdentifier.uuidString
    
        // Get playerLetter from players array
        let playerLetter = game.gameInfo.players[playerUUID!]
        
        // Parse the move into board-readable coordinates
        let move = parser.parseCoordinates(playerUUID: playerUUID!, playerLetter: playerLetter!, spacePlayed: sender)

        // Play the turn and record any valid (i.e. true) moves on the board and in lastMove
        let validMove = game.playTurn(board: &game.gameInfo.gameBoard, move: move)
        
//        // If in expanded view, transition to compact view
//        if self.presentationStyle == .expanded {
//            self.requestPresentationStyle(.compact)
//        }
    
        // Update the view for a play or a win
        if validMove.validPlay == true {

            // Change the label on the square
            sender.setTitle(playerLetter, for: UIControlState.normal)

            // Check for a win and assign to
            game.gameInfo.gameWon = game.checkForWin(board: game.gameInfo.gameBoard, move: move)
            
            // Process a win, if true
            if game.gameInfo.gameWon.isWin == true {
                
                if game.gameInfo.gameWon.winType == "draw" {
                    
                    // Update instructionLabel
                    crossfadeLabel(label: instructionLabel, newText: "It's a draw! Press PLAY to commit your move!")
                    print("It's a draw!")
                    
                }
                    
                else {
                    
                    // Parse the button ids for the win
                    let winButtonIDs = parser.parseWinButtons(winType: (game.gameInfo.gameWon.winType!), winIndex: game.gameInfo.gameWon.winIndex)
                    
                    // Draw the "win" in black
                    drawTheWin(buttonOne: winButtonIDs.buttonTagOne!, buttonTwo: winButtonIDs.buttonTagTwo!, buttonThree: winButtonIDs.buttonTagThree!)
                    
                    // Update the instructionLabel
                    crossfadeLabel(label: instructionLabel, newText: "You win! Press PLAY to commit your move!")
                    print("You win!")
                    
                }
                
                // Update the buttons
                buttonBehavior.drawButtons(buttons: [buttonOne: .newGame, buttonTwo: .close, buttonThree: .hidden])
                
            }
            
            // Otherwise update the instructionLabel and pulse the PLAY button
            else {
                crossfadeLabel(label: instructionLabel, newText: "Press PLAY to commit your move.")
                buttonOne.pulseOnce(delay: 0.5)
                
            }
            
        }
        
//        // Otherwise change the instructionLabel to show the error
//        else {
//            crossfadeLabel(label: instructionLabel, newText: validMove.instructionalMessage)
//        }
        
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        
        if sender.titleLabel?.text == "PLAY" {
            
            if game.gameInfo.lastMove != nil && didYouSend == false {
                                
                // Insert the message into the conversation
                createNewMessage()
                
                // Change instructions to prompt to send
                crossfadeLabel(label: instructionLabel, newText: "Send the message to play your turn.")

            }

            else {
                return
            }
            
        }
            
        else if sender.titleLabel?.text == "UNDO" {
            
            // Reject if you already sent the message
            guard didYouSend == false else {
                print("You already hit send!")
                crossfadeLabel(label: instructionLabel, newText: "You already hit send!")
                return
            }
            
            // Undo the play
            game.undoPlay()
            
            // Redraw the board from the array
            redrawBoard(gameInfo: game.gameInfo)
            
            // Update instuctionLabel
            crossfadeLabel(label: instructionLabel, newText: "Select another move.")
            
        }
            
        else if sender.titleLabel?.text == "NEW GAME" {
            
            // Reset the GameInfo
            game = GameLogic()
            
            // Reset the URL
            activeConversation?.selectedMessage?.url = nil
            
            // Load a new game
            guard activeConversation != nil else {
                return
            }
            loadGame(conversation: activeConversation!)
            
            // Update instruction label
            crossfadeLabel(label: instructionLabel, newText: "Tap a \"Square\" to select your move.")
            
        }
            
        else if sender.titleLabel?.text == "CLOSE" {
            
            // Dismiss the app
            dismiss()
            
        }
            
        else {
            return
        }
        
    }

    
    @IBAction func longTapToUndo(_ sender: UILongPressGestureRecognizer) {
        
        if sender.state == UIGestureRecognizerState.ended {
            
            // Reject if you already sent the message
            guard didYouSend == false else {
                print("You already hit send!")
                return
            }
            
            // Undo the play
            game.undoPlay()
            
            // Redraw the board from the array
            redrawBoard(gameInfo: game.gameInfo)
            
            // Update instuctionLabel
            crossfadeLabel(label: instructionLabel, newText: "Select another move.")
            
//            // Clear the unsent message
//            let message = MSMessage()
//            activeConversation?.insert(message, completionHandler: nil)
            
//            // Refresh the message
//            createNewMessage()
            
//            // Create a text message
//            activeConversation?.insertText("Hmmmm. Thinking!", completionHandler: nil)

        }
    }
}
