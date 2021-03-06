//
//  ConversationCell.swift
//  ChatApp
//
//  Created by Anna Belousova on 10.03.2022.
//

import UIKit

protocol ConversationCellConfiguration: AnyObject {
    var name: String? { get set }
    var message: String? { get set }
    var date: Date? { get set }
    var online: Bool { get set }
    var hasUnreadMessages: Bool { get set }
}

class ConversationCell: UITableViewCell, ConversationCellConfiguration {

    @IBOutlet private weak var cellBackgroundView: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    
    var name: String?
    var message: String?
    var date: Date?
    var online = false
    var hasUnreadMessages = false
    
    func configure(name: String?, message: String?, date: Date?) {
        cellBackgroundView.backgroundColor = online
                                            ? .white
                                            : ThemeManager.currentTheme?.incomingMessageColor
        if hasUnreadMessages { messageLabel.font = .boldSystemFont(ofSize: 14) }
        if message == nil || message == "" {
            messageLabel.text = "No messages yet"
            messageLabel.font = UIFont(name: "SFProDisplay-RegularItalic", size: 14)
        } else {
            messageLabel.text = message
        }
        nameLabel.text = name
        timeLabel.text = date?.formattedDate
        cellBackgroundView.layer.cornerRadius = 8
        selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        messageLabel.text = nil
        timeLabel.text = nil
        messageLabel.font = .systemFont(ofSize: 14)
        cellBackgroundView.backgroundColor = nil
    }
}
