//
//  RequestConfiguration.swift
//  ChatApp
//
//  Created by Anna Belousova on 27.04.2022.
//

import Foundation

struct RequestConfiguration<Parser> where Parser: IParser {
    let request: IRequest
    let parser: Parser
}

struct RequestFactory {
    
    static func imagesURLConfiguration() -> RequestConfiguration<ImagesURLParser> {
        return RequestConfiguration<ImagesURLParser>(request: ImageRequest(), parser: ImagesURLParser())
    }
}
