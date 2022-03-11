//
//  MessageCell.swift
//  ChatApp
//
//  Created by Anna Belousova on 10.03.2022.
//

import UIKit

class MessageCell: UITableViewCell {
    
    let cellIdentifier = "MessageCell"
    let cellBackgroundView = UIView()
    let messageLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        contentView.addSubview(cellBackgroundView)
        cellBackgroundView.addSubview(messageLabel)
        cellBackgroundView.layer.cornerRadius = 10
        cellBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            cellBackgroundView.widthAnchor.constraint(equalToConstant: contentView.bounds.size.width * 0.75),
            cellBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cellBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            messageLabel.topAnchor.constraint(equalTo: cellBackgroundView.topAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: cellBackgroundView.leadingAnchor, constant: 8),
            messageLabel.trailingAnchor.constraint(equalTo: cellBackgroundView.trailingAnchor, constant: -8),
            messageLabel.bottomAnchor.constraint(equalTo: cellBackgroundView.bottomAnchor, constant: -8)
        ])
    }

    func setupConstraintsForIncomingMessage() {
        NSLayoutConstraint.activate([
            cellBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
        ])
        cellBackgroundView.backgroundColor = UIColor(red: 0.902, green: 0.902, blue: 0.98, alpha: 1)
    }
    
    func setupConstraintsForOutgoingMessage() {
        NSLayoutConstraint.activate([
            cellBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
        ])
        cellBackgroundView.backgroundColor = UIColor(red: 0.69, green: 0.878, blue: 0.902, alpha: 1)
    }
}
