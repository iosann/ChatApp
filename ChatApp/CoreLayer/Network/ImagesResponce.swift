//
//  ImagesResponce.swift
//  ChatApp
//
//  Created by Anna Belousova on 25.04.2022.
//

import Foundation

struct ImagesResponce: Codable {
    let total, totalHits: Int?
    let hits: [Hit]?
}

struct Hit: Codable {
    let id: Int?
    let pageURL: String?
    let type, tags: String?
    let previewURL: String?
    let largeImageURL: String?
}
