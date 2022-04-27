//
//  FirestoreService.swift
//  ChatApp
//
//  Created by Anna Belousova on 27.04.2022.
//

import Firebase

protocol ILoadingFirestoreServise {
    func loadData(reference: CollectionReference, _ completion: @escaping(SnapshotResult) -> Void)
    func addDocument(reference: CollectionReference, data: [String: Any])
}

protocol IDeletingFirestoreServise {
    func deleteChannel(_ channelId: String?)
}

class FirestoreService {
    
    private let loadingFirestore: ILoadingFirestore? = FirestoreDatabase()
    private let deletingFirestore: IDeletingFirestore = FirestoreDatabase()
}

extension FirestoreService: ILoadingFirestoreServise {
    
    func loadData(reference: CollectionReference, _ completion: @escaping (SnapshotResult) -> Void) {
        loadingFirestore?.loadData(reference: reference) { result in
            completion(result)
        }
    }
    
    func addDocument(reference: CollectionReference, data: [String: Any]) {
        loadingFirestore?.addDocument(reference: reference, data: data)
    }
}

extension FirestoreService: IDeletingFirestoreServise {
    
    func deleteChannel(_ channelId: String?) {
        deletingFirestore.deleteChannelAndNestedMessages(channelId: channelId)
    }
}
