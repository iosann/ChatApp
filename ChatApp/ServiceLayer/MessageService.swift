//
//  MessageService.swift
//  ChatApp
//
//  Created by Anna Belousova on 21.04.2022.
//

import Foundation
import Firebase
import CoreData

protocol IMessageService: AnyObject {
    func loadAndSaveMessages(selectedChannelId: String?)
    func addMessage(data: [String: Any])
}

class MessageService {
    
    private var firestoreDatabase: IFirestoreMessages? = FirestoreDatabase()
    private let coreDataStorage: ISavingToCoreData? = NewCoreDataContainer()
}

extension MessageService: IMessageService {
    
    func addMessage(data: [String: Any]) {
        firestoreDatabase?.addMessage(data: data)
    }
    
    func loadAndSaveMessages(selectedChannelId: String?) {
        firestoreDatabase?.selectedChannelId = selectedChannelId
        firestoreDatabase?.loadMessages { [weak self] result in
            switch result {
            case .success(let snapshot):
                self?.coreDataStorage?.performSave { context in
                    self?.saveMessages(selectedChannelId: selectedChannelId, snapshot: snapshot, context: context)
                }
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    private func saveMessages(selectedChannelId: String?, snapshot: QuerySnapshot, context: NSManagedObjectContext) {
        guard let selectedChannelId = selectedChannelId else { return }
        let request = DBChannel.fetchRequest()
        request.predicate = NSPredicate(format: "identifier == %@", selectedChannelId)
        do {
            let channel = try context.fetch(request).first
             
            snapshot.documents.forEach {
                let timestampDate = ($0.data()["created"] as? Timestamp)?.dateValue()
                let date = timestampDate != nil ? timestampDate : "2022-01-01T17:29:50Z".formattedDate

                let dbmessage = DBMessage(context: context)
                dbmessage.identifier = $0.documentID
                dbmessage.content = $0.data()["content"] as? String
                dbmessage.created = date
                dbmessage.senderId = $0.data()["senderID"] as? String
                dbmessage.senderName = $0.data()["senderName"] as? String
                dbmessage.channel = channel
            }
        } catch {
              assertionFailure(error.localizedDescription)
        }
    }
}
