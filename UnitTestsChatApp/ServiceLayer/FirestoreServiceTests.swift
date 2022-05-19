//
//  FirestoreServiceTests.swift
//  UnitTestsChatApp
//
//  Created by Anna Belousova on 19.05.2022.
//

import XCTest
import Firebase
@testable import ChatApp

class FirestoreServiceTests: XCTestCase {
    
    private var firestoreMock: FirestoreMock?
    private var channels: [Channel]?
    
    override func setUp() {
        super.setUp()
        firestoreMock = FirestoreMock()
        channels = ChannelStub.channels
    }

    override func tearDown() {
        super.tearDown()
        firestoreMock = nil
        channels = nil
    }

    func testIsLoadData() {
        let service = buildService()
        service?.loadData(reference: URLConstants.referenceToChannels) { _ in }
        
        if let firestoreMock = firestoreMock {
            XCTAssertTrue(firestoreMock.invokedLoadData)
            XCTAssertEqual(firestoreMock.invokedLoadDataCount, 1)
        }
    }
    
    private func buildService() -> FirestoreService? {
        if let firestoreMock = firestoreMock {
            return FirestoreService(firestoreDatabase: firestoreMock)
        } else { return nil }
    }
}
