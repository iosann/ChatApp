//
//  ImagesModel.swift
//  ChatApp
//
//  Created by Anna Belousova on 27.04.2022.
//

import Foundation

protocol IImagesModel {
    func getImagesURL(_ completion: @escaping(ImagesURLResult) -> Void)
}

class ImagesModel: IImagesModel {
    
    private let imagesListService: INetworkImageService = NetworkImageService()
    
    func getImagesURL(_ completion: @escaping(ImagesURLResult) -> Void) {
        imagesListService.getImagesList { result in
            completion(result)
        }
    }
}
