//
//  MiniMetroGnomeTests.swift
//  MiniMetroGnomeTests
//
//  Created by Eric Schramm on 3/9/18.
//  Copyright © 2018 Eric Schramm. All rights reserved.
//

import XCTest
@testable import MiniMetroGnome

class MiniMetroGnomeTests: XCTestCase {
    
    var mainViewController: ViewController!
    
    override func setUp() {
        super.setUp()
        
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        mainViewController = storyBoard.instantiateViewController(withIdentifier: "mainViewController") as! ViewController
        let _ = mainViewController.view  //trigger draw
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testOutletsExist() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        XCTAssertNotNil(mainViewController.slider)
        XCTAssertNotNil(mainViewController.toggleButton)
        XCTAssertNotNil(mainViewController.clickSound)
    }
}
