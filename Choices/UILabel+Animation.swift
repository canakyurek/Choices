//
//  UILabel+Animation.swift
//  Choices
//
//  Created by MertcanAkyürek on 29.07.2023.
//

import UIKit


extension UILabel {
    func animation(typing value: String, duration: Double, completion: (() -> Void)?) {
        var characterIndex = 0.0
        for letter in value {
            Timer.scheduledTimer(withTimeInterval: 0.05 * characterIndex, repeats: false) { [weak self] _ in
                guard let self = self else { return}
                text?.append(letter)
                
                if value == text {
                    completion?()
                }
            }
            characterIndex += 1
        }
    }
}
