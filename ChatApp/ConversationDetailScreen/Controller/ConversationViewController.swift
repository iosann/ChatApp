//
//  ConversationViewController.swift
//  ChatApp
//
//  Created by Anna Belousova on 10.03.2022.
//

import UIKit
import Firebase
import CoreData

class ConversationViewController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let cellIdentifier = "MessageCell"
    private let db = Firestore.firestore()
    private lazy var reference = db.collection("channels").document(selectedChannel?.identifier ?? "").collection("messages")
    private let myDeviceId = UserDefaults.standard.string(forKey: "DeviceId")
    private var composeBar = ComposeBarView()
    var selectedChannel: DBChannel?
    weak var delegate: ICoreData?
    
    override var inputAccessoryView: UIView? {
        return composeBar
    }
    
    private lazy var fetchedResultsController: NSFetchedResultsController<DBMessage> = {
        guard let context = delegate?.readContext else { return NSFetchedResultsController<DBMessage>() }
        let fetchRequest = DBMessage.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "channel == %@", selectedChannel ?? DBChannel())
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(DBMessage.created), ascending: true)]

        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        do {
            try controller.performFetch()
        } catch {
            assertionFailure(error.localizedDescription)
        }
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        getMessagesFromFirestore()
        setupUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillChangeFrameNotification)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillHideNotification)
    }
    
    private func setupUI() {
        title = selectedChannel?.name
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
    
    private func getMessagesFromFirestore() {
        reference.addSnapshotListener { [weak self] snapshot, error in
            guard error == nil, let snapshot = snapshot else {
                assertionFailure(error?.localizedDescription ?? "")
                return
            }
            self?.delegate?.performSave { context in
                self?.saveMessages(snapshot: snapshot, context: context)
            }
        }
    }
    
    private func saveMessages(snapshot: QuerySnapshot, context: NSManagedObjectContext) {
        snapshot.documents.forEach {
            let timestampDate = ($0.data()["created"] as? Timestamp)?.dateValue()
            let date = timestampDate != nil ? timestampDate : "2022-01-01T17:29:50Z".formattedDate

            let dbmessage = DBMessage(context: context)
            dbmessage.identifier = $0.documentID
            dbmessage.content = $0.data()["content"] as? String
            dbmessage.created = date
            dbmessage.senderId = $0.data()["senderID"] as? String
            dbmessage.senderName = $0.data()["senderName"] as? String
            dbmessage.channel = selectedChannel
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
//        DispatchQueue.main.async { [weak self] in
//            guard let self = self, !self.messages.isEmpty else { return }
//            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
//            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
//        }
    }
}

extension ConversationViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else { return 0 }
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        guard let messageCell = cell as? MessageCell else { return cell }

        let message = fetchedResultsController.object(at: indexPath)
        let isIncoming = message.senderId == myDeviceId ? false : true
        messageCell.configure(messageText: message.content, date: message.created, isIncomingMessage: isIncoming, senderName: message.senderName)
        return messageCell
    }
}

extension ConversationViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        switch type {
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .fade)
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .fade)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .fade)
        @unknown default: return
        }
    }
}
