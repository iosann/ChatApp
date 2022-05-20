//
//  UICustomization.swift
//  ChatApp
//
//  Created by Anna Belousova on 10.05.2022.
//

import UIKit

extension ProfileViewController {

    func setupUI() {
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
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(showEmblemFlow))
        profileView.addGestureRecognizer(longPress)
    }
    
    func setupScrollView() {
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
    
    @objc private func closeTheScreen() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func dismissKeyboard() {
        profileView.nameTextView.resignFirstResponder()
        profileView.descriptionTextView.resignFirstResponder()
    }
    
    @objc func keyboardWillShow(notification: Notification) {
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
    
    @objc func keyboardWillHide(notification: Notification) {
        scrollView.contentOffset = .zero
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func showEmblemFlow(_ gestureRecognizer: UILongPressGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            let location = gestureRecognizer.location(in: gestureRecognizer.view)
            emitter?.showEmblemFlow(into: location, on: profileView)
        case .ended:
            emitter?.stopAnimation(on: profileView)
        default: break
        }
    }
}
