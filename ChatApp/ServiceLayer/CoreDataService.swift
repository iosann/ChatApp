//
//  CoreDataService.swift
//  ChatApp
//
//  Created by Anna Belousova on 27.04.2022.
//

import CoreData

protocol ICoreDataService {
    var contextCoreData: ICoreDataContext? { get }
    func saveData(_ block: @escaping(NSManagedObjectContext) -> Void)
}

protocol IMergingCoreDataService {
    func mergeChanges(_ notification: Notification)
}

class CoreDataService: ICoreDataService, IMergingCoreDataService {
    
    let contextCoreData: ICoreDataContext? = NewCoreDataContainer()
    private let savingCoreData: ISavingToCoreData? = NewCoreDataContainer()
    
    func saveData(_ block: @escaping(NSManagedObjectContext) -> Void) {
        savingCoreData?.performSave(block)
    }
    
    func mergeChanges(_ notification: Notification) {
        guard let context = notification.object as? NSManagedObjectContext, context != contextCoreData?.readContext else { return }
        contextCoreData?.readContext.mergeChanges(fromContextDidSave: notification)
    }
}
