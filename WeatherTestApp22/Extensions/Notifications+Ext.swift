//
//  Notifications+Ext.swift
//  WeatherTestApp22
//
//  Created by JkPhTrue Just on 13.12.2022.
//

import Foundation
import UIKit

extension Notification {
    var keyboardHeight: CGFloat? {
        guard let keyboardFrame = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return nil
        }
        let screenHeight = UIScreen.main.bounds.height
        return screenHeight - keyboardFrame.cgRectValue.minY
    }
    
    var animationDuration: CGFloat? {
        return self.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? CGFloat
    }
}
