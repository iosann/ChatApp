//
//  Message.swift
//  ChatApp
//
//  Created by Anna Belousova on 29.03.2022.
//

import Firebase

struct Message {
    let content: String?
    let created: Date?
    let senderId: String?
    let senderName: String?
    let identifier: String?
}

extension Message {
    var toDict: [String: Any] {
        return ["content": content as Any, "created": Timestamp(date: created ?? Date()), "senderID": senderId as Any, "senderName": senderName as Any]
    }
}
