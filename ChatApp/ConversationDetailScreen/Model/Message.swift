//
//  Message.swift
//  ChatApp
//
//  Created by Anna Belousova on 10.03.2022.
//

import Foundation

protocol MessageCellConfiguration: AnyObject {
    var text: String? { get set }
}

class Message: MessageCellConfiguration {
    var text: String?
    var isIncomingMessage: Bool
    
    init(text: String?, isIncomingMessage: Bool) {
        self.text = text
        self.isIncomingMessage = isIncomingMessage
    }
    
    static var allMessages: [Message] {
        return [
            Message(text: "Two-factor authentication is an option in iOS to ensure that even if an unauthorized person knows an Apple ID and password combination, they cannot gain access to the account.", isIncomingMessage: true),
            Message(text: "😃", isIncomingMessage: true),
            Message(text: "It works by requiring not only the Apple ID and password", isIncomingMessage: false),
            Message(text: "but also a verification code that is sent to an iDevice or mobile phone number that is already known to be trusted", isIncomingMessage: false),
            Message(text: "If an unauthorized user attempts to sign in using another user's Apple ID", isIncomingMessage: true),
            Message(text: "the owner of the Apple ID receives a notification that allows them to deny access to the unrecognized device.", isIncomingMessage: false),
            Message(text: "😃", isIncomingMessage: true)
        ]
    }
}
