//
//  ChatAppUITests.swift
//  ChatAppUITests
//
//  Created by Anna Belousova on 20.05.2022.
//

import XCTest

class ChatAppUITests: XCTestCase {
    
    private var app: XCUIApplication?

    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app?.launch()
    }

    override func tearDown() {
        super.tearDown()
        app = nil
    }

    func testProfileUIElements() {
        guard let app = app else { return }
        
        let scrollViewsQuery = app.scrollViews
        let elementsQuery = scrollViewsQuery.otherElements
        let cameraButton = elementsQuery.buttons["camera"]
        let editButton = elementsQuery.buttons["Edit"]
        
        let element = scrollViewsQuery.children(matching: .other).element(boundBy: 0).children(matching: .other).element
        let nameTextView = element.children(matching: .textView).element(boundBy: 0)
        let descriptionTextView = element.children(matching: .textView).element(boundBy: 1)

        let avatarImage = app.otherElements["Photos"].scrollViews.otherElements.images["Photo, March 30, 2018, 11:14 PM"]
        let title = XCUIApplication().navigationBars["ChatApp.ProfileView"].buttons["My Profile"]
        
        XCTAssertTrue(cameraButton.exists)
        XCTAssertTrue(nameTextView.exists)
        XCTAssertTrue(descriptionTextView.exists)
        XCTAssertTrue(editButton.exists)
        XCTAssertTrue(avatarImage.exists)
        XCTAssertTrue(title.exists)
    }
}
