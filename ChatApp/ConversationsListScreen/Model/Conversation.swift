//
//  Conversation.swift
//  ChatApp
//
//  Created by Anna Belousova on 10.03.2022.
//

import Foundation

protocol ConversationCellConfiguration: AnyObject {
    var name: String? { get set }
    var message: String? { get set }
    var date: Date? { get set }
    var online: Bool { get set }
    var hasUnreadMessages: Bool { get set }
}

class Conversation: ConversationCellConfiguration {
    var name: String?
    var message: String?
    var date: Date?
    var online: Bool
    var hasUnreadMessages: Bool
    
    init(name: String?, message: String?, date: Date?, online: Bool, hasUnreadMessages: Bool) {
        self.name = name
        self.message = message
        self.date = date
        self.online = online
        self.hasUnreadMessages = hasUnreadMessages
    }
    
    static var allContacts: [Conversation] {
        return [
            Conversation(name: "Anna Svetolunnaya", message: "Hi! Hi! Hi!", date: "20220201".formattedDate, online: true, hasUnreadMessages: true),
            Conversation(name: "Anna Svetolunnaya 2", message: nil, date: Date(), online: false, hasUnreadMessages: false),
            Conversation(name: "Anna Svetolunnaya 3", message: nil, date: Date(), online: true, hasUnreadMessages: false),
            Conversation(name: "Anna Svetolunnaya 4", message: "Hi! Hi! Hi!", date: Date(), online: false, hasUnreadMessages: false)
        ]
    }
}
