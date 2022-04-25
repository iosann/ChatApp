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
    
    private let cellIdentifier = "ConversationCell"
    private let dataSource = TableViewDataSource()
    private let channelServiceInstance = ChannelService()
    weak var gettingChannelService: IGettingChannel?
    weak var serviceContext: IServiceCoreDataContext?
    weak var editingChannelService: IEditingChannels?
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private lazy var fetchedResultsController: NSFetchedResultsController<DBChannel> = {
        guard let context = serviceContext?.coreDataContext?.readContext else { return NSFetchedResultsController<DBChannel>() }
        let fetchRequest = DBChannel.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(DBChannel.lastActivity), ascending: false)]
        fetchRequest.fetchBatchSize = 15
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
        self.serviceContext = channelServiceInstance
        self.gettingChannelService = channelServiceInstance
        self.editingChannelService = channelServiceInstance
        dataSource.cellIdentifier = cellIdentifier
        dataSource.fetchedResultsController = fetchedResultsController
        tableView.dataSource = dataSource
        NotificationCenter.default.addObserver(self, selector: #selector(updateMainContext), name: .NSManagedObjectContextDidSave, object: nil)
        loadChannels()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: ThemeManager.currentTheme?.tintColor as Any]
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
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.separatorStyle = .none
    }
    
    private func loadChannels() {
        gettingChannelService?.loadAndSaveChannels()
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
            let channel = Channel(name: alert.textFields?.first?.text, lastActivity: Date())
            self?.editingChannelService?.addChannel(data: channel.toDict)
        }
        alert.addAction(createAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        alert.addAction(cancelAction)
        alert.addTextField { textField in
            textField.placeholder = "Enter channel name"
        }
        present(alert, animated: true)
    }
    
    @objc private func updateMainContext(_ notification: Notification) {
        gettingChannelService?.mergeChanges(notification)
    }
}

extension ConversationsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let conversationViewController = ConversationViewController()
        conversationViewController.selectedChannel = dataSource.fetchedResultsController?.object(at: indexPath)
        conversationViewController.context = serviceContext
        navigationController?.pushViewController(conversationViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, _ in
            let channel = self?.dataSource.fetchedResultsController?.object(at: indexPath)
            self?.editingChannelService?.deleteChannel(channel)
           }
           deleteAction.backgroundColor = .red
           let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
           return configuration
    }
}
