
//
//  KuvaUITests.swift
//  KuvaUITests
//
//  Created by Matthew on 2/16/17.
//  Copyright © 2017 kuva. All rights reserved.
//

import XCTest

class LoginTests: XCTestCase {
    let app = XCUIApplication()
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
        logOut()
           }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEmailFieldExists() {
        let emailfield = app.textFields["Email"]
        XCTAssert(emailfield.exists)
    }
    
    func testPasswordFieldExists() {
        let passwordfield = app.secureTextFields["Password"]
        XCTAssert(passwordfield.exists)
    }
    
    func testIfButtonExists() {
        let button = app.buttons["Sign In"]
        XCTAssert(button.exists)
    }
    
    func testIfForgotPasswordExists() {
        let button = app.buttons["Forgot Your Password?"]
        XCTAssert(button.exists)
        
    }
    
    func testIfLogoLoads() {
        let logo = app.images["kuva-logo"]
        XCTAssert(logo.exists)
    }
    
    func testIfRegisterButtonExists() {
        let button = XCUIApplication().buttons["Don't have an account?"]
        XCTAssert(button.exists)
        
    }
    
    func testEmptyEmail() {
        let emailfield = app.textFields["Email"]
        let button = app.buttons["Sign In"]
        let badAlert = app.alerts["Email Field Empty"]
        emailfield.tap()
        emailfield.typeText("")
        button.tap()
        sleep(1)
        XCTAssert(badAlert.exists)
    }
    
    func testEmptyPassword() {
        let emailfield = app.textFields["Email"]
        let passwordfield = app.secureTextFields["Password"]
        let button = app.buttons["Sign In"]
        let badAlert = app.alerts["Password Field Empty"]
        emailfield.tap()
        emailfield.typeText("test@email.com")
        passwordfield.tap()
        passwordfield.typeText("")
        button.tap()
        sleep(1)
        XCTAssert(badAlert.exists)
    }
    
    func testLogin() {
        let emailfield = app.textFields["Email"]
        let passwordfield = app.secureTextFields["Password"]
        let button = app.buttons["Sign In"]
        emailfield.tap()
        emailfield.typeText("test@email.com")
        passwordfield.tap()
        passwordfield.typeText("testpassword")
        button.tap()
        sleep(3)
        
        let tabsQuery = app.tabBars
        print(tabsQuery.buttons.count)
        XCTAssert(tabsQuery.buttons.count == 4)
        
        
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
