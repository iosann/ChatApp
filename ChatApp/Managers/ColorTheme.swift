//
//  ColorTheme.swift
//  ChatApp
//
//  Created by Anna Belousova on 16.03.2022.
//

import UIKit

enum ColorTheme: Int, CaseIterable {
    case classic, day, night
    
    var name: String {
        switch self {
        case .classic: return "Classic"
        case .day: return "Day"
        case .night: return "Night"
        }
    }
    var backgroundColor: UIColor {
        switch self {
        case .classic: return .white
        case .day: return .lightGray
        case .night: return .darkGray
        }
    }
    var incomingMessageColor: UIColor {
        switch self {
        case .classic: return .systemRed
        case .day: return UIColor(red: 0.902, green: 0.902, blue: 0.98, alpha: 1)
        case .night: return .blue
        }
    }
    var outgoingMessageColor: UIColor {
        switch self {
        case .classic: return .systemGray
        case .day: return UIColor(red: 0.69, green: 0.878, blue: 0.902, alpha: 1)
        case .night: return .systemPink
        }
    }
    var barStyle: UIBarStyle {
        switch self {
        case .classic, .day: return .default
        case .night: return .black
        }
    }
    var tintColor: UIColor {
        switch self {
        case .classic: return .systemBlue
        case .day: return .systemGray
        case .night: return .black
        }
    }
}
    
