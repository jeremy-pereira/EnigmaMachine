//
//  TestRotorWiring.swift
//  EnigmaMachine
//
//  Created by Jeremy Pereira on 25/02/2015.
//  Copyright (c) 2015 Jeremy Pereira. All rights reserved.
//

import Cocoa
import XCTest
import EnigmaMachine

class TestRotorWiring: XCTestCase
{

    override func setUp()
    {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testIdentity()
    {
        let connection: Connection = Wiring.identity

        for letter in Letter.A ... Letter.Z
        {
            XCTAssert(connection[letter] == letter, "Identity connection failed for \(letter)")
        }
    }

    func testThreeWay()
    {
        let connection: Connection = Wiring(map: [ Letter.B : Letter.Z, Letter.Z : Letter.M, Letter.M : Letter.B])

        XCTAssert(connection[Letter.A] == Letter.A, "A connection should be straight through")
        XCTAssert(connection[Letter.B] == Letter.Z, "B connection should go to Z")
        let inverse = connection.inverse
        XCTAssert(inverse[Letter.A] == Letter.A, "A connection should be straight through")
        XCTAssert(inverse[Letter.B] == Letter.M, "B connection should go to Z")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
