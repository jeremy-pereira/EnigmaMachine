//
//  TestLetter.swift
//  EnigmaMachine
//
//  Created by Jeremy Pereira on 25/02/2015.
//  Copyright (c) 2015 Jeremy Pereira. All rights reserved.
//

import Cocoa
import XCTest
import EnigmaMachine

class TestLetter: XCTestCase
{

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testOrdinals()
    {
        XCTAssert(Letter.letter(ordinal: 0) == Letter.A, "A ordinal is wrong")
        XCTAssert(Letter.letter(ordinal: 1) == Letter.B, "A ordinal is wrong")
        XCTAssert(Letter.letter(ordinal: 2) == Letter.C, "A ordinal is wrong")
        XCTAssert(Letter.letter(ordinal: 3) == Letter.D, "A ordinal is wrong")
        XCTAssert(Letter.letter(ordinal: 4) == Letter.E, "A ordinal is wrong")
        XCTAssert(Letter.letter(ordinal: 5) == Letter.F, "A ordinal is wrong")
        XCTAssert(Letter.letter(ordinal: 6) == Letter.G, "A ordinal is wrong")
        XCTAssert(Letter.letter(ordinal: 7) == Letter.H, "A ordinal is wrong")
        XCTAssert(Letter.letter(ordinal: 8) == Letter.I, "A ordinal is wrong")
        XCTAssert(Letter.letter(ordinal: 9) == Letter.J, "A ordinal is wrong")
        XCTAssert(Letter.letter(ordinal: 10) == Letter.K, "A ordinal is wrong")
        XCTAssert(Letter.letter(ordinal: 11) == Letter.L, "A ordinal is wrong")
        XCTAssert(Letter.letter(ordinal: 12) == Letter.M, "A ordinal is wrong")
        XCTAssert(Letter.letter(ordinal: 13) == Letter.N, "A ordinal is wrong")
        XCTAssert(Letter.letter(ordinal: 14) == Letter.O, "A ordinal is wrong")
        XCTAssert(Letter.letter(ordinal: 15) == Letter.P, "A ordinal is wrong")
        XCTAssert(Letter.letter(ordinal: 16) == Letter.Q, "A ordinal is wrong")
        XCTAssert(Letter.letter(ordinal: 17) == Letter.R, "A ordinal is wrong")
        XCTAssert(Letter.letter(ordinal: 18) == Letter.S, "A ordinal is wrong")
        XCTAssert(Letter.letter(ordinal: 19) == Letter.T, "A ordinal is wrong")
        XCTAssert(Letter.letter(ordinal: 20) == Letter.U, "A ordinal is wrong")
        XCTAssert(Letter.letter(ordinal: 21) == Letter.V, "A ordinal is wrong")
        XCTAssert(Letter.letter(ordinal: 22) == Letter.W, "A ordinal is wrong")
        XCTAssert(Letter.letter(ordinal: 23) == Letter.X, "A ordinal is wrong")
        XCTAssert(Letter.letter(ordinal: 24) == Letter.Y, "A ordinal is wrong")
        XCTAssert(Letter.letter(ordinal: 25) == Letter.Z, "A ordinal is wrong")
        XCTAssert(Letter.letter(ordinal: 26) == Letter.A, "A ordinal is wrong")
        XCTAssert(Letter.letter(ordinal: -1) == Letter.Z, "A ordinal is wrong")

        for ordinal in 0 ..< 26
        {
            XCTAssert(ordinal == Letter.letter(ordinal: ordinal).ordinal, "Ordinal incorrect for \(ordinal)")
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
