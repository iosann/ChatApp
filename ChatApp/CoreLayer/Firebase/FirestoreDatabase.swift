//
//  FirestoreDatabase.swift
//  ChatApp
//
//  Created by Anna Belousova on 21.04.2022.
//

import Foundation
import Firebase

typealias SnapshotResult = Result<QuerySnapshot, Error>

protocol IFirestoreDatabase {
    func loadData(reference: CollectionReference, _ completion: @escaping(SnapshotResult) -> Void)
    func addDocument(reference: CollectionReference, data: [String: Any])
    func deleteChannelAndNestedMessages(channelId: String?)
}

final class FirestoreDatabase: IFirestoreDatabase {
    
    func loadData(reference: CollectionReference, _ completion: @escaping(SnapshotResult) -> Void) {
        reference.addSnapshotListener { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                completion(.success(snapshot))
            }
        }
    }
    
    func addDocument(reference: CollectionReference, data: [String: Any]) {
        reference.addDocument(data: data)
    }
    
    func deleteChannelAndNestedMessages(channelId: String?) {
        guard let channelId = channelId else { return }
        URLConstants.referenceToChannels.document(channelId).delete()
        let messagesReference = URLConstants.referenceToChannels.document(channelId).collection("messages")
        messagesReference.getDocuments { snapshot, error in
            guard error == nil, let snapshot = snapshot else {
                assertionFailure(error?.localizedDescription ?? "")
                return
            }
            snapshot.documents.forEach { messagesReference.document($0.documentID).delete() }
        }
    }
}
