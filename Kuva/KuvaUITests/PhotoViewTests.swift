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
        
        if (loggedOut()) {
            login()
        }
        
        viewCellDetails(id: 0)
        
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
    
    func logOut() {
        let tabsQuery = app.tabBars
        if (tabsQuery.buttons["Profile"].exists) {
            tabsQuery.buttons["Profile"].tap()
            
            let logoutBtn = app.buttons["Logout"]
            logoutBtn.tap()
            
        }
        sleep(2)
    }
    
    
    func viewCellDetails(id: Int) {
        sleep(1)
        let fixedView = app.otherElements["feedView"]
        let viewCo = fixedView.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
        let cellLocation:CGVector = getLocationCoordinates(id: 1)
        print("HERE")
        let coordinate = viewCo.withOffset(cellLocation)
        coordinate.tap()
        sleep(2)
    }
    
    //Tests that comment button exists
    func testCommentButtonExists() {
        let commentBtn = app.buttons["comment-btn"]
        
        XCTAssertTrue(commentBtn.exists)
    }
    
    //Tests that comment button label
    func testCommentLabelExists() {
        let commentsLabel = app.staticTexts["commentsLabel"]
        
        
        XCTAssertTrue(commentsLabel.exists)
    }
    
    //Tests the ability to comment
    func testCanComment() {
        let commentBtn = app.buttons["comment-btn"]
        let commentDialog = app.alerts["Post Comment"]
        commentBtn.tap()
        
        XCTAssertTrue(commentDialog.exists)
    }
    
    //Tests that username label exists
    func testUsernameExists() {
        let usernameLabel = app.buttons["usernameButton"]
        
        XCTAssertTrue(usernameLabel.exists)
    }
    
    //Tests that proper username exists
    func testUsernameValid() {
        let usernameLabel = app.buttons["usernameButton"]
        
        XCTAssertNotEqual(usernameLabel.label, "Username")
    }
    
    //Tests that like button exists
    func testLikesButtonExist() {
        let likes = app.buttons["Like Button"]
        
        XCTAssertTrue(likes.exists)
    }
    
    //Tests that like label exists
    func testLikesLabelExists() {
        let likesLabel = app.staticTexts["likesText"]
        
        XCTAssertTrue(likesLabel.exists)
    }
    
    //Tests that like label updates when user likes image
    func testLikesUpdate() {
        if !isUsersPhoto() {
            let status = app.buttons["liked"].exists
            
            pressLike()
            
            let hasLiked = app.buttons["unliked"].exists
            
            XCTAssertEqual(hasLiked, status)
        }
    }
    
    //Test that date label exists
    func testDateLabelExists() {
        let dateLabel = app.staticTexts["dateLabel"]
        
        XCTAssertTrue(dateLabel.exists)
    }
    
    //Test that date label is valid
    func testValidDateLabel() {
        let dateLabelText = app.staticTexts["dateLabel"].label
        
        XCTAssertNotEqual(dateLabelText, "Jan 31, 2000")
    }
    
    //Test delete button exists
    func testdeleteButtonExists() {
        if isUsersPhoto() {
            let deleteBtn = app.buttons["deleteBtn"]
            XCTAssertTrue(deleteBtn.exists)
        } else {
            XCTAssertTrue(true)
        }
    }
    
    //Test that empty comment throws error
    func testEmptyComment() {
        let commentBtn = app.buttons["comment-btn"]
        let commentDialog = app.alerts["Post Comment"]
        commentBtn.tap()
        commentDialog.buttons["Post"].tap()
        sleep(1)
        
        XCTAssertTrue(app.alerts["Invalid Comment"].exists)
    }
    
    //Tests share button exists
    func testShareButtonExists() {
        let shareBtn = app.buttons["shareButton"]
        
        XCTAssertTrue(shareBtn.exists)
    }
    
    //Tests share button works
    func testShareButtonValid() {
        let shareBtn = app.buttons["shareButton"]
        shareBtn.tap()
        
        let shareDialog = app.alerts["Share Photo"]
        XCTAssertTrue(shareDialog.exists)
    }
    
    //Tests report button exists
    func testReportButtonExists() {
        let reportBtn = app.buttons["reportButton"]
        
        XCTAssertTrue(reportBtn.exists)
    }
    
    func isUsersPhoto() -> BooleanLiteralType {
        return app.buttons["deleteBtn"].exists
    }
    
    //Emulate like
    func pressLike() {
        let likes = app.buttons["Like Button"]
        likes.tap()
        sleep(3)
    }
    
    //Helper function to get coordinates of cell
    func getLocationCoordinates(id: Int) -> CGVector {
        return CGVector(dx: 10, dy: 120)
    }
}
