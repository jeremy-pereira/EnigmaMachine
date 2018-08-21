//
//  TestRotorCradle.swift
//  EnigmaMachine
//
//  Created by Jeremy Pereira on 26/02/2015.
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
import Toolbox

class TestRotorCradle: XCTestCase
{
    var standardCradle: RotorCradle = RotorCradle()

    override func setUp()
    {
        super.setUp()
        standardCradle.slot[0].insert(rotor: Rotor.makeMilitaryIII(), position: Letter.A)
        standardCradle.slot[1].insert(rotor: Rotor.makeMilitaryII() , position: Letter.A)
        standardCradle.slot[2].insert(rotor: Rotor.makeMilitaryI()  , position: Letter.A)
        standardCradle.insertReflector(reflector: reflectorB, position: Letter.A)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testBasic()
    {
        Logger.pushLevel(.debug, forName: "EnigmaMachine.Components.Connection")
        defer { Logger.popLevel(forName: "EnigmaMachine.Components.Connection") }
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
        standardCradle.slot[0].insert(rotor: standardCradle.slot[0].rotor!, position: Letter.V)
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
        standardCradle.slot[1].insert(rotor: standardCradle.slot[1].rotor!, position: Letter.E)
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
        standardCradle.slot[2].insert(rotor: standardCradle.slot[2].rotor!, position: Letter.Q)
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
}
