//
//  TableViewDelegate.swift
//  ChatApp
//
//  Created by Anna Belousova on 10.05.2022.
//

import UIKit

extension ConversationsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let conversationViewController = RootAssembly.presentationAssembly.getConversationViewController()
        conversationViewController.selectedChannel = dataSource.fetchedResultsController?.object(at: indexPath)
        conversationViewController.context = model.mainContext
        navigationController?.pushViewController(conversationViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, _ in
            guard let channel = self?.dataSource.fetchedResultsController?.object(at: indexPath) else { return }
            self?.model.deleteChannel(channel)
        }
        deleteAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}
