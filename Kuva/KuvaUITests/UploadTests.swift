//
//  UploadTests.swift
//  Kuva
//
//  Created by Matthew on 2/17/17.
//  Copyright © 2017 kuva. All rights reserved.
//

import XCTest

class UploadTests: XCTestCase {
        
    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
        login()
        let tabsQuery = app.tabBars
        tabsQuery.buttons["Upload"].tap()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func login() {
        let emailfield = app.textFields["Email"]
        let passwordfield = app.secureTextFields["Password"]
        let button = app.buttons["Sign In"]
        emailfield.tap()
        emailfield.typeText("test@email.com")
        passwordfield.tap()
        passwordfield.typeText("testpassword")
        button.tap()
        sleep(3)
    }
    
    // test that the caption field exists
    func testCaptionExists() {
        let captionTextView = app.textViews[""]
        XCTAssert(captionTextView.exists)
    }
    
    // test that the caption label exists
    func testCaptionLabelExists() {
        let captionLabel = app.staticTexts["Caption goes here..."]
        XCTAssert(captionLabel.exists)
    }
    
    // test that label goes away when you tap
    func testCaptionLabelDisappears() {
        let captionTextView = app.textViews[""]
        captionTextView.tap()
        let captionLabel = app.staticTexts["Caption goes here..."]
        XCTAssertFalse(captionLabel.exists)
    }
    
    // test that the post button works
    func testPostButtonExists() {
        let postButton = app.buttons["Post"]
        XCTAssert(postButton.exists)
    }
    
    // test that the post button will fail and present a popup
    func testPostButtonFailure() {
        let postButton = app.buttons["Post"]
        postButton.tap()
        let postFailureAlert = app.alerts["Select an image"]
        XCTAssert(postFailureAlert.exists)
        let sadButton = postFailureAlert.buttons[":/"]
        XCTAssert(sadButton.exists)
        sadButton.tap()
    }
    
    func testSelectImageButtonExists() {
        let selectImageButton = app.buttons["Select Image +"]
        XCTAssert(selectImageButton.exists)
    }
    
}
