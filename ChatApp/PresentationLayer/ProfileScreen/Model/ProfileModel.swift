//
//  ProfileModel.swift
//  ChatApp
//
//  Created by Anna Belousova on 27.04.2022.
//

import UIKit

protocol IProfileModel {
    func writeData(fullName: String?, description: String?, image: UIImage?, _ completion: @escaping(Bool) -> Void)
    func getStoredString(fileName: String, _ completion: @escaping(String) -> Void)
    func getStoredImage(_ completion: @escaping(UIImage) -> Void)
}

class ProfileModel: IProfileModel {
    
//    private let savingService: IStorageService = SavingByGCDService()
    private let savingService: IStorageService = OperationStorageService()
    
    func writeData(fullName: String?, description: String?, image: UIImage?, _ completion: @escaping (Bool) -> Void) {
        savingService.writeData(fullName: fullName, description: description, image: image) { bool in
            completion(bool)
        }
    }
    
    func getStoredImage(_ completion: @escaping (UIImage) -> Void) {
        savingService.getStoredImage { image in
            completion(image)
        }
    }
    
    func getStoredString(fileName: String, _ completion: @escaping (String) -> Void) {
        savingService.getStoredString(fileName: fileName) { string in
            completion(string)
        }
    }
}
