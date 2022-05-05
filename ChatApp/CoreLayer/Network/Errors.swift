//
//  Errors.swift
//  ChatApp
//
//  Created by Anna Belousova on 25.04.2022.
//

import UIKit

enum ServiceError: Error {
    case `default`
}

enum NetworkError: String, Error {
    case sessionError = "Session error"
    case dataError = "Data error"
    case statusCode = "Status code"
    case invalidURL = "Invalid URL"
    case decodingError = "Decoding error"
}
