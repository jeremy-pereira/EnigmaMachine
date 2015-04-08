//
//  TestEnigmaMachine.swift
//  EnigmaMachine
//
//  Created by Jeremy Pereira on 03/03/2015.
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

class TestEnigmaMachine: XCTestCase
{
    var enigmaMachine: EnigmaMachine = EnigmaMachine()

    override func setUp()
    {
        super.setUp()
        enigmaMachine.insertRotor(Rotor.makeMilitaryIII(), inSlot: 0, position: Letter.A)
        enigmaMachine.insertRotor(Rotor.makeMilitaryII() , inSlot: 1, position: Letter.A)
        enigmaMachine.insertRotor(Rotor.makeMilitaryI()  , inSlot: 2, position: Letter.A)
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
