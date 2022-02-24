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
