//
//  RegisterUITests.swift
//  Kuva
//
//  Created by Matthew on 2/16/17.
//  Copyright © 2017 kuva. All rights reserved.
//

import XCTest

class RegisterUITests: XCTestCase {
    let app = XCUIApplication()
        
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false

        app.launch()
        // load register view for each test
        app.buttons["Don't have an account?"].tap()

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testUsernameFieldExists() {
        XCTAssert(app.textFields["Username"].exists)
    }
    
    func testEmailFieldExists() {
        XCTAssert(app.textFields["Email"].exists)
    }
    
    func testPasswordFieldExists() {
        XCTAssert(app.secureTextFields["Password"].exists)
    }
    
    func testCreateAccountButtonExists() {
        XCTAssert(app.buttons["Create account"].exists)
    }
    
    func testReturnToLoginButtonExists() {
        XCTAssert(app.buttons["Already have an account?"].exists)
    }
    
}
