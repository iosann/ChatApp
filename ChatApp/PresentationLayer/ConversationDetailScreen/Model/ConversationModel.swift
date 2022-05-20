//
//  ConversationModel.swift
//  ChatApp
//
//  Created by Anna Belousova on 27.04.2022.
//

import Firebase
import CoreData

protocol IConversationModel: AnyObject {
    func loadMessages(selectedChannelId: String?)
    func addMessage(selectedChannelId: String?, data: [String: Any])
}

class ConversationModel: IConversationModel {
    
    private let loadingFirestoreServise: ILoadingFirestoreServise
    private let coreDataService: ICoreDataService
    
    init(coreDataService: ICoreDataService, loadingFirestoreServise: ILoadingFirestoreServise) {
        self.coreDataService = coreDataService
        self.loadingFirestoreServise = loadingFirestoreServise
    }

    func loadMessages(selectedChannelId: String?) {
        let reference = URLConstants.referenceToChannels.document(selectedChannelId ?? "").collection("messages")
        loadingFirestoreServise.loadData(reference: reference) { [weak self] result in
            switch result {
            case .success(let snapshot):
                self?.coreDataService.saveData { context in
                    self?.saveMessages(selectedChannelId: selectedChannelId, snapshot: snapshot, context: context)
                }
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    func addMessage(selectedChannelId: String?, data: [String: Any]) {
        loadingFirestoreServise.addDocument(reference: URLConstants.referenceToChannels.document(selectedChannelId ?? "").collection("messages"), data: data)
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
