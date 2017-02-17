//
//  PhotoViewTests.swift
//  Kuva
//
//  Created by Ankit Patanaik on 2/16/17.
//  Copyright © 2017 kuva. All rights reserved.
//

import XCTest

class PhotoViewTests: XCTestCase {
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

    
    func viewCellDetails(id: Int) {
        let fixedView = app.otherElements["feedView"]
        let viewCo = fixedView.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
        let cellLocation:CGVector = getLocationCoordinates(id: 1)
        let coordinate = viewCo.withOffset(cellLocation)
        coordinate.tap()
        sleep(3)
    }
    
    func testCanComment() {
        viewCellDetails(id: 0)
        let commentBtn = app.buttons["comment-btn"]
        let commentDialog = app.alerts["Post Comment"]
        commentBtn.tap()
        XCTAssertTrue(commentDialog.exists)
        
    }
    
    func testCanLike() {
//    
//        let heart = app.images["likesButton"]
//        XCTAssert(heart.exists)
//
//        
        
    }
    
    func getLocationCoordinates(id: Int) -> CGVector {
        return CGVector(dx: 10, dy: 100)
    }
}
