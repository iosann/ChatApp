//
//  ImagesResponce.swift
//  ChatApp
//
//  Created by Anna Belousova on 25.04.2022.
//

import Foundation

struct ImagesResponce: Codable {
    let hits: [Hit]
}

struct Hit: Codable {
    let largeImageURL: String?
}
