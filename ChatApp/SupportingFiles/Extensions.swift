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
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        if Calendar.current.isDateInToday(self) { formatter.dateFormat = "HH:mm" }
        else { formatter.dateFormat = "dd MMM" }
        return formatter.string(from: self)
    }
}

extension String {
    var formattedDate: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter.date(from: self)
    }
}
