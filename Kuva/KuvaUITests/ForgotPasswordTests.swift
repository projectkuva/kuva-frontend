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
    
    func testCreateAccountButtonExists() {
        XCTAssert(app.buttons["Reset Password"].exists)
    }
    
    func testReturnToLoginButtonExists() {
        XCTAssert(app.buttons["Go back to sign in?"].exists)
    }
    
}
