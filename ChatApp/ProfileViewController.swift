//
//  ProfileViewController.swift
//  ChatApp
//
//  Created by Anna Belousova on 03.03.2022.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private let profileView = BaseProfileView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        navigationController?.navigationBar.backgroundColor = UIColor(red: 0.968, green: 0.968, blue: 0.968, alpha: 1)
        navigationController?.navigationBar.largeTitleTextAttributes = [.font: UIFont(name: "SFProDisplay-Bold", size: 26) ?? .boldSystemFont(ofSize: 26)]
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "My Profile"
        let closeButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeTheScreen))
        navigationItem.rightBarButtonItem = closeButton

        view = profileView
        let tap = UITapGestureRecognizer(target: self, action: #selector(editProfileImage))
        profileView.editIconView.addGestureRecognizer(tap)
    }
    
    @objc private func closeTheScreen() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func editProfileImage(_ sender: UITapGestureRecognizer) {
        print("Выбери изображение профиля")
        
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
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.originalImage] as? UIImage
        profileView.photoImageView.image = selectedImage
        dismiss(animated: true)
    }
}
