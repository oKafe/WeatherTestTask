//
//  String+Ext.swift
//  WeatherTestApp22
//
//  Created by JkPhTrue Just on 12.12.2022.
//

import Foundation

extension String {
    var iconLinkFromName: String {
        return "http://openweathermap.org/img/wn/\(self)@2x.png"
    }
}
