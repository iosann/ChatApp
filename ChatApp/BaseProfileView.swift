//
//  BaseProfileView.swift
//  ChatApp
//
//  Created by Anna Belousova on 03.03.2022.
//

import UIKit

class BaseProfileView: UIView {

    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var nameTextView: UITextView!
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var saveButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        photoImageView.backgroundColor = .red
        photoImageView.layer.cornerRadius = photoImageView.bounds.size.width / 2
        
        nameTextView.font = UIFont(name: "SFProDisplay-Bold", size: 24)
        descriptionTextView.font = UIFont(name: "SFProText-Regular", size: 16)
        
        saveButton.layer.cornerRadius = 14
        saveButton.titleLabel?.font = UIFont(name: "SFProText-Regular", size: 19)
    }
}
