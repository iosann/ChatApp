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
        messageLabel.font = .systemFont(ofSize: 14)
        contentView.backgroundColor = nil
    }
    
    func paintOverTheCell() {
        contentView.backgroundColor = UIColor(red: 1, green: 1, blue: 0.878, alpha: 1)
    }
    
    func setBoldFont() {
        messageLabel.font = .boldSystemFont(ofSize: 14)
    }
    
    func noMessages() {
        messageLabel.text = "No messages yet"
        messageLabel.font = UIFont(name: "SFProDisplay-RegularItalic", size: 14)
    }
}
