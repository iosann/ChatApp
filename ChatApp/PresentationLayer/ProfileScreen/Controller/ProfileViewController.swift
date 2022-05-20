//
//  ProfileViewController.swift
//  ChatApp
//
//  Created by Anna Belousova on 03.03.2022.
//

import UIKit

class ProfileViewController: UIViewController {
    
    let profileView = BaseProfileView()
    let scrollView = UIScrollView()
    var activityIndicator = ActivityIndicator(frame: .zero)
    private var storedFullName: String?
    private var storedDescription: String?
    private var storedPhoto: UIImage?
    private var newDataForSaving: [String: Any?] = ["newName": nil, "newDescription": nil, "newPhoto": nil]
    private let model: IProfileModel
    
    let emitter: IEmblemEmitter? = EmblemEmitter()
    
    init(model: IProfileModel, presentationAssembly: IPresentationAssembly) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    private func getStoredData() {
        model.getStoredString(fileName: TextConstants.fullnameFilename) { [weak self] fullname in
            self?.storedFullName = fullname
            DispatchQueue.main.async { self?.profileView.nameTextView.text = fullname }
        }
        model.getStoredString(fileName: TextConstants.descriptionFileName) { [weak self] description in
            self?.storedDescription = description
            DispatchQueue.main.async { self?.profileView.descriptionTextView.text = description }
        }
        model.getStoredImage { [weak self] image in
            self?.storedPhoto = image
            DispatchQueue.main.async { self?.profileView.photoImageView.image = image }
        }
    }
    
    @objc func saveChanges(_ sender: UIButton) {
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
        model.writeData(fullName: newDataForSaving["newName"] as? String,
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
    
    @objc func cancelEditing() {
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
}
