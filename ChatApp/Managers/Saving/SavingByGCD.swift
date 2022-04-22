//
//  SavingByGCD.swift
//  ChatApp
//
//  Created by Anna Belousova on 23.03.2022.
//

import UIKit

class SavingByGCD: ISavingData {
    
    let dataSaving = DataSaving()
    
    func writeData(fullName: String?, description: String?, image: UIImage?, _ completion: @escaping(Bool) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.dataSaving.writeData(fullName: fullName, description: description, image: image) { bool in
                completion(bool)
            }
        }
    }
    
    func getStoredString(fileName: String, _ completion: @escaping(String) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            self?.dataSaving.getStoredString(fileName: fileName) { filename in
                completion(filename)
            }
        }
    }
    
    func getStoredImage(_ completion: @escaping(UIImage) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            self?.dataSaving.getStoredImage { image in
                completion(image)
            }
        }
    }
}
