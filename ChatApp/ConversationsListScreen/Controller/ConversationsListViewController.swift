//
//  ConversationsListViewController.swift
//  ChatApp
//
//  Created by Anna Belousova on 09.03.2022.
//

import UIKit

class ConversationsListViewController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let cellIdentifier = "ConversationCell"
    private var allContacts = [[Conversation](), [Conversation]()]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Tinkoff Chat"
        var iconAvatarImage = UIImage(named: "icon-avatar")
        iconAvatarImage = iconAvatarImage?.withRenderingMode(.alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: iconAvatarImage, style: .plain, target: self, action: #selector(openProfile))
        setupTableView()
        prepareData()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.register(UINib(nibName: "ConversationCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    private func prepareData() {
        var contacts = Conversation.allContacts
        contacts.sort { $0.date?.compare($1.date ?? Date()) == .orderedDescending }
        for contact in contacts {
            if contact.online == true { allContacts[0].append(contact) }
            else if contact.online == false && contact.message != nil { allContacts[1].append(contact) }
        }
    }
    
    @objc private func openProfile() {
        let profileViewController = ProfileViewController()
        let navigationController = UINavigationController(rootViewController: profileViewController)
        self.present(navigationController, animated: true)
    }
}

extension ConversationsListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return allContacts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allContacts[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        guard let conversationCell = cell as? ConversationCell else { return cell }
        let contact = allContacts[indexPath.section][indexPath.row]
        conversationCell.nameLabel.text = contact.name
        conversationCell.messageLabel.text = contact.message
        conversationCell.timeLabel.text = contact.date?.formattedDate
        
        if contact.online == true { conversationCell.paintOverTheCell() }
        if contact.hasUnreadMessages == true { conversationCell.setBoldFont() }
        if contact.message == nil { conversationCell.noMessages() }
        return conversationCell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 { return "Online" }
        else { return "History" }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = allContacts[indexPath.section][indexPath.row]
        let conversationViewController = ConversationViewController()
        conversationViewController.contactTitle = contact.name
        if contact.message == nil { conversationViewController.isMessageEmpty = true }
        else { conversationViewController.isMessageEmpty = false }
        navigationController?.pushViewController(conversationViewController, animated: true)
    }
}
