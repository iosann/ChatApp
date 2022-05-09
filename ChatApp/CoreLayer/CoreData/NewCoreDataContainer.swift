//
//  NNewCoreDataContainer.swift
//  ChatApp
//
//  Created by Anna Belousova on 05.04.2022.
//

import Foundation
import CoreData

protocol ICoreDataStorage: AnyObject {
    func performSave(_ block: @escaping(NSManagedObjectContext) -> Void)
    var readContext: NSManagedObjectContext { get }
}

final class NewCoreDataContainer: ICoreDataStorage {
    
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DatabaseModel")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                assertionFailure("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var readContext = Self.persistentContainer.viewContext

    func performSave(_ block: @escaping(NSManagedObjectContext) -> Void) {
        let context = Self.persistentContainer.newBackgroundContext()
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
}
