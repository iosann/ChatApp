//
//  ChannelStub.swift
//  UnitTestsChatApp
//
//  Created by Anna Belousova on 19.05.2022.
//

import Foundation
@testable import ChatApp

class ChannelStub {
    static let channels = [
        Channel(name: "First name", lastActivity: "2022-03-10T17:29:50Z".formattedDate),
        Channel(name: "Second name", lastActivity: "2022-05-10T17:29:50Z".formattedDate)
    ]
}
