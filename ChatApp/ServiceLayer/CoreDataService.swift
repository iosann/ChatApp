//
//  CoreDataService.swift
//  ChatApp
//
//  Created by Anna Belousova on 27.04.2022.
//

import CoreData

protocol ICoreDataService {
    var readContext: NSManagedObjectContext { get }
    func saveData(_ block: @escaping(NSManagedObjectContext) -> Void)
}

protocol IMergingCoreDataService {
    func mergeChanges(_ notification: Notification)
}

class CoreDataService: ICoreDataService, IMergingCoreDataService {
    
    private let coreDataStorage: ICoreDataStorage
    
    init(coreDataStorage: ICoreDataStorage) {
        self.coreDataStorage = coreDataStorage
    }
    
    lazy var readContext: NSManagedObjectContext = coreDataStorage.readContext
    
    func saveData(_ block: @escaping(NSManagedObjectContext) -> Void) {
        coreDataStorage.performSave(block)
    }
    
    func mergeChanges(_ notification: Notification) {
        guard let context = notification.object as? NSManagedObjectContext, context != coreDataStorage.readContext else { return }
        coreDataStorage.readContext.mergeChanges(fromContextDidSave: notification)
    }
}
