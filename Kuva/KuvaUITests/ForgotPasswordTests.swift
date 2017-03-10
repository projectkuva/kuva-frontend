//
//  ForgotPasswordTests.swift
//  Kuva
//
//  Created by Matthew on 2/16/17.
//  Copyright © 2017 kuva. All rights reserved.
//

import XCTest

class ForgotPasswordTests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        
        app.launch()
        logOut()
        // load forgot password view for each test
        app.buttons["Forgot Your Password?"].tap()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEmailFieldExists() {
        XCTAssert(app.textFields["Email"].exists)
    }
    
    func testEmptyEmail() {
        let emailfield = app.textFields["forgetEmail"]
        let button = app.buttons["resetPassword"]
        let badAlert = app.alerts["Email Field Invalid"]
        emailfield.tap()
        emailfield.typeText("")
        button.tap()
        sleep(1)
        XCTAssert(badAlert.exists)
    }
    
    func testResetTokenButton() {
        XCTAssert(app.buttons["Send Reset Token"].exists)
    }
    
    func testReturnToLoginButtonExists() {
        XCTAssert(app.buttons["Go back to sign in?"].exists)
    }
    
    func logOut() {
        let tabsQuery = app.tabBars
        if (tabsQuery.buttons["Profile"].exists) {
            tabsQuery.buttons["Profile"].tap()
            
            let logoutBtn = app.buttons["Logout"]
            logoutBtn.tap()

        }
        sleep(2)
    }
    
    
}
