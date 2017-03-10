//
//  ActivityTests.swift
//  Kuva
//
//  Created by Shane DeWael on 3/10/17.
//  Copyright © 2017 kuva. All rights reserved.
//

import XCTest

class ActivityTests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
        
        if (loggedOut()) {
            login()
        }
        let tabsQuery = app.tabBars
        tabsQuery.buttons["Activity"].tap()
    }
    
    func loggedOut() -> Bool {
        //let button = app.buttons["Sign In"]
        let emailfield = app.textFields["Email"]
        return emailfield.isHittable
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
        sleep(5)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testActivityTableExists() {
        let table = app.tables["activitytab"]
        XCTAssertTrue(table.exists)
    }
    
}
