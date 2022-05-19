//
//  FirestoreMock.swift
//  UnitTestsChatApp
//
//  Created by Anna Belousova on 19.05.2022.
//

import Firebase
@testable import ChatApp

class FirestoreMock: IFirestoreDatabase {

    var invokedLoadData = false
    var invokedLoadDataCount = 0
    var invokedLoadDataParameters: (reference: CollectionReference, Void)?
    var invokedLoadDataParametersList = [(reference: CollectionReference, Void)]()
    var stubbedLoadDataCompletionResult: (SnapshotResult, Void)?

    func loadData(reference: CollectionReference, _ completion: @escaping(SnapshotResult) -> Void) {
        invokedLoadData = true
        invokedLoadDataCount += 1
        invokedLoadDataParameters = (reference, ())
        invokedLoadDataParametersList.append((reference, ()))
        if let result = stubbedLoadDataCompletionResult {
            completion(result.0)
        }
    }

    var invokedAddDocument = false
    var invokedAddDocumentCount = 0
    var invokedAddDocumentParameters: (reference: CollectionReference, data: [String: Any])?
    var invokedAddDocumentParametersList = [(reference: CollectionReference, data: [String: Any])]()

    func addDocument(reference: CollectionReference, data: [String: Any]) {
        invokedAddDocument = true
        invokedAddDocumentCount += 1
        invokedAddDocumentParameters = (reference, data)
        invokedAddDocumentParametersList.append((reference, data))
    }

    var invokedDeleteChannelAndNestedMessages = false
    var invokedDeleteChannelAndNestedMessagesCount = 0
    var invokedDeleteChannelAndNestedMessagesParameters: (channelId: String?, Void)?
    var invokedDeleteChannelAndNestedMessagesParametersList = [(channelId: String?, Void)]()

    func deleteChannelAndNestedMessages(channelId: String?) {
        invokedDeleteChannelAndNestedMessages = true
        invokedDeleteChannelAndNestedMessagesCount += 1
        invokedDeleteChannelAndNestedMessagesParameters = (channelId, ())
        invokedDeleteChannelAndNestedMessagesParametersList.append((channelId, ()))
    }
}
