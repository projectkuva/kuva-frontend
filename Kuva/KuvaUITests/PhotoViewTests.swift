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
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCanComment() {
        let table = app.tables.element
        XCTAssertTrue(table.exists)
        
        let cell = table.cells.element(boundBy: 2)
        XCTAssertTrue(cell.exists)
        let indexedText = cell.staticTexts.element
        XCTAssertTrue(indexedText.exists)
    }
    
    func testCanLike() {

        
    }
    
}
