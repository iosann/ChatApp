//
//  SavingByGCD.swift
//  ChatApp
//
//  Created by Anna Belousova on 23.03.2022.
//

import UIKit

class SavingByGCD {
    
    private let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    private var errors = [Error]()
    
    func writeData(fullName: String?, description: String?, image: UIImage?, _ completion: @escaping(Bool) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            if fullName != nil { self.writeString(string: fullName!, pathName: Constants.fullnameFilename) }
            if description != nil { self.writeString(string: description!, pathName: Constants.descriptionFileName) }
            if image != nil { self.writeImage(image: image!) }
        // успевает ли errors наполниться ошибками?
            sleep(2)
            if self.errors.isEmpty { completion(true) }
            else { completion(false) }
        }
    }
    
    private func writeString(string: String, pathName: String) {
    // вернуть ошибку
        guard let fileName = path?.appendingPathComponent(pathName) else { return }
        do {
            try string.write(to: fileName, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            errors.append(error)
        }
    }
    
    private func writeImage(image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 1),
              let filePath = path?.appendingPathComponent("Photo")
                // вернуть ошибку
        else { return }
        do {
            try data.write(to: filePath)
        } catch {
            errors.append(error)
        }
    }
    
    func getStoredString(fileName: String, _ completion: @escaping(String) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            guard let filePath = self.path?.appendingPathComponent(fileName),
                  let string = try? String(contentsOf: filePath)
            else { return completion("") }
            completion(string)
        }
    }
    
    func getStoredImage(_ completion: @escaping(UIImage) -> Void) {
        guard let filePath = path?.appendingPathComponent("Photo"),
              let data = try? Data(contentsOf: filePath),
              let image = UIImage(data: data)
        else { return completion(UIImage(named: "User_avatar_icon")!) }
        completion(image)
    }
}
