//
//  ButtonBehavior.swift
//  ExOh
//
//  Created by Jake Hirzel on 9/27/16.
//  Copyright © 2016 Jake Hirzel. All rights reserved.
//

import Foundation
import UIKit

enum ButtonTypes: String {
    case play = "PLAY"
    case undo = "UNDO"
    case newGame = "NEW GAME"
    case close = "CLOSE"
    case hidden = "HIDDEN"
}

class ButtonBehavior {
    
    // Refresh the buttons
    func drawButtons(buttons: [UIButton: ButtonTypes]) {
        
        for eachButton in buttons {
            
            switch eachButton.value {
            case .play:
                eachButton.key.setTitle(eachButton.value.rawValue, for: UIControlState.normal)
            case .undo:
                eachButton.key.setTitle(eachButton.value.rawValue, for: UIControlState.normal)
            case .newGame:
                eachButton.key.setTitle(eachButton.value.rawValue, for: UIControlState.normal)
            case .close:
                eachButton.key.setTitle(eachButton.value.rawValue, for: UIControlState.normal)
            case .hidden:
                eachButton.key.isHidden = true
            }
            
        }
        
    }
    
}
