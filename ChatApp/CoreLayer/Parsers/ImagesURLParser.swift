//
//  ImagesURLParser.swift
//  ChatApp
//
//  Created by Anna Belousova on 27.04.2022.
//

import Foundation

protocol IParser {
    associatedtype Model
    func parse(data: Data) -> Model?
}

class ImagesURLParser: IParser {
    typealias Model = [String]
    
    func parse(data: Data) -> [String]? {
        var imagesUrl = [String]()
        do {
            let responce = try JSONDecoder().decode(ImagesResponce.self, from: data)
            responce.hits?.forEach {
 //               if let previewURL = $0.previewURL { imagesUrl.append(previewURL) }
                if let url = $0.largeImageURL { imagesUrl.append(url) }
            }
            return imagesUrl
        } catch {
            assertionFailure(error.localizedDescription)
            return imagesUrl
        }
    }
}
