//
//  BaseProfileView.swift
//  ChatApp
//
//  Created by Anna Belousova on 03.03.2022.
//

import UIKit

class BaseProfileView: UIView {

    @IBOutlet private var contentView: UIView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet private weak var buttonStackView: UIStackView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet var saveButtons: [UIButton]!
    
    private(set) var editPhotoButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 0.247, green: 0.471, blue: 0.94, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "camera.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        return button
    }()
    
    var isEditingMode = false {
        didSet {
            if isEditingMode {
                nameTextField.isUserInteractionEnabled = true
                descriptionTextField.isUserInteractionEnabled = true
                editButton.isHidden = true
                buttonStackView.isHidden = false
            } else {
                buttonStackView.isHidden = true
                editButton.isHidden = false
                saveButtons.forEach { $0.isEnabled = false }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//      print(saveButton.frame)
//      Краш из-за попытки обратиться к кнопке раньше, чем xib, содержащий кнопку, будет инициализирован
        loadNib()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNib()
        configureView()
    }
    
    private func loadNib() {
        Bundle.main.loadNibNamed("BaseProfileView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    private func configureView() {
        ThemeManager.shared.setBackgroundColor(for: contentView)
        nameTextField.delegate = self
        descriptionTextField.delegate = self
        nameTextField.font = UIFont(name: "SFProDisplay-Bold", size: 24)
        descriptionTextField.font = UIFont(name: "SFProText-Regular", size: 16)
        
        editButton.layer.cornerRadius = 12
        editButton.titleLabel?.font = UIFont(name: "SFProText-Semibold", size: 19)
        [cancelButton, saveButtons.first, saveButtons.last].forEach { $0?.layer.cornerRadius = 12 }

        contentView.addSubview(editPhotoButton)
        NSLayoutConstraint.activate([
            editPhotoButton.widthAnchor.constraint(equalToConstant: photoImageView.bounds.size.width / 4),
            editPhotoButton.heightAnchor.constraint(equalTo: editPhotoButton.widthAnchor),
            editPhotoButton.bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor),
            editPhotoButton.trailingAnchor.constraint(equalTo: photoImageView.trailingAnchor)
        ])
    }
    
    @IBAction func editTextFields(_ sender: UIButton) {
        isEditingMode = true
        if nameTextField.canBecomeFirstResponder { nameTextField.becomeFirstResponder() }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        photoImageView.layer.cornerRadius = photoImageView.bounds.size.width / 2
        editPhotoButton.layer.cornerRadius = editPhotoButton.bounds.size.width / 2
    }
    
    @IBAction func cancelEditing(_ sender: UIButton) {
    // textField.text = предыдущее значение
    // photoImageView.image = предыдущее значение
        isEditingMode = false
    }
}

extension BaseProfileView: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButtons.forEach { $0.isEnabled = true }
    }
}
