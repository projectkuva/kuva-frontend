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
        if (loggedOut()) {
            login()
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
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
    
    func getLocationCoordinates(id: Int) -> CGVector {
        return CGVector(dx: 10, dy: 100)
    }
    
    func viewCellDetails(id: Int) {
        let fixedView = app.otherElements["feedView"]
        let viewCo = fixedView.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
        let cellLocation:CGVector = getLocationCoordinates(id: 1)
        let coordinate = viewCo.withOffset(cellLocation)
        coordinate.tap()
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
        
        let button = app.buttons["Logout"]
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
        XCTAssert(tabsQuery.buttons.count == 4)
    }
    
    //select a photo
    func testIfViewImageDetails(){
        viewCellDetails(id: 0)
    }

    //to take photos and upload
    func testCameraButtonExists() {
        let button = app.buttons["camerabutton"]
        XCTAssertTrue(button.exists)
    }
    
    //to sort photos
    func testSortButtonExists() {
        let button = app.buttons["sortbutton"]
        XCTAssertTrue(button.exists)
    }

    
    //not sure how to test that the camera view has opened
//    func testCameraButtonWorks() {
//        
//    }
    


    
}
