//
//  CoreDataMock.swift
//  UnitTestsChatApp
//
//  Created by Anna Belousova on 19.05.2022.
//

import CoreData
@testable import ChatApp

final class CoreDataMock: ICoreDataStorage {

    var invokedReadContextGetter = false
    var invokedReadContextGetterCount = 0
    var stubbedReadContext: NSManagedObjectContext?

    var readContext: NSManagedObjectContext {
        invokedReadContextGetter = true
        invokedReadContextGetterCount += 1
        return stubbedReadContext ?? NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    }

    var invokedPerformSave = false
    var invokedPerformSaveCount = 0
    var stubbedPerformSaveBlockResult: (NSManagedObjectContext, Void)?

    func performSave(_ block: @escaping(NSManagedObjectContext) -> Void) {
        invokedPerformSave = true
        invokedPerformSaveCount += 1
        if let result = stubbedPerformSaveBlockResult {
            block(result.0)
        }
    }
}
