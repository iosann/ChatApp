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
    private var activityIndicator = ActivityIndicator(frame: .zero)
    private var storedFullName: String?
    private var storedDescription: String?
    private var storedPhoto: UIImage?
    private var newDataForSaving: [String: Any?] = ["newName": nil, "newDescription": nil, "newPhoto": nil]
    private let model: IProfileModel? = ProfileModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        getStoredData()
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activityIndicator.center = profileView.center
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillShowNotification)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillHideNotification)
    }
    
    private func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        let closeButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeTheScreen))
        navigationItem.rightBarButtonItem = closeButton
        let titleButton = UIBarButtonItem(title: "My Profile", style: .plain, target: self, action: nil)
        titleButton.setTitleTextAttributes([
            .font: UIFont(name: "SFProDisplay-Bold", size: 26) ?? .boldSystemFont(ofSize: 26),
            .foregroundColor: ThemeManager.currentTheme?.tintColor as Any], for: .normal)
        navigationItem.leftBarButtonItem = titleButton
        view.backgroundColor = ThemeManager.currentTheme?.backgroundColor
        setupScrollView()
        profileView.editPhotoButton.addTarget(self, action: #selector(editProfileImage), for: .touchUpInside)
        profileView.cancelButton.addTarget(self, action: #selector(cancelEditing), for: .touchUpInside)
        profileView.saveButton.addTarget(self, action: #selector(saveChanges), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        profileView.addGestureRecognizer(tap)
        profileView.addSubview(activityIndicator)
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
            profileView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height - (navigationController?.navigationBar.bounds.height ?? 0) - 60)
        ])
    }
    
    private func getStoredData() {
        model?.getStoredString(fileName: TextConstants.fullnameFilename) { [weak self] fullname in
            self?.storedFullName = fullname
            DispatchQueue.main.async { self?.profileView.nameTextView.text = fullname }
        }
        model?.getStoredString(fileName: TextConstants.descriptionFileName) { [weak self] description in
            self?.storedDescription = description
            DispatchQueue.main.async { self?.profileView.descriptionTextView.text = description }
        }
        model?.getStoredImage { [weak self] image in
            self?.storedPhoto = image
            DispatchQueue.main.async { self?.profileView.photoImageView.image = image }
        }
    }
    
    @objc private func closeTheScreen() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveChanges(_ sender: UIButton) {
        profileView.saveButton.layer.removeAllAnimations()
        activityIndicator.startAnimating()
        activityIndicator.animate()
        
        [profileView.saveButton, profileView.editPhotoButton, profileView.cancelButton].forEach { $0?.isEnabled = false }
        
        if profileView.nameTextView.text != storedFullName {
            newDataForSaving["newName"] = profileView.nameTextView.text
        }
        if profileView.descriptionTextView.text != storedDescription {
            newDataForSaving["newDescription"] = profileView.descriptionTextView.text
        }
        if profileView.photoImageView.image != nil, profileView.photoImageView.image != storedPhoto {
            newDataForSaving["newPhoto"] = profileView.photoImageView.image
        }
        writeNewData()
    }
    
    private func writeNewData() {
        model?.writeData(fullName: newDataForSaving["newName"] as? String,
                           description: newDataForSaving["newDescription"] as? String,
                           image: newDataForSaving["newPhoto"] as? UIImage) { [weak self] result in
            self?.showAlert(result)
        }
    }
    
    private func showAlert(_ result: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.createAlertForResult(result)
        }
    }
    
    @objc private func cancelEditing() {
        profileView.isEditingMode = false
        profileView.nameTextView.text = storedFullName
        profileView.descriptionTextView.text = storedDescription
        profileView.photoImageView.image = storedPhoto
    }
    
    private func createAlertForResult(_ success: Bool) {
        if success {
            let alert = UIAlertController(title: "Данные сохранены", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel) { [weak self] _ in self?.profileView.isEditingMode = false
                self?.newDataForSaving.keys.forEach { self?.newDataForSaving[$0] = nil }
            }
            alert.addAction(okAction)
            present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "Ошибка", message: "Не удалось сохранить данные", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { [weak self] _ in self?.profileView.isEditingMode = false
            }
            alert.addAction(okAction)
            let repeatAction = UIAlertAction(title: "Повторить", style: .cancel) { [weak self] _ in
                self?.writeNewData()
            }
            alert.addAction(repeatAction)
            present(alert, animated: true)
        }
    }
    
    @objc private func dismissKeyboard() {
        profileView.nameTextView.resignFirstResponder()
        profileView.descriptionTextView.resignFirstResponder()
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else { return }
        let keyboardFrame = keyboardSize.cgRectValue
        
        let offset = profileView.descriptionTextView.frame.maxY + (navigationController?.navigationBar.bounds.height ?? 0)
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
        profileView.isEditingMode = true
        profileView.saveButton.isEnabled = true
//        print("Выбери изображение профиля")
        
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
            let imagesController = ImagesCollectionViewController()
            
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
