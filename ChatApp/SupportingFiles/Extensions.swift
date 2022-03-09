//
//  Extensions.swift
//  ChatApp
//
//  Created by Anna Belousova on 23.02.2022.
//

import UIKit

extension UIApplication.State {
    
    var name: String {
        switch self {
        case .active: return "active"
        case .inactive: return "inactive"
        case .background: return "background"
        @unknown default: return ""
        }
    }
}

extension Date {
    var formattedDate: String {
        guard let yesterdaysDate = Calendar.current.date(byAdding: .day, value: -1, to: Date()) else { return "" }
        let formatter = DateFormatter()
        if self > yesterdaysDate { formatter.dateFormat = "HH:mm" }
        else { formatter.dateFormat = "dd MMM" }
        return formatter.string(from: self)
    }
}

extension String {
    var formattedDate: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM YYYY"
        return formatter.date(from: self)
    }
}
