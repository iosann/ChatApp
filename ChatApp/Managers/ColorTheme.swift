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
        case .day: return UIColor(red: 0.9, green: 0.93, blue: 1, alpha: 1)
        case .night: return .darkGray
        }
    }
    var incomingMessageColor: UIColor {
        switch self {
        case .classic: return .systemBlue
        case .day: return UIColor(red: 0.902, green: 0.902, blue: 0.98, alpha: 1)
        case .night: return UIColor(red: 0, green: 0, blue: 0.4, alpha: 1)
        }
    }
    var outgoingMessageColor: UIColor {
        switch self {
        case .classic: return .lightGray
        case .day: return UIColor(red: 0.69, green: 0.878, blue: 0.902, alpha: 1)
        case .night: return UIColor(red: 0, green: 0.298, blue: 0.6, alpha: 1)
        }
    }
    var tintColor: UIColor {
        switch self {
        case .classic: return .systemBlue
        case .day: return UIColor(red: 0, green: 0, blue: 0.4, alpha: 1)
        case .night: return .black
        }
    }
    var textColor: UIColor {
        switch self {
        case .classic, .day: return .black
        case .night: return .white
        }
    }
}
    
