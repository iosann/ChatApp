//
//  TableViewDataSource.swift
//  ChatApp
//
//  Created by Anna Belousova on 21.04.2022.
//

import UIKit
import CoreData

class TableViewDataSource: NSObject, UITableViewDataSource {
    
    var cellIdentifier: String?
    var fetchedResultsController: NSFetchedResultsController<DBChannel>?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController?.sections else { return 0 }
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier ?? "", for: indexPath)
        guard let conversationCell = cell as? ConversationCell else { return cell }
        guard let channel = fetchedResultsController?.object(at: indexPath) else { return cell }
        conversationCell.configure(name: channel.name, message: channel.lastMessage, date: channel.lastActivity)
        return conversationCell
    }
}
