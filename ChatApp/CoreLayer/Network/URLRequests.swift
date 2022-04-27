//
//  ImageRequest.swift
//  ChatApp
//
//  Created by Anna Belousova on 27.04.2022.
//

import UIKit

typealias ImagesURLResult = Result<[String], Error>
typealias ImageResult = Result<UIImage, Error>

protocol IRequest {
    var urlRequest: URLRequest? { get }
}

class ImageListRequest: IRequest {
    
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

class ImageRequest: IRequest {

    var urlString: String?
    var urlRequest: URLRequest? {
        guard let urlString = urlString, let url = URL(string: urlString) else { return nil }
        return URLRequest(url: url, timeoutInterval: 10)
    }
    
    init(urlString: String?) {
        self.urlString = urlString
    }
}
