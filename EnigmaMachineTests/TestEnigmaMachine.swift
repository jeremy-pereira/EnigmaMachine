//
//  TestEnigmaMachine.swift
//  EnigmaMachine
//
//  Created by Jeremy Pereira on 03/03/2015.
//  Copyright (c) 2015 Jeremy Pereira. All rights reserved.
//

import Cocoa
import XCTest
import EnigmaMachine

class TestEnigmaMachine: XCTestCase
{
    var enigmaMachine: EnigmaMachine = EnigmaMachine()

    override func setUp()
    {
        super.setUp()
        enigmaMachine.insertRotor(RotorIII(), inSlot: 0, position: Letter.A)
        enigmaMachine.insertRotor(RotorII() , inSlot: 1, position: Letter.A)
        enigmaMachine.insertRotor(RotorI()  , inSlot: 2, position: Letter.A)
        enigmaMachine.insertReflector(reflectorB, position: Letter.A)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample()
    {
        enigmaMachine.plugInPair((Letter.A, Letter.D))
        enigmaMachine.keyDown(Letter.A)
        XCTAssert(enigmaMachine.litLamp != nil && enigmaMachine.litLamp! == Letter.M, "Wrong lamp lit \(enigmaMachine.litLamp)")
        enigmaMachine.keyUp()
        println("\(enigmaMachine.rotorReadOut)")
        XCTAssert(enigmaMachine.litLamp == nil, "A lamp is lit")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
