//
//  ImagesService.swift
//  ChatApp
//
//  Created by Anna Belousova on 27.04.2022.
//

import UIKit

typealias ImagesURLResult = Result<ImagesResponce, Error>
typealias ImageResult = Result<UIImage, Error>

protocol INetworkImageService {
    func getImagesList(_ completion: @escaping(ImagesURLResult) -> Void)
    func getImage(from urlString: String?, _ completion: @escaping(ImageResult) -> Void)
}

class NetworkImageService: INetworkImageService {
    
    let requestSender: IRequestSender = RequestSender()
    
    func getImagesList(_ completion: @escaping(ImagesURLResult) -> Void) {
        let configuration = RequestFactory.imagesURLConfiguration()
        requestSender.send(config: configuration) { result in
           completion(result)
        }
    }
    
    func getImage(from urlString: String?, _ completion: @escaping(ImageResult) -> Void) {
        let configuration = RequestFactory.imageConfiguration(urlString: urlString)
        requestSender.send(config: configuration) { result in
            completion(result)
        }
    }
}
