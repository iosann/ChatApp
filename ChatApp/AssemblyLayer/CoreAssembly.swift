//
//  CoreAssembly.swift
//  ChatApp
//
//  Created by Anna Belousova on 09.05.2022.
//

import Foundation

protocol ICoreAssembly {
    var coreDataStorage: ICoreDataStorage { get }
    var firestoreDatabase: IFirestoreDatabase { get }
    var requestSender: IRequestSender { get }
    var fileManagerStorage: IFileManagerStorage { get set }
}

class CoreAssembly: ICoreAssembly {
    let coreDataStorage: ICoreDataStorage = NewCoreDataContainer()
    let firestoreDatabase: IFirestoreDatabase = FirestoreDatabase()
    let requestSender: IRequestSender = RequestSender()
    var fileManagerStorage: IFileManagerStorage = FileManagerStorage()
}
