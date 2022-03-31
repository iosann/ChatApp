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
    private let senderNameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .boldSystemFont(ofSize: 16)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = ThemeManager.shared.currentTheme.textColor
        return label
    }()
    private let timeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 1
        label.textAlignment = .right
        label.textColor = ThemeManager.shared.currentTheme.textColor
        return label
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
    }
    
    func configure(messageText: String?, date: Date?, isIncomingMessage: Bool, senderName: String?) {
        messageLabel.text = messageText
        timeLabel.text = date?.formattedDate
        if isIncomingMessage {
            ThemeManager.shared.setBackgroundColorForIncomingMessage(for: cellBackgroundView)
            trailingConstraint.isActive = true
            leadingConstraint.isActive = false
        } else {
            ThemeManager.shared.setBackgroundColorForOutgoingMessage(for: cellBackgroundView)
            senderNameLabel.text = senderName
            trailingConstraint.isActive = false
            leadingConstraint.isActive = true
        }
    }
    
    private func setupConstraints() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.addSubview(cellBackgroundView)
        contentView.addSubview(messageLabel)
        contentView.addSubview(senderNameLabel)
        contentView.addSubview(timeLabel)
        cellBackgroundView.layer.cornerRadius = 8
        cellBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        senderNameLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false

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
            cellBackgroundView.widthAnchor.constraint(greaterThanOrEqualToConstant: 60)
        ])
    }
}
