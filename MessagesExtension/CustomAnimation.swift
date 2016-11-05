//
//  CustomAnimation.swift
//  ExOh
//
//  Created by Jake Hirzel on 9/27/16.
//  Copyright © 2016 Jake Hirzel. All rights reserved.
//

import UIKit

extension UIView {
    func blink() {
        UIView.animate(
            withDuration: 1.0,
            delay: 0.0,
            options: [.autoreverse, .repeat],
            animations: { [weak self] in self?.alpha = 0.0 },
            completion: { [weak self] _ in self?.alpha = 1.0 })
    }
    
    func fadeIn() {
        UIView.animate(
            withDuration: 1.0,
            delay: 0.0,
            options: UIViewAnimationOptions.curveEaseIn,
            animations: { [weak self] in self?.alpha = 1.0 },
            completion: nil)
    }
    
    func fadeOut() {
        UIView.animate(
            withDuration: 1.0,
            delay: 0.0,
            options: UIViewAnimationOptions.curveEaseOut,
            animations: { [weak self] in self?.alpha = 0.0 },
            completion: nil)
    }
    
    func pulseOnce(delay: TimeInterval) {
        UIView.animate(
            withDuration: 0.4,
            delay: delay,
            options: [.curveEaseIn, UIViewAnimationOptions.allowUserInteraction],
            animations: { [weak self] in
                self?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            },
            completion: {
                (finished: Bool) -> Void in
                UIView.animate(
                    withDuration: 0.4,
                    delay: 0.1,
                    options: [.curveEaseOut, UIViewAnimationOptions.allowUserInteraction],
                    animations: { [weak self] in
                        self?.transform = CGAffineTransform(scaleX: 1, y: 1)
                    },
                    completion: nil)
        })
    }
    
}
