//
//  ConversationViewController.swift
//  ChatApp
//
//  Created by Anna Belousova on 10.03.2022.
//

import UIKit

class ConversationViewController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let cellIdentifier = "MessageCell"
    private let messages = Message.allMessages
    var contactTitle: String?
    var isMessageEmpty: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        title = contactTitle
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
        tableView.register(MessageCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.separatorStyle = .none
    }
}

extension ConversationViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isMessageEmpty == false { return messages.count }
        else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.selectionStyle = .none
        guard let messageCell = cell as? MessageCell else { return cell }
        messageCell.configure(messageText: messages[indexPath.row].text, isIncomingMessage: messages[indexPath.row].isIncomingMessage)
        return messageCell
    }
}
