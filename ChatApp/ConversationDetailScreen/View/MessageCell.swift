//
//  MessageCell.swift
//  ChatApp
//
//  Created by Anna Belousova on 10.03.2022.
//

import UIKit

protocol MessageCellConfiguration: AnyObject {
    var messageText: String? { get set }
}

class MessageCell: UITableViewCell, MessageCellConfiguration {
    
    private let cellBackgroundView = UIView()
    private let messageLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = ThemeManager.shared.currentTheme.textColor
        return label
    }()
    var messageText: String?
    private var isIncomingMessage: Bool?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        messageLabel.text = nil
        isIncomingMessage = nil
        cellBackgroundView.backgroundColor = nil
    }
    
    func configure(messageText: String?, isIncomingMessage: Bool) {
        messageLabel.text = messageText
        if isIncomingMessage {
            ThemeManager.shared.setBackgroundColorForIncomingMessage(for: cellBackgroundView)
            NSLayoutConstraint.activate([
                messageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
            ])
        } else {
            ThemeManager.shared.setBackgroundColorForOutgoingMessage(for: cellBackgroundView)
            NSLayoutConstraint.activate([
                messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
            ])
        }
    }
    
    private func setupConstraints() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.addSubview(cellBackgroundView)
        contentView.addSubview(messageLabel)
        cellBackgroundView.layer.cornerRadius = 8
        cellBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            messageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: contentView.bounds.size.width * 0.75),
            
            cellBackgroundView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -8),
            cellBackgroundView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 8),
            cellBackgroundView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -8),
            cellBackgroundView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 8)
        ])
    }
}
