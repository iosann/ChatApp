//
//  NNewCoreDataContainer.swift
//  ChatApp
//
//  Created by Anna Belousova on 05.04.2022.
//

import Foundation
import CoreData

protocol ISavingToCoreData: AnyObject {
    func performSave(_ block: @escaping(NSManagedObjectContext) -> Void)
}

protocol ICoreDataContext {
    var readContext: NSManagedObjectContext { get }
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
