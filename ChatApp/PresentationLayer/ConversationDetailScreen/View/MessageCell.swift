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
        label.textColor = ThemeManager.currentTheme?.textColor
        return label
    }()
    private let senderNameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .boldSystemFont(ofSize: 16)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = ThemeManager.currentTheme?.textColor
        return label
    }()
    private let timeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 1
        label.textAlignment = .right
        label.textColor = ThemeManager.currentTheme?.textColor
        return label
    }()
    let messageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var messageText: String?
    private lazy var leadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
    private lazy var trailingConstraint = messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)

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
        senderNameLabel.text = nil
        timeLabel.text = nil
        cellBackgroundView.backgroundColor = nil
        messageImageView.isHidden = true
        messageImageView.image = nil
    }
    
    func configure(messageText: String?, date: Date?, isIncomingMessage: Bool, senderName: String?) {
        messageLabel.text = messageText
        timeLabel.text = date?.formattedDate
        if isIncomingMessage {
            cellBackgroundView.backgroundColor = ThemeManager.currentTheme?.incomingMessageColor
            trailingConstraint.isActive = false
            leadingConstraint.isActive = true
            senderNameLabel.text = senderName
        } else {
            cellBackgroundView.backgroundColor = ThemeManager.currentTheme?.outgoingMessageColor
            trailingConstraint.isActive = true
            leadingConstraint.isActive = false
        }
    }
    
    private func setupConstraints() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.addSubview(cellBackgroundView)
        contentView.addSubview(messageLabel)
        contentView.addSubview(senderNameLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(messageImageView)
        cellBackgroundView.layer.cornerRadius = 8
        cellBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        senderNameLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        messageImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            senderNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            senderNameLabel.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor),
            senderNameLabel.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor),
            messageLabel.topAnchor.constraint(equalTo: senderNameLabel.bottomAnchor, constant: 8),
            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: contentView.bounds.size.width * 0.75),
            timeLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 8),
            timeLabel.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor),
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            cellBackgroundView.topAnchor.constraint(equalTo: senderNameLabel.topAnchor, constant: -8),
            cellBackgroundView.bottomAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 8),
            cellBackgroundView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -8),
            cellBackgroundView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 8),
            cellBackgroundView.widthAnchor.constraint(greaterThanOrEqualToConstant: 60),
            
            messageImageView.topAnchor.constraint(equalTo: cellBackgroundView.topAnchor),
            messageImageView.leadingAnchor.constraint(equalTo: cellBackgroundView.leadingAnchor),
            messageImageView.trailingAnchor.constraint(equalTo: cellBackgroundView.trailingAnchor),
            messageImageView.bottomAnchor.constraint(equalTo: cellBackgroundView.bottomAnchor)
        ])
        messageImageView.isHidden = true
    }
}
