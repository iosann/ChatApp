//
//  ImageRequest.swift
//  ChatApp
//
//  Created by Anna Belousova on 27.04.2022.
//

import UIKit

protocol IRequest {
    var urlRequest: URLRequest? { get }
}

extension URLConstants {
    static let pixabay = "https://pixabay.com/api/"
    
    enum QueryItemName: String {
        case key = "key"
        case category = "category"
        case perPage = "per_page"
    }
    
    enum QueryItemValue: String {
        case category = "animals"
        case perPage = "100"
    }
}

class ImageListRequest: IRequest {
    
    var urlRequest: URLRequest? {
        guard let baseUrl = URL(string: URLConstants.pixabay) else { return nil }
        let queryItems = [
            URLQueryItem(name: URLConstants.QueryItemName.key.rawValue, value: Tokens.pixabay),
            URLQueryItem(name: URLConstants.QueryItemName.category.rawValue, value: URLConstants.QueryItemValue.category.rawValue),
            URLQueryItem(name: URLConstants.QueryItemName.perPage.rawValue, value: URLConstants.QueryItemValue.perPage.rawValue)
        ]
        var urlComponents = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = queryItems
        guard let url = urlComponents?.url else { return nil }
        
        return URLRequest(url: url)
    }
}
