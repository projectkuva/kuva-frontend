//
//  FeedViewTests.swift
//  Kuva
//
//  Created by Ankit Patanaik on 2/17/17.
//  Copyright © 2017 kuva. All rights reserved.
//

import XCTest

class FeedViewTests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
        login()
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
    

    
    func testUploadButton() {
        let tabsQuery = app.tabBars
        tabsQuery.buttons["Upload"].tap()
        
        let button = app.buttons["Post"]
        XCTAssert(button.exists)
        
        
    }
    
    func testProfileButton() {
        let tabsQuery = app.tabBars
        tabsQuery.buttons["Profile"].tap()
        
        let button = app.buttons["Log out"]
        XCTAssert(button.exists)
    }
    
    func testFeedButton() {
        let tabsQuery = app.tabBars
        tabsQuery.buttons["Upload"].tap()
        tabsQuery.buttons["Feed"].tap()
        
        let logo = app.images["kuva-logo"]
        XCTAssert(logo.exists)
    }
    
    func testTabBarLoads() {
        let tabsQuery = app.tabBars
        XCTAssert(tabsQuery.buttons.count == 3)
    }
    
    
}
