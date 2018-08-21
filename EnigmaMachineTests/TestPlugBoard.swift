//
//  TestPlugBoard.swift
//  EnigmaMachine
//
//  Created by Jeremy Pereira on 02/03/2015.
//  Copyright (c) 2015 Jeremy Pereira. All rights reserved.
//
/*

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

*/

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
        plugBoard.plugIn(pair: (Letter.B, Letter.C))
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
        plugBoard.plugIn(pair: (Letter.X, Letter.C))
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
