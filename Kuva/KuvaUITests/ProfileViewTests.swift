//
//  ProfileViewTests.swift
//  Kuva
//
//  Created by Ankit Patanaik on 2/17/17.
//  Copyright © 2017 kuva. All rights reserved.
//

import XCTest

class ProfileViewTests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
        
        login()
        let tabsQuery = app.tabBars
        tabsQuery.buttons["Profile"].tap()
    }
    
    override func tearDown() {
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
    
    func testLogoutButtonExists() {
        let button = app.buttons["Log out"]
        XCTAssert(button.exists)
    }
    
    func testLogoutWorks() {
        let button = app.buttons["Log out"]
        button.tap()
        
        let signInButton = app.buttons["Sign In"]
        XCTAssert(signInButton.exists)
    }
    
    func testUsername() {
        let name = app.
    }
    
}
