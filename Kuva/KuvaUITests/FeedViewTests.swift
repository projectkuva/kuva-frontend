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
    
    //test if upload button tabbar works
    func testUploadButtonExists() {
        let tabsQuery = app.tabBars
        tabsQuery.buttons["Upload"].tap()
        
        let button = app.buttons["Post"]
        XCTAssert(button.exists)
    }
    
    //test if you can switch to profile from tabbar
    func testProfileButtonExists() {
        let tabsQuery = app.tabBars
        tabsQuery.buttons["Profile"].tap()
        
        let button = app.buttons["Log out"]
        XCTAssert(button.exists)
    }
    
    //test if you can switch to another menu and then go back
    func testFeedButtonExists() {
        let tabsQuery = app.tabBars
        tabsQuery.buttons["Upload"].tap()
        tabsQuery.buttons["Feed"].tap()
        
        let logo = app.images["kuva-logo"]
        XCTAssert(logo.exists)
    }
    
    //see if tab bar menu loads
    func testTabBarLoads() {
        let tabsQuery = app.tabBars
        XCTAssert(tabsQuery.buttons.count == 3)
    }
/*
    //select a photo
    func testIfViewImageDetails(){
    
    }
*/

    /*
    //to take photos and upload
    func testCameraButtonExists() {
        
    }

    //alternate way to access upload
    func testComposeButtonExists() {
        
        
    }
/*
    func testCameraButtonWorks() {
        
    }
 */
    
    func testComposeButtonWorks() {
        
    }
 */

    
}
