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
    
    let cellIdentifier = "MessageCell"
    let myDeviceId = UserDefaults.standard.string(forKey: "DeviceId")
    private var composeBar = ComposeBarView()
    var selectedChannel: DBChannel?
    var context: NSManagedObjectContext?
    let tableView = UITableView(frame: .zero, style: .insetGrouped)

    let model: IConversationModel? = ConversationModel()
    
    override var inputAccessoryView: UIView? {
        return composeBar
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController<DBMessage> = {
        guard let context = context else { return NSFetchedResultsController<DBMessage>() }
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
        composeBar.imageButton.addTarget(self, action: #selector(chooseImage), for: .touchUpInside)
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
        setupComposeBar()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1),
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

    private func loadMessages() {
        model?.loadMessages(selectedChannelId: selectedChannel?.identifier)
    }
     
    @objc private func dismissKeyboard() {
        composeBar.textView.resignFirstResponder()
        composeBar.textView.text = TextConstants.textViewPlaceholder
        composeBar.textViewHeight.constant = 38
    }
    
    @objc private func sendNewMessage() {
        let text = composeBar.textView.text
        let message = Message(content: text, created: Date(), senderId: myDeviceId, senderName: "")
        model?.addMessage(selectedChannelId: selectedChannel?.identifier, data: message.toDict)
        dismissKeyboard()
    }
    
    @objc private func chooseImage() {
        let imagesController = ImagesCollectionViewController()
        imagesController.callback = { [weak self] urlString in
            self?.composeBar.textView.becomeFirstResponder()
            self?.composeBar.textView.text = urlString
            self?.composeBar.textViewHeight.constant = self?.composeBar.textViewContentSize().height ?? 38
        }
        self.present(imagesController, animated: true)
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
