//
//  ImagePickerExtension.swift
//  ChatApp
//
//  Created by Anna Belousova on 10.05.2022.
//

import UIKit

extension ProfileViewController {
    
    @objc func editProfileImage(_ sender: UIButton) {
        profileView.isEditingMode = true
        profileView.saveButton.isEnabled = true
        
        let alert = UIAlertController(title: "Choose image source", message: nil, preferredStyle: .actionSheet)
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true)
            }
            alert.addAction(cameraAction)
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibraryAction = UIAlertAction(title: "PhotoLibrary", style: .default) { _ in
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true)
            }
            alert.addAction(photoLibraryAction)
        }
        let loadAction = UIAlertAction(title: "Load", style: .default) { _ in
            let imagesController = RootAssembly.presentationAssembly.getImagesCollectionViewController()
            
            imagesController.didUpdateCompletion = { [weak self] urlString in
                DispatchQueue.global(qos: .userInitiated).async {
                    guard let url = URL(string: urlString), let data = try? Data(contentsOf: url) else { return }
                        DispatchQueue.main.async {
                            self?.profileView.photoImageView.image = UIImage(data: data)
                        }
                    }
                }
            self.present(imagesController, animated: true)
        }
        alert.addAction(loadAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let selectedImage = info[.originalImage] as? UIImage
        profileView.photoImageView.image = selectedImage
        dismiss(animated: true)
    }
}
