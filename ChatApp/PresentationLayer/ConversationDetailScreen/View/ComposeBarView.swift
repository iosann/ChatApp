//
//  ComposeBarView.swift
//  ChatApp
//
//  Created by Anna Belousova on 31.03.2022.
//

import UIKit

class ComposeBarView: UIView {
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet var textView: UITextView!
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var imageButton: UIButton!
    
    override var intrinsicContentSize: CGSize {
        return textViewContentSize()
    }
    override var canBecomeFirstResponder: Bool {
        return true
    }
    override var canResignFirstResponder: Bool {
        return true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func loadNib() {
        Bundle.main.loadNibNamed("ComposeBarView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    private func setupUI() {
        contentView.backgroundColor = ThemeManager.currentTheme?.backgroundColor
        textView.delegate = self
        textView.layer.cornerRadius = 10
        textView.layer.borderWidth = 1
        textView.layer.borderColor = ThemeManager.currentTheme?.textColor.cgColor
        textView.textColor = ThemeManager.currentTheme?.textColor
        [sendButton, imageButton].forEach { $0.setTitle("", for: .normal) }
    }
    
    func textViewContentSize() -> CGSize {
        let size = CGSize(width: textView.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let textSize = textView.sizeThatFits(size)
        return CGSize(width: bounds.width, height: textSize.height)
    }
}

extension ComposeBarView: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == TextConstants.textViewPlaceholder { textView.text = "" }
        textView.becomeFirstResponder()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let contentHeight = textViewContentSize().height
        if textViewHeight.constant != contentHeight {
            textViewHeight.constant = textViewContentSize().height
            layoutIfNeeded()
        }
    }
}
