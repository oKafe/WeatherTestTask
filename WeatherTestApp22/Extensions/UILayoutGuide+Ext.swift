//
//  UILayoutGuide+Ext.swift
//  WeatherTestApp22
//
//  Created by JkPhTrue Just on 13.12.2022.
//

import Foundation
import UIKit

extension UILayoutGuide {
    internal var heightConstraint: NSLayoutConstraint? {
        return owningView?.constraints.first {
            $0.firstItem as? UILayoutGuide == self && $0.firstAttribute == .height
        }
    }
}
