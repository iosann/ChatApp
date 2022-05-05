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
    @IBOutlet private weak var buttonStackView: UIStackView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var nameTextView: UITextView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
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
                [nameTextView, descriptionTextView].forEach { $0?.isUserInteractionEnabled = true }
                editButton.isHidden = true
                buttonStackView.isHidden = false
            } else {
                buttonStackView.isHidden = true
                editButton.isHidden = false
                saveButton.isEnabled = false
                [editPhotoButton, cancelButton].forEach { $0.isEnabled = true }
                [nameTextView, descriptionTextView].forEach { $0?.isUserInteractionEnabled = false }
            }
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    override var canResignFirstResponder: Bool {
        return true
    }
    
    private var isAnimating = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func loadNib() {
        Bundle.main.loadNibNamed("BaseProfileView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    private func configureView() {
        contentView.backgroundColor = ThemeManager.currentTheme?.backgroundColor
        nameTextView.font = UIFont(name: "SFProDisplay-Bold", size: 24)
        descriptionTextView.font = UIFont(name: "SFProText-Regular", size: 16)
        [nameTextView, descriptionTextView].forEach {
            $0?.delegate = self
            $0?.layer.cornerRadius = 10
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor = ThemeManager.currentTheme?.textColor.cgColor
            $0?.textColor = ThemeManager.currentTheme?.textColor
        }
        
        editButton.titleLabel?.font = UIFont(name: "SFProText-Semibold", size: 19)
        [cancelButton, saveButton, editButton].forEach {
            $0?.layer.cornerRadius = 12
            $0?.backgroundColor = ThemeManager.currentTheme?.outgoingMessageColor
            $0?.setTitleColor(ThemeManager.currentTheme?.textColor, for: .normal)
        }

        contentView.addSubview(editPhotoButton)
        NSLayoutConstraint.activate([
            editPhotoButton.widthAnchor.constraint(equalToConstant: photoImageView.bounds.size.width / 4),
            editPhotoButton.heightAnchor.constraint(equalTo: editPhotoButton.widthAnchor),
            editPhotoButton.bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor),
            editPhotoButton.trailingAnchor.constraint(equalTo: photoImageView.trailingAnchor)
        ])
    }
    
    @IBAction func editTextViews(_ sender: UIButton) {
        isEditingMode = true
        if nameTextView.canBecomeFirstResponder { nameTextView.becomeFirstResponder() }

        if isAnimating {
            editButton.layer.removeAllAnimations()
            isAnimating = false
        } else { startTremblingAnimation() }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        photoImageView.layer.cornerRadius = photoImageView.bounds.size.width / 2
        editPhotoButton.layer.cornerRadius = editPhotoButton.bounds.size.width / 2
    }
    
    private func startTremblingAnimation() {
        
        let offset = CABasicAnimation(keyPath: #keyPath(CALayer.position))
        offset.fromValue = [saveButton.center.x - 5, saveButton.center.y - 5]
        offset.toValue = [saveButton.center.x + 5, saveButton.center.y + 5]
        offset.duration = 0.1
        offset.autoreverses = true
        
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = -18 * CGFloat.pi / 180
        rotation.toValue = 18 * CGFloat.pi / 180
        rotation.duration = 0.1
        rotation.autoreverses = true
        
        let spring = CASpringAnimation(keyPath: "position")
        spring.damping = 10
        spring.fromValue = [saveButton.center.x - 2, saveButton.center.y - 2]
        spring.toValue = [saveButton.center.x + 2, saveButton.center.y + 2]
        spring.duration = 0.1
        spring.repeatDuration = 0.3
        
        let group = CAAnimationGroup()
        group.duration = 0.3
        group.autoreverses = true
        group.repeatCount = .infinity
        group.animations = [offset, rotation, spring]
        saveButton.layer.add(group, forKey: nil)
        isAnimating = true
    }
}

extension BaseProfileView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == nameTextView { nameTextView.becomeFirstResponder()
        } else { descriptionTextView.becomeFirstResponder() }
        saveButton.isEnabled = true
    }
}
