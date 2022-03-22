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
//        print(profileView.saveButton.frame)
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        print(profileView.saveButton.frame)
//      viewDidAppear вызывается после того, как AutoLayout завершит свою работу и отобразит конечный вид UI элементов, а viewDidLoad - до этого.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillShowNotification)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillHideNotification)
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        profileView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(profileView)
        
        NSLayoutConstraint.activate([
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            profileView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            profileView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            profileView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            profileView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            profileView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height -  (navigationController?.navigationBar.bounds.height ?? 0) - 60)
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
        profileView.editPhotoButton.addTarget(self, action: #selector(editProfileImage), for: .touchUpInside)
    }
    
    @objc private func closeTheScreen() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyboardSize.cgRectValue
        
        let offset = (profileView.activeTextField?.frame.maxY ?? profileView.descriptionTextField.frame.maxY)
        + (navigationController?.navigationBar.bounds.height ?? 0)
        if offset > keyboardFrame.minY {
            scrollView.contentOffset = CGPoint(x: 0, y: (offset - keyboardFrame.minY))
        }
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardFrame.height, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        scrollView.contentOffset = .zero
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }

    @objc private func editProfileImage(_ sender: UIButton) {
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
