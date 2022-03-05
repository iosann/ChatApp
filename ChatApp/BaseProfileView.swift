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
    @IBOutlet private weak var nameTextView: UITextView!
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    
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
        nameTextView.font = UIFont(name: "SFProDisplay-Bold", size: 24)
        descriptionTextView.font = UIFont(name: "SFProText-Regular", size: 16)
        
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
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        photoImageView.layer.cornerRadius = photoImageView.bounds.size.width / 2
        editIconView.layer.cornerRadius = editIconView.bounds.size.width / 2
    }
}
