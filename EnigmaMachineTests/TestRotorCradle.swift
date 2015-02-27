//
//  TestRotorCradle.swift
//  EnigmaMachine
//
//  Created by Jeremy Pereira on 26/02/2015.
//  Copyright (c) 2015 Jeremy Pereira. All rights reserved.
//

import Cocoa
import XCTest
import EnigmaMachine

class TestRotorCradle: XCTestCase
{
    var standardCradle: RotorCradle = RotorCradle()

    override func setUp()
    {
        super.setUp()
		standardCradle.slot[0].rotor = RotorI()
        standardCradle.slot[1].rotor = RotorII()
        standardCradle.slot[2].rotor = RotorIII()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testBasic()
    {
        XCTAssert(standardCradle.forward[Letter.A] == Letter.B, "Letter 1 incorrect")
        XCTAssert(standardCradle.forward[Letter.A] == Letter.D, "Letter 2 incorrect")
        XCTAssert(standardCradle.forward[Letter.A] == Letter.Z, "Letter 3 incorrect")
        XCTAssert(standardCradle.forward[Letter.A] == Letter.G, "Letter 4 incorrect")
        XCTAssert(standardCradle.forward[Letter.A] == Letter.O, "Letter 5 incorrect")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
