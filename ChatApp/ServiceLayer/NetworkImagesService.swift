//
//  ImagesService.swift
//  ChatApp
//
//  Created by Anna Belousova on 27.04.2022.
//

import Foundation

protocol INetworkImagesService {
    func getImagesList(_ completion: @escaping(ImagesURLResult) -> Void)
}

class NetworkImagesService: INetworkImagesService {
    
    private let configuration = RequestFactory.imagesURLConfiguration()
    private let requestSender: IRequestSender = RequestSender()
    
    func getImagesList(_ completion: @escaping(ImagesURLResult) -> Void) {
        requestSender.send(config: configuration) { result in
           completion(result)
        }
    }
}
