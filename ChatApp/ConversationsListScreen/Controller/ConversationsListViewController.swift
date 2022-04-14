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
    private let newCoreDataManager = NewCoreDataManager()
    private let oldCoreDataManager = OldCoreDataManager()
    weak var delegate: ICoreData?
    
    private lazy var fetchedResultsController: NSFetchedResultsController<DBChannel> = {
        guard let context = delegate?.readContext else { return NSFetchedResultsController<DBChannel>() }
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
        self.delegate = newCoreDataManager
//        self.delegate = oldCoreDataManager
        NotificationCenter.default.addObserver(self, selector: #selector(updateMainContext), name: .NSManagedObjectContextDidSave, object: nil)
        getChannelsFromFirestore()
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
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(image: UIImage(named: "icon_settings"), style: .plain, target: self, action: #selector(openThemes)),
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addChannel))]
        setupTableView()
    }
    
    private func getChannelsFromFirestore() {
        reference.addSnapshotListener { [weak self] snapshot, error in
            guard error == nil, let snapshot = snapshot else {
                assertionFailure(error?.localizedDescription ?? "")
                return
            }
            self?.delegate?.performSave { context in
                self?.saveChannels(snapshot: snapshot, context: context)
            }
        }
    }
    
    private func saveChannels(snapshot: QuerySnapshot, context: NSManagedObjectContext) {
        snapshot.documents.forEach {
            let timestampDate = ($0.data()["lastActivity"] as? Timestamp)?.dateValue()
            let date = timestampDate != nil ? timestampDate : "2022-01-01T17:29:50Z".formattedDate
            
            let dbchannel = DBChannel(context: context)
            dbchannel.identifier = $0.documentID
            dbchannel.name = $0.data()["name"] as? String
            dbchannel.lastMessage = $0.data()["lastMessage"] as? String
            dbchannel.lastActivity = date
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
            let channel = Channel(name: alert.textFields?.first?.text, lastActivity: Date())
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
    
    @objc func updateMainContext(_ notification: Notification) {
        guard let context = notification.object as? NSManagedObjectContext, context != delegate?.readContext else { return }
        delegate?.readContext.mergeChanges(fromContextDidSave: notification)
    }
}

extension ConversationsListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else { return 0 }
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        guard let conversationCell = cell as? ConversationCell else { return cell }
        let channel = fetchedResultsController.object(at: indexPath)
        conversationCell.configure(name: channel.name, message: channel.lastMessage, date: channel.lastActivity)
        return conversationCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let conversationViewController = ConversationViewController()
        conversationViewController.selectedChannel = fetchedResultsController.object(at: indexPath)
        conversationViewController.delegate = delegate
        navigationController?.pushViewController(conversationViewController, animated: true)
    }
}

extension ConversationsListViewController: NSFetchedResultsControllerDelegate {
    
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
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        @unknown default: return
        }
    }
}
