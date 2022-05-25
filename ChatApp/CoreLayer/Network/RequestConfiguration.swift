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
        return RequestConfiguration<ImagesURLParser>(request: ImageListRequest(), parser: ImagesURLParser())
    }
    
    static func imageConfiguration(urlString: String?) -> RequestConfiguration<ImageParser> {
        return RequestConfiguration<ImageParser>(request: ImageRequest(urlString: urlString), parser: ImageParser())
    }
}
