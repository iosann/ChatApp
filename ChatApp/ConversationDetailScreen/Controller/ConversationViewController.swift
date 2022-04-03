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
    private var composeBar = ComposeBarView()
    var selectedChannelId: String?
    var titleText: String?
    
    override var inputAccessoryView: UIView? {
        return composeBar
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getMessages()
        setupUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillChangeFrameNotification)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillHideNotification)
    }
    
    private func setupUI() {
        title = titleText
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: ThemeManager.shared.currentTheme.tintColor]
        composeBar.sendButton.addTarget(self, action: #selector(sendNewMessage), for: .touchUpInside)
        view.backgroundColor = ThemeManager.shared.currentTheme.backgroundColor
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        setupTableView()
        setupComposeBar()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -45)
        ])
        tableView.register(MessageCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.separatorStyle = .none
    }
    
    private func setupComposeBar() {
        view.addSubview(composeBar)
        composeBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            composeBar.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0),
            composeBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            composeBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func getMessages() {
        reference.addSnapshotListener { [weak self] snapshot, error in
            guard error == nil else {
                print(String(describing: error?.localizedDescription))
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
            self?.scrollToBottom()
        }
    }
    
    @objc private func dismissKeyboard() {
        composeBar.textView.resignFirstResponder()
        composeBar.textView.text = Constants.textViewPlaceholder
        composeBar.textViewHeight.constant = 38
    }
    
    @objc private func sendNewMessage() {
        let text = composeBar.textView.text
        let message = Message(content: text, created: Date(), senderId: myDeviceId, senderName: "")
        reference.addDocument(data: message.toDict)
        dismissKeyboard()
    }

    @objc private func keyboardWillHide(notification: Notification) {
        self.view.frame.origin.y = 0
    }
    
    @objc private func keyboardWillChangeFrame(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyboardSize.cgRectValue
        if keyboardFrame.height > 100, self.view.frame.origin.y > -100 {
            self.view.frame.origin.y -= keyboardFrame.height * 0.85
        }
    }
    
    private func scrollToBottom() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self, !self.messages.isEmpty else { return }
            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
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
        let isIncoming = message.senderId == myDeviceId ? false : true
        messageCell.configure(messageText: message.content, date: message.created, isIncomingMessage: isIncoming, senderName: message.senderName)
        return messageCell
    }
}
