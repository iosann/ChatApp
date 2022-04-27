//
//  ImagesModel.swift
//  ChatApp
//
//  Created by Anna Belousova on 27.04.2022.
//

import Foundation

protocol IImagesModel {
    func getImagesURL(_ completion: @escaping(ImagesURLResult) -> Void)
    func getImage(from urlString: String?, _ completion: @escaping(ImageResult) -> Void)
}

class ImagesModel: IImagesModel {
    
    private let imagesListService: INetworkImagesListService = NetworkImagesService()
    private let imageService: INetworkImageService = NetworkImagesService()
    
    func getImagesURL(_ completion: @escaping(ImagesURLResult) -> Void) {
        imagesListService.getImagesList { result in
            completion(result)
        }
    }
    
    func getImage(from urlString: String?, _ completion: @escaping(ImageResult) -> Void) {
        imageService.getImage(from: urlString) { result in
            completion(result)
        }
    }
}
