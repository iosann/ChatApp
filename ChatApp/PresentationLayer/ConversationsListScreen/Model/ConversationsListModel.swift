//
//  ConversationsListModel.swift
//  ChatApp
//
//  Created by Anna Belousova on 27.04.2022.
//

import Firebase
import CoreData

protocol IConversationsListModel: AnyObject {
    var mainContext: NSManagedObjectContext? { get }
    func loadChannels()
    func addChannel(data: [String: Any])
    func deleteChannel(_ channel: DBChannel)
    func mergeChanges(notification: Notification)
}

class ConversationsListModel: IConversationsListModel {
    
    private let loadingFirestoreServise: ILoadingFirestoreServise
    private let deletingFirestoreServise: IDeletingFirestoreServise
    private let mergingCoreDataService: IMergingCoreDataService
    private let coreDataService: ICoreDataService
    
    init(coreDataService: ICoreDataService, mergingCoreDataService: IMergingCoreDataService,
         loadingFirestoreServise: ILoadingFirestoreServise, deletingFirestoreServise: IDeletingFirestoreServise) {
        self.coreDataService = coreDataService
        self.mergingCoreDataService = mergingCoreDataService
        self.loadingFirestoreServise = loadingFirestoreServise
        self.deletingFirestoreServise = deletingFirestoreServise
    }
    
    var mainContext: NSManagedObjectContext? {
        return coreDataService.readContext
    }
    
    func loadChannels() {
        loadingFirestoreServise.loadData(reference: URLConstants.referenceToChannels) { [weak self] result in
            switch result {
            case .success(let snapshot):
                self?.coreDataService.saveData { context in
                    self?.saveChannels(snapshot: snapshot, context: context)
                }
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    func addChannel(data: [String: Any]) {
        loadingFirestoreServise.addDocument(reference: URLConstants.referenceToChannels, data: data)
    }
    
    func deleteChannel(_ channel: DBChannel) {
        let channelId = channel.identifier
        mainContext?.delete(channel)
           do {
               try mainContext?.save()
           } catch {
               assertionFailure(error.localizedDescription)
           }
        deletingFirestoreServise.deleteChannel(channelId)
    }
    
    func mergeChanges(notification: Notification) {
        mergingCoreDataService.mergeChanges(notification)
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
}
