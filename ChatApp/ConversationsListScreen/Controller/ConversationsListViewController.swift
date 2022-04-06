//
//  ConversationsListViewController.swift
//  ChatApp
//
//  Created by Anna Belousova on 09.03.2022.
//

import UIKit
import FirebaseFirestore
import CoreData

class ConversationsListViewController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let cellIdentifier = "ConversationCell"
    private let db = Firestore.firestore()
    private lazy var reference = db.collection("channels")
    private var channels = [Channel]()
    private let newCoreDataManager = NewCoreDataManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        getChannels()
        setupUI()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let channels = self.newCoreDataManager.fetchChannels()
            for channel in channels {
                print(channel.name, channel.identifier, channel.lastMessage, channel.lastActivity)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: ThemeManager.shared.currentTheme.tintColor]
        tableView.reloadData()
    }
    
    private func setupUI() {
        title = "Channels"
        var iconAvatarImage = UIImage(named: "avatar_icon")
        iconAvatarImage = iconAvatarImage?.withRenderingMode(.alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: iconAvatarImage, style: .plain, target: self, action: #selector(openProfile))
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(image: UIImage(named: "icon_settings"), style: .plain, target: self, action: #selector(openThemes)),
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addChannel))]
        setupTableView()
    }
    
    private func getChannels() {
        reference.addSnapshotListener { [weak self] snapshot, error in
            guard error == nil else {
                print(String(describing: error?.localizedDescription))
                return
            }
            guard let snapshot = snapshot else { return }
            self?.channels = []
            snapshot.documents.forEach {
                let date = ($0.data()["lastActivity"] as? Timestamp)?.dateValue()
                let timestampDate = date != nil ? date : "2022-01-01T17:29:50Z".formattedDate
                let channel = Channel(identifier: $0.documentID,
                                      name: $0.data()["name"] as? String,
                                      lastMessage: $0.data()["lastMessage"] as? String,
                                      lastActivity: timestampDate)
                self?.channels.append(channel)
            }
            self?.channels.sort { $0.lastActivity?.compare($1.lastActivity ?? Date()) == .orderedDescending }
            self?.tableView.reloadData()
            
            self?.newCoreDataManager.performSave { [weak self] context in
                guard let self = self else { return }
                for channel in self.channels {
                    print(self.isExist(channel: channel), channel.name)
                    if !self.isExist(channel: channel) {
                        let dbChannel = DBChannel(context: context)
                        dbChannel.name = channel.name
                        dbChannel.lastMessage = channel.lastMessage
                        dbChannel.lastActivity = channel.lastActivity
                        dbChannel.identifier = channel.identifier
                    }
                }
            }
        }
    }
    
    func isExist(channel: Channel) -> Bool {
        let identifierPredicate = NSPredicate(format: "identifier == %@", channel.identifier ?? "")
 //       let lastMessagePredicate = NSPredicate(format: "lastMessage == %@", channel.lastMessage ?? "")
        let context = newCoreDataManager.persistentContainer.newBackgroundContext()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DBChannel")
        request.predicate = identifierPredicate
        do {
            if Thread.isMainThread { print("is main do result")
        } else { print("is background") }
            let result = try context.count(for: request)
            if Thread.isMainThread { print("is main after result")
        } else { print("is background") }
            if result > 0 {
                return true
            } else {
                return false
            }
        } catch {
            assertionFailure(error.localizedDescription)
            return false
        }
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
    
    @objc private func openProfile() {
        let profileViewController = ProfileViewController()
        let navigationController = UINavigationController(rootViewController: profileViewController)
        self.present(navigationController, animated: true)
    }
    
    @objc private func openThemes() {
        let themesViewController = ThemesViewController()
        navigationController?.pushViewController(themesViewController, animated: true)
    }
    
    @objc private func addChannel() {
        let alert = UIAlertController(title: "Add channel name", message: nil, preferredStyle: .alert)
        let createAction = UIAlertAction(title: "Create", style: .cancel) { [weak self] _ in
            let channel = Channel(identifier: nil, name: alert.textFields?.first?.text, lastMessage: nil, lastActivity: Date())
            self?.reference.addDocument(data: channel.toDict)
        }
        alert.addAction(createAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        alert.addAction(cancelAction)
        alert.addTextField { textField in
            textField.placeholder = "Enter channel name"
        }
        present(alert, animated: true)
    }
}

extension ConversationsListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        guard let conversationCell = cell as? ConversationCell else { return cell }
        let channel = channels[indexPath.row]
        conversationCell.configure(name: channel.name, message: channel.lastMessage, date: channel.lastActivity)
        return conversationCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let conversationViewController = ConversationViewController()
        conversationViewController.selectedChannelId = channels[indexPath.row].identifier
        conversationViewController.titleText = channels[indexPath.row].name
        navigationController?.pushViewController(conversationViewController, animated: true)
    }
}
