//
//  ConversationCell.swift
//  ChatApp
//
//  Created by Anna Belousova on 10.03.2022.
//

import UIKit

class ConversationCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        messageLabel.text = nil
        timeLabel.text = nil
    }
    
    func paintOverTheCell() {
        contentView.backgroundColor = .systemYellow
    }
    
    func setBoldFont() {
        messageLabel.font = .boldSystemFont(ofSize: 15)
    }
    
    func noMessages() {
        messageLabel.text = "No messages yet"
    }
}
