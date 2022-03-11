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
    let messages = Message.allMessages
    var contactTitle: String?

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
        messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        guard let messageCell = cell as? MessageCell else { return cell }
        messageCell.messageLabel.text = messages[indexPath.row].text
        if messages[indexPath.row].isIncomingMessage == true { messageCell.setupConstraintsForIncomingMessage() }
        else { messageCell.setupConstraintsForOutgoingMessage() }
        return messageCell
    }
}
