//
//  ColorTheme.swift
//  ChatApp
//
//  Created by Anna Belousova on 16.03.2022.
//

import UIKit

struct ColorTheme {
    let name: String
    let backgroundColor: UIColor
    let incomingMessageColor: UIColor
    let outgoingMessageColor: UIColor
    let isCurrentTheme: Bool
    
    static var allThemes: [ColorTheme] {
        return [
            ColorTheme(name: "Classic", backgroundColor: .white, incomingMessageColor: .systemBlue, outgoingMessageColor: .systemGray, isCurrentTheme: true),
            ColorTheme(name: "Day", backgroundColor: .lightGray, incomingMessageColor: .systemGreen, outgoingMessageColor: .systemYellow, isCurrentTheme: false),
            ColorTheme(name: "Night", backgroundColor: .darkGray, incomingMessageColor: .blue, outgoingMessageColor: .systemPink, isCurrentTheme: false)
        ]
    }
}
