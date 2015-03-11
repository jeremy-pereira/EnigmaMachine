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
        standardCradle.slot[0].insertRotor(Rotor.makeMilitaryIII(), position: Letter.A)
        standardCradle.slot[1].insertRotor(Rotor.makeMilitaryII() , position: Letter.A)
        standardCradle.slot[2].insertRotor(Rotor.makeMilitaryI()  , position: Letter.A)
        standardCradle.insertReflector(reflectorB    , position: Letter.A)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testBasic()
    {
        standardCradle.rotate()
        var letter = standardCradle.forward[Letter.A]
        XCTAssert(letter! == Letter.B, "Letter 1 incorrect, (\(letter))")
        standardCradle.rotate()
        letter = standardCradle.forward[Letter.A]
        XCTAssert(letter! == Letter.D, "Letter 2 incorrect, (\(letter))")
        standardCradle.rotate()
        letter = standardCradle.forward[Letter.A]
        XCTAssert(letter! == Letter.Z, "Letter 3 incorrect, (\(letter))")
        standardCradle.rotate()
        letter = standardCradle.forward[Letter.A]
        XCTAssert(letter! == Letter.G, "Letter 4 incorrect, (\(letter))")
        standardCradle.rotate()
        letter = standardCradle.forward[Letter.A]
        XCTAssert(letter! == Letter.O, "Letter 5 incorrect, (\(letter))")
    }

    func testRightNotch()
    {
		standardCradle.slot[0].insertRotor(standardCradle.slot[0].rotor!, position: Letter.V)
        standardCradle.rotate()
        var letter = standardCradle.forward[Letter.A]
        XCTAssert(letter! == Letter.U, "Letter 1 incorrect, (\(letter))")
        standardCradle.rotate()
        letter = standardCradle.forward[Letter.A]
        XCTAssert(letter! == Letter.Q, "Letter 2 incorrect, (\(letter))")
        standardCradle.rotate()
        letter = standardCradle.forward[Letter.A]
        XCTAssert(letter! == Letter.O, "Letter 3 incorrect, (\(letter))")
        standardCradle.rotate()
        letter = standardCradle.forward[Letter.A]
        XCTAssert(letter! == Letter.F, "Letter 4 incorrect, (\(letter))")
        standardCradle.rotate()
        letter = standardCradle.forward[Letter.A]
        XCTAssert(letter! == Letter.X, "Letter 5 incorrect, (\(letter))")
    }

    func testMiddleNotch()
    {
        standardCradle.slot[1].insertRotor(standardCradle.slot[1].rotor!, position: Letter.E)
        standardCradle.rotate()
        var letter = standardCradle.forward[Letter.A]
        XCTAssert(letter! == Letter.F, "Letter 1 incorrect, (\(letter))")
        standardCradle.rotate()
        letter = standardCradle.forward[Letter.A]
        XCTAssert(letter! == Letter.J, "Letter 2 incorrect, (\(letter))")
        standardCradle.rotate()
        letter = standardCradle.forward[Letter.A]
        XCTAssert(letter! == Letter.B, "Letter 3 incorrect, (\(letter))")
        standardCradle.rotate()
        letter = standardCradle.forward[Letter.A]
        XCTAssert(letter! == Letter.W, "Letter 4 incorrect, (\(letter))")
        standardCradle.rotate()
        letter = standardCradle.forward[Letter.A]
        XCTAssert(letter! == Letter.Z, "Letter 5 incorrect, (\(letter))")
    }

    func testLeftNotch()
    {
        standardCradle.slot[2].insertRotor(standardCradle.slot[2].rotor!, position: Letter.Q)
        standardCradle.rotate()
        var letter = standardCradle.forward[Letter.A]
        XCTAssert(letter! == Letter.F, "Letter 1 incorrect, (\(letter))")
        standardCradle.rotate()
        letter = standardCradle.forward[Letter.A]
        XCTAssert(letter! == Letter.B, "Letter 2 incorrect, (\(letter))")
        standardCradle.rotate()
        letter = standardCradle.forward[Letter.A]
        XCTAssert(letter! == Letter.J, "Letter 3 incorrect, (\(letter))")
        standardCradle.rotate()
        letter = standardCradle.forward[Letter.A]
        XCTAssert(letter! == Letter.Z, "Letter 4 incorrect, (\(letter))")
        standardCradle.rotate()
        letter = standardCradle.forward[Letter.A]
        XCTAssert(letter! == Letter.D, "Letter 5 incorrect, (\(letter))")
    }


    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
