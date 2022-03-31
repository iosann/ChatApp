//
//  Channel.swift
//  ChatApp
//
//  Created by Anna Belousova on 29.03.2022.
//

import Foundation

 struct Channel {
     let identifier: String?
     let name: String?
     let lastMessage: String?
     let lastActivity: Date?
 }

extension Channel {
    var toDict: [String: Any] {
        return ["identifier": identifier as Any, "name": name as Any, "lastMessage": lastMessage as Any, "lastActivity": lastActivity as Any]
    }
}
