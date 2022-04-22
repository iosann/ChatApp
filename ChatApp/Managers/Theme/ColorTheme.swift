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
        case .classic: return UIColor(red: 0.9, green: 0.93, blue: 1, alpha: 1)
        case .day: return UIColor(red: 1, green: 0.894, blue: 0.89, alpha: 1)
        case .night: return UIColor(red: 0.188, green: 0.176, blue: 0.18, alpha: 1)
        }
    }
    var incomingMessageColor: UIColor {
        switch self {
        case .classic: return UIColor(red: 0.69, green: 0.878, blue: 0.902, alpha: 1)
        case .day: return UIColor(red: 0.678, green: 0.42, blue: 0.514, alpha: 1)
        case .night: return UIColor(red: 0.435, green: 0.471, blue: 0.557, alpha: 1)
        }
    }
    var outgoingMessageColor: UIColor {
        switch self {
        case .classic: return UIColor(red: 0.608, green: 0.843, blue: 0.965, alpha: 1)
        case .day: return UIColor(red: 0.435, green: 0.569, blue: 0.702, alpha: 1)
        case .night: return UIColor(red: 0.255, green: 0.243, blue: 0.247, alpha: 1)
        }
    }
    var tintColor: UIColor {
        switch self {
        case .classic: return UIColor(red: 0, green: 0, blue: 0.4, alpha: 1)
        case .day: return UIColor(red: 0.18, green: 0.11, blue: 0.13, alpha: 1)
        case .night: return .white
        }
    }
    var textColor: UIColor {
        switch self {
        case .classic, .day: return .black
        case .night: return .white
        }
    }
}
    
