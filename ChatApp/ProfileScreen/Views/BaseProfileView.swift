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
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var saveButtonTopConstraint: NSLayoutConstraint!
    
    let editIconView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.247, green: 0.471, blue: 0.94, alpha: 1)
        return view
    }()
    
    private let editIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "camera.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        return imageView
    }()

    private var isEnableEditingNameLabel = false {
        didSet {
            if isEnableEditingNameLabel == true {
                nameTextField.text = nameLabel.text
                nameTextField.isHidden = false
                nameLabel.isHidden = true
            } else {
                if nameTextField.text != "" { nameLabel.text = nameTextField.text }
                nameTextField.isHidden = true
                nameLabel.isHidden = false
            }
        }
    }
    
    private var isEnableEditingDescriptionLabel = false {
        didSet {
            if isEnableEditingDescriptionLabel == true {
                descriptionTextField.text = descriptionLabel.text
                descriptionTextField.isHidden = false
                descriptionLabel.isHidden = true
            } else {
                if descriptionTextField.text != "" { descriptionLabel.text = descriptionTextField.text }
                descriptionTextField.isHidden = true
                descriptionLabel.isHidden = false
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
        nameTextField.delegate = self
        descriptionTextField.delegate = self
        
        nameLabel.font = UIFont(name: "SFProDisplay-Bold", size: 24)
        descriptionLabel.font = UIFont(name: "SFProText-Regular", size: 16)
        nameTextField.font = UIFont(name: "SFProDisplay-Bold", size: 24)
        descriptionTextField.font = UIFont(name: "SFProText-Regular", size: 16)
        
        saveButton.layer.cornerRadius = 14
        saveButton.titleLabel?.font = UIFont(name: "SFProText-Semibold", size: 19)
        
        contentView.addSubview(editIconView)
        editIconView.addSubview(editIconImageView)
        NSLayoutConstraint.activate([
            editIconView.widthAnchor.constraint(equalToConstant: photoImageView.bounds.size.width / 4),
            editIconView.heightAnchor.constraint(equalTo: editIconView.widthAnchor),
            editIconView.bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor),
            editIconView.trailingAnchor.constraint(equalTo: photoImageView.trailingAnchor),
            editIconImageView.centerXAnchor.constraint(equalTo: editIconView.centerXAnchor),
            editIconImageView.centerYAnchor.constraint(equalTo: editIconView.centerYAnchor)
        ])
        let nameTap = UITapGestureRecognizer(target: self, action: #selector(editNameOrDescription))
        let descriptionTap = UITapGestureRecognizer(target: self, action: #selector(editNameOrDescription))
        nameLabel.addGestureRecognizer(nameTap)
        descriptionLabel.addGestureRecognizer(descriptionTap)
    }

    @objc private func editNameOrDescription(_ sender: UITapGestureRecognizer) {
        guard let parentLabel = sender.view else { return }
        if parentLabel == nameLabel { isEnableEditingNameLabel = true }
        else if parentLabel == descriptionLabel { isEnableEditingDescriptionLabel = true }
    }
    
    @IBAction func saveChanges(_ sender: UIButton) {
        isEnableEditingNameLabel = false
        isEnableEditingDescriptionLabel = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        photoImageView.layer.cornerRadius = photoImageView.bounds.size.width / 2
        editIconView.layer.cornerRadius = editIconView.bounds.size.width / 2
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
}
