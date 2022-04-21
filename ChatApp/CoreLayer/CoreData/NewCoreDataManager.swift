//
//  NewCoreDataManager.swift
//  ChatApp
//
//  Created by Anna Belousova on 05.04.2022.
//

import Foundation
import CoreData

final class NewCoreDataManager: ICoreData {
    
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DatabaseModel")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                assertionFailure("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var readContext = persistentContainer.viewContext

    func performSave(_ block: @escaping(NSManagedObjectContext) -> Void) {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
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
}

final class NewCoreDataContainer: ISavingToCoreData, ICoreDataContext {
    
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DatabaseModel")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                assertionFailure("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var readContext = persistentContainer.viewContext

    func performSave(_ block: @escaping(NSManagedObjectContext) -> Void) {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.perform {
            block(context)
            if context.hasChanges {
                do {
                    try context.save()
                    print(#function, "try save")
                } catch {
                    let nserror = error as NSError
                    assertionFailure("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    }
}
