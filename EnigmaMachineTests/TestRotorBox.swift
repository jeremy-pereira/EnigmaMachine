//
//  TestRotorBox.swift
//  EnigmaMachine
//
//  Created by Jeremy Pereira on 09/03/2015.
//  Copyright (c) 2015 Jeremy Pereira. All rights reserved.
//

import Cocoa
import XCTest
import EnigmaMachine

class TestRotorBox: XCTestCase
{

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testRemoveRotor()
    {
        var rotorBox = SpareRotorBox()
        let aRotor = rotorBox.removeRotor(name: "IV")
    	XCTAssert(aRotor != nil && aRotor!.name == "IV", "Wrong name for rotor")
		XCTAssert(rotorBox.count == 4, "Wrong rotor box count")
    }
}
