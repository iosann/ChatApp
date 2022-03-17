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
        var iconAvatarImage = UIImage(named: "avatar_icon")
        iconAvatarImage = iconAvatarImage?.withRenderingMode(.alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: iconAvatarImage, style: .plain, target: self, action: #selector(openProfile))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_settings"), style: .plain, target: self, action: #selector(openThemes))
        setupTableView()
        prepareData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: ThemeManager.shared.currentTheme.tintColor]
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
        tableView.separatorStyle = .none
    }
    
    private func prepareData() {
        for contact in Conversation.allContacts {
            if contact.online { allContacts[0].append(contact) }
            else if contact.message != nil { allContacts[1].append(contact) }
        }
        allContacts[0].sort { $0.date?.compare($1.date ?? Date()) == .orderedDescending }
        allContacts[1].sort { $0.date?.compare($1.date ?? Date()) == .orderedDescending }
    }
    
    @objc private func openProfile() {
        let profileViewController = ProfileViewController()
        let navigationController = UINavigationController(rootViewController: profileViewController)
        self.present(navigationController, animated: true)
    }
    
    @objc private func openThemes() {
        let themesViewController = ThemesViewController()
        navigationController?.pushViewController(themesViewController, animated: true)
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
        conversationCell.configure(name: contact.name, message: contact.message, date: contact.date, online: contact.online, hasUnreadMessages: contact.hasUnreadMessages)
        return conversationCell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 { return "Online" }
        else { return "History" }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = allContacts[indexPath.section][indexPath.row]
        let conversationViewController = ConversationViewController()
        conversationViewController.contactTitle = contact.name
        conversationViewController.isMessageEmpty = (contact.message == nil) ? true : false
        navigationController?.pushViewController(conversationViewController, animated: true)
    }
}
