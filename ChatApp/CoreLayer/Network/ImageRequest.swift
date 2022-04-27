//
//  ImageRequest.swift
//  ChatApp
//
//  Created by Anna Belousova on 27.04.2022.
//

import Foundation

typealias ImagesURLResult = Result<[String], Error>

protocol IRequest {
    var urlRequest: URLRequest? { get }
}

class ImageRequest: IRequest {
    
    var urlRequest: URLRequest? {
        guard let baseUrl = URL(string: URLConstants.pixabay) else { return nil }
        let queryItems = [
            URLQueryItem(name: "key", value: Tokens.pixabay),
            URLQueryItem(name: "category", value: "animals"),
            URLQueryItem(name: "per_page", value: "100")
        ]
        var urlComponents = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = queryItems
        guard let url = urlComponents?.url else { return nil }
        
        return URLRequest(url: url, timeoutInterval: 10)
    }
}
