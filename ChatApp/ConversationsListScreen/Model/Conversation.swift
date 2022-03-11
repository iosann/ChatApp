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
            Conversation(name: "Mary Adams", message: "iOS (formerly iPhone OS) is a mobile operating system", date: "2022-03-10T17:29:50Z".formattedDate, online: true, hasUnreadMessages: true),
            Conversation(name: "Thomas Smith", message: "created and developed by Apple Inc. exclusively for its hardware", date: Date(), online: true, hasUnreadMessages: false),
            Conversation(name: "Betty", message: "It is the operating system", date: Date(), online: true, hasUnreadMessages: false),
            Conversation(name: "Elizabeth Lewis", message: "that powers many of the company's mobile devices, including the iPhone and iPod Touch", date: "2022-03-11T10:29:50Z".formattedDate, online: true, hasUnreadMessages: false),
            Conversation(name: "Robert Miller", message: "It is proprietary software", date: "2022-03-10T19:29:50Z".formattedDate, online: true, hasUnreadMessages: true),
            Conversation(name: "David", message: "It is proprietary software", date: "2022-03-10T17:29:50Z".formattedDate, online: true, hasUnreadMessages: false),
            Conversation(name: "Sarah Mitchell", message: "the term also included the versions running on iPads", date: "2022-03-08T17:29:50Z".formattedDate, online: true, hasUnreadMessages: true),
            Conversation(name: "Mark", message: nil, date: nil, online: true, hasUnreadMessages: false),
            Conversation(name: "Nancy Wilson", message: nil, date: nil, online: true, hasUnreadMessages: false),
            Conversation(name: "John", message: "until the name iPadOS was introduced with version 13 in 2019", date: Date(), online: true, hasUnreadMessages: true),
            Conversation(name: "Mark Lewis", message: "although some parts", date: "2022-03-11T11:29:50Z".formattedDate, online: false, hasUnreadMessages: false),
            Conversation(name: "David", message: "Hello!", date: "2022-03-11T17:29:50Z".formattedDate, online: false, hasUnreadMessages: true),
            Conversation(name: "Betty Smith", message: "It is the world's second-most widely installed", date: "2022-03-11T17:29:50Z".formattedDate, online: false, hasUnreadMessages: true),
            Conversation(name: "Elizabeth Mitchell", message: "It is the basis", date: Date(), online: false, hasUnreadMessages: false),
            Conversation(name: "Nancy", message: "Mobile operating system, after Android. iPadOS, tvOS, and watchOS", date: Date(), online: false, hasUnreadMessages: false),
            Conversation(name: "Thomas Adams", message: "Hi!", date: "2022-03-10T17:15:50Z".formattedDate, online: false, hasUnreadMessages: false),
            Conversation(name: "Sarah", message: "It is the basis", date: "2022-03-07T17:00:50Z".formattedDate, online: false, hasUnreadMessages: false),
            Conversation(name: "Mary", message: "It is the basis for three other operating systems made by Apple", date: "2022-03-12T17:29:50Z".formattedDate, online: false, hasUnreadMessages: true),
            Conversation(name: "John Wilson", message: "iPadOS, tvOS, and watchOS", date: Date(), online: false, hasUnreadMessages: true),
            Conversation(name: "Robert", message: "It is the basis for iPadOS, tvOS, and watchOS", date: "2022-03-07T00:29:50Z".formattedDate, online: false, hasUnreadMessages: false),
            Conversation(name: "James Miller", message: nil, date: nil, online: false, hasUnreadMessages: false)
        ]
    }
}
