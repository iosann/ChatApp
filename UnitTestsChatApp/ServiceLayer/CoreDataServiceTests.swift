//
//  CoreDataServiceTests.swift
//  UnitTestsChatApp
//
//  Created by Anna Belousova on 19.05.2022.
//

import XCTest
import CoreData
@testable import ChatApp

class CoreDataServiceTests: XCTestCase {
    
    private let coreDataMock = CoreDataMock()
    private var channels: [Channel]?
    
    override func setUp() {
        super.setUp()
        channels = ChannelStub.channels
    }
    
    override func tearDown() {
        super.tearDown()
        channels = nil
    }
    
    func testPerformSave() {
        let service = buildService()
        let writeContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        coreDataMock.stubbedPerformSaveBlockResult = (writeContext, ())
        service.saveData { context in
            self.saveChannels(channels: self.channels ?? [Channel](), context: context)
        }
        
        XCTAssertTrue(coreDataMock.invokedPerformSave)
        XCTAssertEqual(coreDataMock.invokedPerformSaveCount, 1)
    }
    
    func testReadContext() {
        let service = buildService()
        coreDataMock.stubbedReadContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        let readContext = service.readContext
        XCTAssertTrue(coreDataMock.invokedReadContextGetter)
        XCTAssertEqual(coreDataMock.invokedReadContextGetterCount, 1)
        XCTAssertEqual(readContext, coreDataMock.readContext)
    }
    
    private func buildService() -> CoreDataService {
        return CoreDataService(coreDataStorage: coreDataMock)
    }
    
    private func saveChannels(channels: [Channel], context: NSManagedObjectContext) {
        channels.forEach {
            let dbchannel = DBChannel(context: context)
            dbchannel.identifier = $0.identifier
            dbchannel.name = $0.name
            dbchannel.lastMessage = $0.lastMessage
            dbchannel.lastActivity = $0.lastActivity
        }
    }
}
