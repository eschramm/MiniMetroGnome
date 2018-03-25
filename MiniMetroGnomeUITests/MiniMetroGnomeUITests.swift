//
//  MiniMetroGnomeUITests.swift
//  MiniMetroGnomeUITests
//
//  Created by Eric Schramm on 3/9/18.
//  Copyright © 2018 Eric Schramm. All rights reserved.
//

import XCTest

class MiniMetroGnomeUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testUIelements() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        //ASSUMES: slider range 40 to 200, defaulted at 60 bpm
        
        let app = XCUIApplication()
        let slider = app.sliders["12%"]
        slider.adjust(toNormalizedSliderPosition: 0.8)
        app.staticTexts["168 bpm"].tap()
        
        //test button toggles from Start to Stop and back
        app.buttons["Start"].tap()
        app.buttons["Stop"].tap()
        app.buttons["Start"].tap()
    }
}
