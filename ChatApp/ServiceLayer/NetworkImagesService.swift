//
//  ImagesService.swift
//  ChatApp
//
//  Created by Anna Belousova on 27.04.2022.
//

import Foundation

typealias ImagesURLResult = Result<ImagesResponce, Error>

protocol INetworkImageService {
    func getImagesList(_ completion: @escaping(ImagesURLResult) -> Void)
}

class NetworkImageService: INetworkImageService {
    
    let requestSender: IRequestSender = RequestSender()
    
    func getImagesList(_ completion: @escaping(ImagesURLResult) -> Void) {
        let configuration = RequestFactory.imagesURLConfiguration()
        requestSender.send(config: configuration) { result in
           completion(result)
        }
    }
}
