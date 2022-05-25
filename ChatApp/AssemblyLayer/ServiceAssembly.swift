//
//  ServicesAssembly.swift
//  ChatApp
//
//  Created by Anna Belousova on 09.05.2022.
//

import Foundation

protocol IServiceAssembly {
    var coreDataService: ICoreDataService { get }
    var mergingCoreDataService: IMergingCoreDataService { get }
    var loadingFirestoreServise: ILoadingFirestoreServise { get }
    var deletingFirestoreServise: IDeletingFirestoreServise { get }
    var networkImageService: INetworkImageService { get }
    var gcdStorageService: IStorageService { get set }
    var operationStorageService: IStorageService { get set }
    var themeManager: IThemeManager { get set }
}

class ServiceAssembly: IServiceAssembly {
    
    private let coreAssembly: ICoreAssembly
    
    init(coreAssembly: ICoreAssembly) {
        self.coreAssembly = coreAssembly
    }
    
    lazy var coreDataService: ICoreDataService = CoreDataService(coreDataStorage: coreAssembly.coreDataStorage)
    lazy var mergingCoreDataService: IMergingCoreDataService = CoreDataService(coreDataStorage: coreAssembly.coreDataStorage)
    lazy var loadingFirestoreServise: ILoadingFirestoreServise = FirestoreService(firestoreDatabase: coreAssembly.firestoreDatabase)
    lazy var deletingFirestoreServise: IDeletingFirestoreServise = FirestoreService(firestoreDatabase: coreAssembly.firestoreDatabase)
    lazy var networkImageService: INetworkImageService = NetworkImageService(requestSender: coreAssembly.requestSender)
    lazy var gcdStorageService: IStorageService = GCDStorageService(fileManagerStorage: coreAssembly.fileManagerStorage)
    lazy var operationStorageService: IStorageService = OperationStorageService(fileManagerStorage: coreAssembly.fileManagerStorage)
    lazy var themeManager: IThemeManager = ThemeManager()
}
