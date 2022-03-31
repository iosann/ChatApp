//
//  ConversationViewController.swift
//  ChatApp
//
//  Created by Anna Belousova on 10.03.2022.
//

import UIKit
import Firebase

class ConversationViewController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let cellIdentifier = "MessageCell"
    private var messages = [Message]()
    private let db = Firestore.firestore()
    private lazy var reference = db.collection("channels").document(selectedChannelId ?? "").collection("messages")
    private let myDeviceId = UserDefaults.standard.string(forKey: "DeviceId")
    var selectedChannelId: String?
    var titleText: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        getMessages()
        setupTableView()
        title = titleText
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: ThemeManager.shared.currentTheme.tintColor]
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createNewMessage))
    }
    
    private func getMessages() {
        reference.addSnapshotListener { [weak self] snapshot, error in
            guard error == nil else {
                print(error?.localizedDescription)
                return
            }
            guard let snapshot = snapshot else { return }
            self?.messages = []
            snapshot.documents.forEach {
                let date = ($0.data()["created"] as? Timestamp)?.dateValue()
                let timestampDate = date != nil ? date : "2022-01-01T17:29:50Z".formattedDate
                let message = Message(content: $0.data()["content"] as? String,
                                      created: timestampDate,
                                      senderId: $0.data()["senderID"] as? String,
                                      senderName: $0.data()["senderName"] as? String)
                self?.messages.append(message)
            }
            self?.messages.sort { $0.created?.compare($1.created ?? Date()) == .orderedAscending }
            self?.tableView.reloadData()
        }
    }
    
    @objc private func createNewMessage() {
        let alert = UIAlertController(title: "Add message", message: nil, preferredStyle: .alert)
        let createAction = UIAlertAction(title: "Create", style: .cancel) { [weak self] _ in
            let text = alert.textFields?.first?.text
            let message = Message(content: text, created: Date(), senderId: self?.myDeviceId, senderName: "")
            self?.reference.addDocument(data: message.toDict)
        }
        alert.addAction(createAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        alert.addAction(cancelAction)
        alert.addTextField { textField in
            textField.placeholder = "Enter channel name"
        }
        present(alert, animated: true)
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
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        guard let messageCell = cell as? MessageCell else { return cell }
        let message = messages[indexPath.row]
        let isIncoming = message.senderId == myDeviceId ? true : false
        messageCell.configure(messageText: message.content, date: message.created, isIncomingMessage: isIncoming, senderName: message.senderName)
        return messageCell
    }
}
