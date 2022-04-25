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

enum NetworkError: Error {
    case sessionError(Error)
    case dataError(Error)
    case statusCode(Int)
    case invalidURL
    case decodingError
}
