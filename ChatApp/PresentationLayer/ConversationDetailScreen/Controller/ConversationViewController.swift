//
//  ConversationViewController.swift
//  ChatApp
//
//  Created by Anna Belousova on 10.03.2022.
//

import UIKit
import Firebase
import CoreData

class ConversationViewController: FetchedResultsViewController {
    
    private let cellIdentifier = "MessageCell"
    private let myDeviceId = UserDefaults.standard.string(forKey: "DeviceId")
    private var composeBar = ComposeBarView()
    var selectedChannel: DBChannel?
    var context: IServiceCoreDataContext?
    
    private let messageServiceInstance = MessageService()
    private weak var messageService: IMessageService?
    
    private let dataSource = MessageTableViewDataSource()
    
    override var inputAccessoryView: UIView? {
        return composeBar
    }
    
    private lazy var fetchedResultsController: NSFetchedResultsController<DBMessage> = {
        guard let context = context?.coreDataContext?.readContext else { return NSFetchedResultsController<DBMessage>() }
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
        self.messageService = messageServiceInstance
        dataSource.cellIdentifier = cellIdentifier
        dataSource.fetchedResultsController = fetchedResultsController
        loadMessages()
        setupUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillChangeFrameNotification)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillHideNotification)
    }
    
    private func setupUI() {
        title = selectedChannel?.name
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: ThemeManager.currentTheme?.tintColor as Any]
        composeBar.sendButton.addTarget(self, action: #selector(sendNewMessage), for: .touchUpInside)
        view.backgroundColor = ThemeManager.currentTheme?.backgroundColor
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
        configureTableView()
        setupComposeBar()
    }
    
    private func configureTableView() {
        tableView.dataSource = dataSource
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -45)
        ])
        tableView.register(MessageCell.self, forCellReuseIdentifier: cellIdentifier)
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

    private func loadMessages() {
        messageService?.loadAndSaveMessages(selectedChannelId: selectedChannel?.identifier)
    }
     
    @objc private func dismissKeyboard() {
        composeBar.textView.resignFirstResponder()
        composeBar.textView.text = Constants.textViewPlaceholder
        composeBar.textViewHeight.constant = 38
    }
    
    @objc private func sendNewMessage() {
        let text = composeBar.textView.text
        let message = Message(content: text, created: Date(), senderId: myDeviceId, senderName: "")
        messageService?.addMessage(data: message.toDict)
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
}
