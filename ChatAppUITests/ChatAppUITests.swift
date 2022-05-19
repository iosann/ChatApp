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
        continueAfterFailure = false
    }

    override func tearDown() {
        super.tearDown()
        app = nil
    }

    func testExample() {
        guard let app = app else { return }
        
        let scrollViewsQuery = app.scrollViews
        let elementsQuery = scrollViewsQuery.otherElements
        let cameraButton = elementsQuery.buttons["camera"]
        
        let element = scrollViewsQuery.children(matching: .other).element(boundBy: 0).children(matching: .other).element
        let nameTextView = element.children(matching: .textView).element(boundBy: 0)
        let descriptionTextView = element.children(matching: .textView).element(boundBy: 1)
        
        
        let app = XCUIApplication()
        let elementsQuery = app.scrollViews.otherElements
        let editStaticText = elementsQuery/*@START_MENU_TOKEN@*/.staticTexts["Edit"]/*[[".buttons[\"Edit\"].staticTexts[\"Edit\"]",".staticTexts[\"Edit\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        editStaticText.tap()
        
        let element = app/*@START_MENU_TOKEN@*/.scrollViews.containing(.other, identifier:"Vertical scroll bar, 3 pages")/*[[".scrollViews.containing(.other, identifier:\"Horizontal scroll bar, 1 page\")",".scrollViews.containing(.other, identifier:\"Vertical scroll bar, 3 pages\")"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.children(matching: .other).element(boundBy: 0).children(matching: .other).element
        element.tap()
        elementsQuery/*@START_MENU_TOKEN@*/.staticTexts["Save Operations"]/*[[".buttons[\"Save Operations\"].staticTexts[\"Save Operations\"]",".staticTexts[\"Save Operations\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.alerts["Данные сохранены"].scrollViews.otherElements.buttons["Ok"].tap()
        editStaticText.tap()
        element.tap()
        elementsQuery/*@START_MENU_TOKEN@*/.staticTexts["Cancel"]/*[[".buttons[\"Cancel\"].staticTexts[\"Cancel\"]",".staticTexts[\"Cancel\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        elementsQuery.buttons["camera"].tap()
        app.sheets["Choose image source"].scrollViews.otherElements.buttons["PhotoLibrary"].tap()
        app/*@START_MENU_TOKEN@*/.scrollViews.otherElements.images["Photo, March 30, 2018, 11:14 PM"]/*[[".otherElements[\"Photos\"].scrollViews.otherElements",".otherElements[\"Photo, March 30, 2018, 11:14 PM, Photo, August 09, 2012, 1:55 AM, Photo, August 09, 2012, 1:29 AM, Photo, August 08, 2012, 10:52 PM, Photo, October 10, 2009, 2:09 AM, Photo, March 13, 2011, 3:17 AM\"].images[\"Photo, March 30, 2018, 11:14 PM\"]",".images[\"Photo, March 30, 2018, 11:14 PM\"]",".scrollViews.otherElements"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/.tap()

        

        XCTAssertTrue(cameraButton.exists)
        XCTAssertTrue(nameTextView.exists)
        XCTAssertTrue(descriptionTextView.exists)
    }
}
