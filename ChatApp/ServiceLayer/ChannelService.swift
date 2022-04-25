//
//  ChannelService.swift
//  ChatApp
//
//  Created by Anna Belousova on 21.04.2022.
//

import UIKit
import CoreData
import Firebase

protocol IGettingChannel: AnyObject {
    func loadAndSaveChannels()
    func mergeChanges(_ notification: Notification)
}

protocol IEditingChannels: AnyObject {
    func addChannel(data: [String: Any])
    func deleteChannel(_ channel: DBChannel?)
}

protocol IServiceCoreDataContext: AnyObject {
    var coreDataContext: ICoreDataContext? { get }
}

class ChannelService: IServiceCoreDataContext {
    
    private let firestoreDatabase: IFirestoreChannels? = FirestoreDatabase()
    private let coreDataStorage: ISavingToCoreData? = NewCoreDataContainer()
//    private let coreDataStorage: ICoreData = OldCoreDataCoordinator()
    
    let coreDataContext: ICoreDataContext? = NewCoreDataContainer()
//    private let iCoreDataContext: ICoreDataContext? = OldCoreDataCoordinator()
}

extension ChannelService: IGettingChannel {
    
    func loadAndSaveChannels() {
        firestoreDatabase?.loadChannels { [weak self] result in
            switch result {
            case .success(let snapshot):
                self?.coreDataStorage?.performSave { context in
                    self?.saveChannels(snapshot: snapshot, context: context)
                }
            case .failure(let error):
                assertionFailure(error.localizedDescription)
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
    
    func mergeChanges(_ notification: Notification) {
        guard let context = notification.object as? NSManagedObjectContext, context != coreDataContext?.readContext else { return }
        coreDataContext?.readContext.mergeChanges(fromContextDidSave: notification)
    }
}

extension ChannelService: IEditingChannels {
    
    func addChannel(data: [String: Any]) {
        firestoreDatabase?.addChannel(data: data)
    }
    
    func deleteChannel(_ channel: DBChannel?) {
        guard let channel = channel else { return }
        let channelId = channel.identifier
        coreDataContext?.readContext.delete(channel)
        do {
            try coreDataContext?.readContext.save()
        } catch {
            assertionFailure(error.localizedDescription)
        }
        firestoreDatabase?.deleteChannelAndNestedMessages(channelId: channelId)
    }
}
