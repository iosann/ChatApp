//
//  OldCoreDataManager.swift
//  ChatApp
//
//  Created by Anna Belousova on 07.04.2022.
//

import Foundation
import CoreData

protocol ICoreData: AnyObject {
    func fetchChannels() -> [DBChannel]
    func fetchMassages() -> [DBMessage]
    func performSave(_ block: @escaping(NSManagedObjectContext) -> Void)
    var readContext: NSManagedObjectContext { get }
}

class OldCoreDataManager: ICoreData {
    
    private var managedObjectModel: NSManagedObjectModel = {
        if let url = Bundle.main.url(forResource: "DatabaseModel", withExtension: "momd"),
           let model = NSManagedObjectModel(contentsOf: url) {
               return model
           } else {
               return NSManagedObjectModel()
           }
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let persistentStoreUrl = path?.appendingPathComponent("DatabaseModel.sqlite")
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: persistentStoreUrl)
        } catch {
            assertionFailure(error.localizedDescription)
        }
        return coordinator
    }()
    
    lazy var readContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        return context
    }()
    
    lazy var writeContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }()
    
    func fetchChannels() -> [DBChannel] {
        let request = DBChannel.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "lastActivity", ascending: false)]
        do {
            let channels = try readContext.fetch(request)
            return channels
        } catch {
            assertionFailure(error.localizedDescription)
            return [DBChannel]()
        }
    }
    
    func fetchMassages() -> [DBMessage] {
        let request = DBMessage.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "created", ascending: true)]
        do {
            let messages = try readContext.fetch(request)
            return messages
        } catch {
            assertionFailure(error.localizedDescription)
            return [DBMessage]()
        }
    }
    
    func performSave(_ block: @escaping(NSManagedObjectContext) -> Void) {
        let context = writeContext
        context.perform {
            block(context)
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    let nserror = error as NSError
                    assertionFailure("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    }
}
