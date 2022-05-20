//
//  PresentationAssembly.swift
//  ChatApp
//
//  Created by Anna Belousova on 09.05.2022.
//

import Foundation
import UIKit

protocol IPresentationAssembly {
    func getConversationsListViewController() -> ConversationsListViewController
    func getConversationViewController() -> ConversationViewController
    func getImagesCollectionViewController() -> ImagesCollectionViewController
    func getProfileViewController() -> ProfileViewController
    func getThemesViewController() -> ThemesViewController
}

class PresentationAssembly: IPresentationAssembly {
    
    private let serviceAssembly: IServiceAssembly
    
    init(serviceAssembly: IServiceAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    func getConversationsListViewController() -> ConversationsListViewController {
        let model = ConversationsListModel(coreDataService: serviceAssembly.coreDataService,
                                           mergingCoreDataService: serviceAssembly.mergingCoreDataService,
                                           loadingFirestoreServise: serviceAssembly.loadingFirestoreServise,
                                           deletingFirestoreServise: serviceAssembly.deletingFirestoreServise)
        return ConversationsListViewController(model: model, presentationAssembly: self)
    }
    
    func getConversationViewController() -> ConversationViewController {
        let model = ConversationModel(coreDataService: serviceAssembly.coreDataService,
                                      loadingFirestoreServise: serviceAssembly.loadingFirestoreServise)
        return ConversationViewController(model: model, presentationAssembly: self)
    }
    
    func getImagesCollectionViewController() -> ImagesCollectionViewController {
        let model = ImagesModel(imageService: serviceAssembly.networkImageService)
        return ImagesCollectionViewController(model: model, presentationAssembly: self)
    }

    func getProfileViewController() -> ProfileViewController {
//        let model = ProfileModel(storageService: serviceAssembly.gcdStorageService)
        let model = ProfileModel(storageService: serviceAssembly.operationStorageService)
        return ProfileViewController(model: model, presentationAssembly: self)
    }
    
    func getThemesViewController() -> ThemesViewController {
        return ThemesViewController(delegate: serviceAssembly.themeManager)
    }
}
