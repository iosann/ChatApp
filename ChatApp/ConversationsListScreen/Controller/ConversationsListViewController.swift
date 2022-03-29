//
//  ConversationsListViewController.swift
//  ChatApp
//
//  Created by Anna Belousova on 09.03.2022.
//

import UIKit
import FirebaseFirestore

class ConversationsListViewController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let cellIdentifier = "ConversationCell"
    private let db = Firestore.firestore()
    private lazy var reference = db.collection("channels")
    private var channels = [Channel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getChannels()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: ThemeManager.shared.currentTheme.tintColor]
    }
    
    private func setupUI() {
        title = "Channels"
        var iconAvatarImage = UIImage(named: "avatar_icon")
        iconAvatarImage = iconAvatarImage?.withRenderingMode(.alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: iconAvatarImage, style: .plain, target: self, action: #selector(openProfile))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_settings"), style: .plain, target: self, action: #selector(openThemes))
        setupTableView()
    }
    
    private func getChannels() {
        reference.addSnapshotListener { [weak self] snapshot, error in
            guard error == nil else {
                print(error?.localizedDescription)
                return
            }
            guard let snapshot = snapshot else { return }
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
