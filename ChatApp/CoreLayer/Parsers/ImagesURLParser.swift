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
    typealias Model = ImagesResponce
    
    func parse(data: Data) -> Model? {
        do {
            let responce = try JSONDecoder().decode(Model.self, from: data)
            return responce
        } catch {
            assertionFailure(error.localizedDescription)
            return nil
        }
    }
}
