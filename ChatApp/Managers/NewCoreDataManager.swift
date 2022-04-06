//
//  NewCoreDataManager.swift
//  ChatApp
//
//  Created by Anna Belousova on 05.04.2022.
//

import Foundation
import CoreData

final class NewCoreDataManager {
    
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DatabaseModel")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                assertionFailure("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func performSave(_ block: @escaping(NSManagedObjectContext) -> Void) {
        let context = persistentContainer.newBackgroundContext()
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
        do {
            let channels = try persistentContainer.viewContext.fetch(request)
            return channels
        } catch {
            assertionFailure(error.localizedDescription)
            return [DBChannel]()
        }
    }
}
