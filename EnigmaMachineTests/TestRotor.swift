//
//  TestRotor.swift
//  EnigmaMachine
//
//  Created by Jeremy Pereira on 25/02/2015.
//  Copyright (c) 2015 Jeremy Pereira. All rights reserved.
//

import Cocoa
import XCTest
import EnigmaMachine

class TestRotor: XCTestCase
{

    override func setUp()
    {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown()
    {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testRotorI()
    {
    	let rotorI = RotorI()
        rotorI.ringStellung = Letter.A
        XCTAssert(rotorI.rightToLeft[Letter.A] == Letter.E, "Rotor I has wrong letter A")
        XCTAssert(rotorI.rightToLeft[Letter.Z] == Letter.J, "Rotor I has wrong letter A")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
