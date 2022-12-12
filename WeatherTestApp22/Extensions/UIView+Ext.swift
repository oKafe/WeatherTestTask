//
//  UIView+Ext.swift
//  WeatherTestApp22
//
//  Created by JkPhTrue Just on 13.12.2022.
//

import Foundation
import UIKit


extension UIView {
    private enum Identifiers {
        static var usingSafeArea = "KeyboardLayoutGuideUsingSafeArea"
        static var notUsingSafeArea = "KeyboardLayoutGuide"
    }

    var kboardLayoutGuide: UILayoutGuide {
        getOrCreateKeyboardLayoutGuide(identifier: Identifiers.usingSafeArea, usesSafeArea: true)
    }

    public var keyboardLayoutGuideNoSafeArea: UILayoutGuide {
        getOrCreateKeyboardLayoutGuide(identifier: Identifiers.notUsingSafeArea, usesSafeArea: false)
    }

    private func getOrCreateKeyboardLayoutGuide(identifier: String, usesSafeArea: Bool) -> UILayoutGuide {
        if let existing = layoutGuides.first(where: { $0.identifier == identifier }) {
            return existing
        }
        let lGuide = KeyboardLayoutGuide()
        lGuide.usesSafeArea = usesSafeArea
        lGuide.identifier = identifier
        addLayoutGuide(lGuide)
        lGuide.setUp()
        return lGuide
    }
}
