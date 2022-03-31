//
//  DataSaving.swift
//  ChatApp
//
//  Created by Anna Belousova on 24.03.2022.
//

import UIKit

enum ServiceError: Error {
    case `default`
}

protocol ISavingData: AnyObject {
    func writeData(fullName: String?, description: String?, image: UIImage?, _ completion: @escaping(Bool) -> Void)
    func getStoredString(fileName: String, _ completion: @escaping(String) -> Void)
    func getStoredImage(_ completion: @escaping(UIImage) -> Void)
}

class DataSaving {
    
    private let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    private var errors = [Error]()
    
    func writeData(fullName: String?, description: String?, image: UIImage?, _ completion: @escaping (Bool) -> Void) {
            if fullName != nil { self.writeString(string: fullName ?? "", pathName: Constants.fullnameFilename) }
            if description != nil { self.writeString(string: description ?? "", pathName: Constants.descriptionFileName) }
            if image != nil { self.writeImage(image: image ?? UIImage()) }
// sleep() добавлен, чтобы во время записи данных увидеть activityIndicator и убедиться в назаблокированности экрана
            sleep(2)
            if self.errors.isEmpty {
                completion(true)
            } else { completion(false) }
    }
    
    func getStoredString(fileName: String, _ completion: @escaping (String) -> Void) {
        guard let filePath = self.path?.appendingPathComponent(fileName),
              let string = try? String(contentsOf: filePath)
        else { return completion("") }
        completion(string)
    }
    
    func getStoredImage(_ completion: @escaping (UIImage) -> Void) {
        guard let filePath = path?.appendingPathComponent("Photo"),
              let data = try? Data(contentsOf: filePath),
              let image = UIImage(data: data)
        else { return completion(UIImage(named: "User_avatar_icon") ?? UIImage()) }
        completion(image)
    }
    
    private func writeString(string: String, pathName: String) {
        guard let fileName = path?.appendingPathComponent(pathName) else {
            errors.append(ServiceError.default)
            return
        }
        do {
            try string.write(to: fileName, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            errors.append(error)
        }
    }
    
    private func writeImage(image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 1),
              let filePath = path?.appendingPathComponent("Photo")
        else {
            errors.append(ServiceError.default)
            return
        }
        do {
            try data.write(to: filePath)
        } catch {
            errors.append(error)
        }
    }
}
