//
//  ProfileViewController.swift
//  ChatApp
//
//  Created by Anna Belousova on 03.03.2022.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private let profileView = BaseProfileView()
    private let scrollView = UIScrollView()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFProDisplay-Bold", size: 26)
        label.text = "My Profile"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        print(profileView.saveButton.frame)
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(profileView.saveButton.frame)
//      viewDidAppear вызывается после того, как AutoLayout завершит свою работу и отобразит конечный вид UI элементов, а viewDidLoad - до этого.
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        profileView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(profileView)
        
        NSLayoutConstraint.activate([
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: navigationController?.navigationBar.bounds.maxY ?? 0),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            profileView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            profileView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            profileView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            profileView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    private func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        let closeButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeTheScreen))
        closeButton.isEnabled = true
        navigationItem.rightBarButtonItem = closeButton
        let titleButton = UIBarButtonItem(title: "My Profile", style: .plain, target: self, action: nil)
        titleButton.setTitleTextAttributes([.font: UIFont(name: "SFProDisplay-Bold", size: 26) ?? .boldSystemFont(ofSize: 26), .foregroundColor: ThemeManager.shared.currentTheme.tintColor], for: .normal)
        navigationItem.leftBarButtonItem = titleButton
        ThemeManager.shared.setBackgroundColor(for: view)
        setupScrollView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(editProfileImage))
        profileView.editIconView.addGestureRecognizer(tap)
        changeConstraint()
    }
    
    @objc private func closeTheScreen() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyboardSize.cgRectValue
        if self.view.frame.origin.y == 0 {
            if UIScreen.main.bounds.height <= 736 {
                self.view.frame.origin.y -= keyboardFrame.height * 0.45
            } else {
                self.view.frame.origin.y -= keyboardFrame.height * 0.2
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        if self.view.frame.origin.y != 0 { self.view.frame.origin.y = 0 }
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
    
    private func changeConstraint() {
        if UIScreen.main.bounds.height >= 812 {
            profileView.saveButtonTopConstraint.constant = (UIScreen.main.bounds.maxY - 1.4 * profileView.descriptionLabel.frame.maxY) / 1.3
        }
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.originalImage] as? UIImage
        profileView.photoImageView.image = selectedImage
        dismiss(animated: true)
    }
}
