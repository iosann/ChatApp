//
//  FirestoreDatabase.swift
//  ChatApp
//
//  Created by Anna Belousova on 21.04.2022.
//

import Foundation
import Firebase

typealias SnapshotResult = Result<QuerySnapshot, Error>

protocol IFirestoreChannels {
    func loadChannels( _ completion: @escaping(SnapshotResult) -> Void)
    func addChannel(data: [String: Any])
    func deleteChannelAndNestedMessages(channelId: String?)
}

protocol IFirestoreMessages {
    var selectedChannelId: String? { get set }
    func loadMessages( _ completion: @escaping(SnapshotResult) -> Void)
    func addMessage(data: [String: Any])
}

final class FirestoreDatabase {
    var selectedChannelId: String?
    private let db = Firestore.firestore()
    private lazy var referenceToChannels = db.collection("channels")
    private lazy var referenceToMessages = referenceToChannels.document(selectedChannelId ?? "").collection("messages")
    
    private func loadData(reference: CollectionReference, _ completion: @escaping(SnapshotResult) -> Void) {
        reference.addSnapshotListener { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                completion(.success(snapshot))
            }
        }
    }
}

extension FirestoreDatabase: IFirestoreChannels {
    
    func loadChannels( _ completion: @escaping(SnapshotResult) -> Void) {
        loadData(reference: referenceToChannels) { result in
            switch result {
            case .success(let snapshot): print(snapshot.documents.count)
            case .failure(let error): print(error.localizedDescription)
            }
            completion(result)
        }
    }
    
    func addChannel(data: [String: Any]) {
        referenceToChannels.addDocument(data: data)
    }
    
    func deleteChannelAndNestedMessages(channelId: String?) {
        guard let channelId = channelId else { return }
        referenceToChannels.document(channelId).delete()
        let messagesReference = referenceToChannels.document(channelId).collection("messages")
        messagesReference.getDocuments { snapshot, error in
            guard error == nil, let snapshot = snapshot else {
                assertionFailure(error?.localizedDescription ?? "")
                return
            }
            snapshot.documents.forEach { messagesReference.document($0.documentID).delete() }
        }
    }
}

extension FirestoreDatabase: IFirestoreMessages {
    
    func loadMessages( _ completion: @escaping(SnapshotResult) -> Void) {
        loadData(reference: referenceToMessages) { result in
            completion(result)
        }
    }
    
    func addMessage(data: [String: Any]) {
        referenceToMessages.addDocument(data: data)
    }
}
