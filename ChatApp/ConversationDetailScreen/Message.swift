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
            Message(text: "hhhhhhhdhhhdd hhhhhhhdhhhdd hhhhhhhdhhhdd hhhhhhhdhhhdd", isIncomingMessage: true),
            Message(text: "hhhdhdhhhdd", isIncomingMessage: true),
            Message(text: "4435355353 hhhhhhhdhhhdd hhhhhhhdhhhdd", isIncomingMessage: false)
        ]
    }
}
