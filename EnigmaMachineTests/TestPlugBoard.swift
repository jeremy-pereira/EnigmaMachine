//
//  TestPlugBoard.swift
//  EnigmaMachine
//
//  Created by Jeremy Pereira on 02/03/2015.
//  Copyright (c) 2015 Jeremy Pereira. All rights reserved.
//

import Cocoa
import XCTest
import EnigmaMachine

class TestPlugBoard: XCTestCase
{

    override func setUp()
    {
        super.setUp()
    }
    
    override func tearDown()
    {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testPlugBoard()
    {
        var plugBoard = PlugBoard()

        for aLetter in Letter.A ... Letter.Z
        {
            XCTAssert(aLetter == plugBoard.forward[aLetter], "Letter \(aLetter) not straight through forwards")
            XCTAssert(aLetter == plugBoard.reverse[aLetter], "Letter \(aLetter) not straight through reverse")
        }
        plugBoard.plugInPair((Letter.B, Letter.C))
        for aLetter in Letter.A ... Letter.Z
        {
            if aLetter == Letter.B
            {
                XCTAssert(Letter.C == plugBoard.forward[aLetter], "Letter \(aLetter) not straight through forwards")
                XCTAssert(Letter.C == plugBoard.reverse[aLetter], "Letter \(aLetter) not straight through reverse")
            }
            else if aLetter == Letter.C
            {
                XCTAssert(Letter.B == plugBoard.forward[aLetter], "Letter \(aLetter) not straight through forwards")
                XCTAssert(Letter.B == plugBoard.reverse[aLetter], "Letter \(aLetter) not straight through reverse")
            }
            else
            {
                XCTAssert(aLetter == plugBoard.forward[aLetter], "Letter \(aLetter) not straight through forwards")
                XCTAssert(aLetter == plugBoard.reverse[aLetter], "Letter \(aLetter) not straight through reverse")
            }
        }
        plugBoard.plugInPair((Letter.X, Letter.C))
        for aLetter in Letter.A ... Letter.Z
        {
            if aLetter == Letter.X
            {
                XCTAssert(Letter.C == plugBoard.forward[aLetter], "Letter \(aLetter) not straight through forwards")
                XCTAssert(Letter.C == plugBoard.reverse[aLetter], "Letter \(aLetter) not straight through reverse")
            }
            else if aLetter == Letter.C
            {
                XCTAssert(Letter.X == plugBoard.forward[aLetter], "Letter \(aLetter) not straight through forwards")
                XCTAssert(Letter.X == plugBoard.reverse[aLetter], "Letter \(aLetter) not straight through reverse")
            }
            else
            {
                XCTAssert(aLetter == plugBoard.forward[aLetter], "Letter \(aLetter) not straight through forwards")
                XCTAssert(aLetter == plugBoard.reverse[aLetter], "Letter \(aLetter) not straight through reverse")
            }
        }
    }

}