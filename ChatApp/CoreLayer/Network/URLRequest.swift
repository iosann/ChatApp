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
        guard let stringUrl = Bundle.main.object(forInfoDictionaryKey: "pixabay_url") as? String,
               let baseUrl = URL(string: stringUrl),
               let token = Bundle.main.object(forInfoDictionaryKey: "pixabay_token") as? String
         else { return nil }
        let queryItems = [
            URLQueryItem(name: URLConstants.QueryItemName.key.rawValue, value: token),
            URLQueryItem(name: URLConstants.QueryItemName.category.rawValue, value: URLConstants.QueryItemValue.category.rawValue),
            URLQueryItem(name: URLConstants.QueryItemName.perPage.rawValue, value: URLConstants.QueryItemValue.perPage.rawValue)
        ]
        var urlComponents = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = queryItems
        urlComponents?.scheme = "https"
        guard let url = urlComponents?.url else { return nil }
        
        return URLRequest(url: url)
    }
}

class ImageRequest: IRequest {

    var urlString: String?
    var urlRequest: URLRequest? {
        guard let urlString = urlString, let url = URL(string: urlString) else { return nil }
        return URLRequest(url: url)
    }
    
    init(urlString: String?) {
        self.urlString = urlString
    }
}
