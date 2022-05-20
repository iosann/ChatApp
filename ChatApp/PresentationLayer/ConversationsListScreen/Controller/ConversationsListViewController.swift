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
    let dataSource = TableViewDataSource()
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    let model: IConversationsListModel
    private var isThemeOpened = false
    
    let transition = PopTransitionAnimator()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<DBChannel> = {
        guard let context = model.mainContext else { return NSFetchedResultsController<DBChannel>() }
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
    
    init(model: IConversationsListModel, presentationAssembly: IPresentationAssembly) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.cellIdentifier = cellIdentifier
        dataSource.fetchedResultsController = fetchedResultsController
        tableView.dataSource = dataSource
        NotificationCenter.default.addObserver(self, selector: #selector(updateMainContext), name: .NSManagedObjectContextDidSave, object: nil)
        loadChannels()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isThemeOpened {
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: ThemeManager.currentTheme?.tintColor as Any]
            tableView.reloadData()
        }
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
        
        transition.dismissCompletion = {
            guard let navigationBarSubviews = self.navigationController?.navigationBar.subviews else { return }
            for subview in navigationBarSubviews {
                for view in subview.subviews where view.bounds.width < 50 {
                    view.isHidden = false
                }
            }
        }
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
        model.loadChannels()
    }
    
    @objc private func openProfile() {
        let profileViewController = RootAssembly.presentationAssembly.getProfileViewController()
        let navigationController = UINavigationController(rootViewController: profileViewController)
        navigationController.transitioningDelegate = self
        self.present(navigationController, animated: true)
        isThemeOpened = false
    }
    
    @objc private func openThemes() {
        let themesViewController = RootAssembly.presentationAssembly.getThemesViewController()
        navigationController?.pushViewController(themesViewController, animated: true)
        isThemeOpened = true
    }
    
    @objc private func addChannel() {
        let alert = UIAlertController(title: "Add channel name", message: nil, preferredStyle: .alert)
        let createAction = UIAlertAction(title: "Create", style: .cancel) { [weak self] _ in
            let channel = Channel(name: alert.textFields?.first?.text, lastActivity: Date())
            self?.model.addChannel(data: channel.toDict)
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
        model.mergeChanges(notification: notification)
    }
}
