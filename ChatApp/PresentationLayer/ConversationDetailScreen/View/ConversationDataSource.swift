//
//  ConversationDataSource.swift
//  ChatApp
//
//  Created by Anna Belousova on 28.04.2022.
//

import UIKit

extension ConversationViewController: UITableViewDataSource {
    
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

        if let content = message.content, content.hasPrefix("http") {
            guard let resource = URL(string: content) else { return cell }
            do {
                let data = try Data(contentsOf: resource)
                DispatchQueue.main.async {
                    messageCell.messageImageView.image = UIImage(data: data)
                    messageCell.messageImageView.isHidden = false
                }
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
        return messageCell
    }
}
