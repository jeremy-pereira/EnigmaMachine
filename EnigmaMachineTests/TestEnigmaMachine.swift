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
import Toolbox

class TestEnigmaMachine: XCTestCase
{
    var enigmaMachine: EnigmaMachine = EnigmaMachine()

    override func setUp()
    {
        super.setUp()
        enigmaMachine.insert(rotor: Rotor.makeMilitaryIII(), inSlot: 0, position: Letter.A)
        enigmaMachine.insert(rotor: Rotor.makeMilitaryII() , inSlot: 1, position: Letter.A)
        enigmaMachine.insert(rotor: Rotor.makeMilitaryI()  , inSlot: 2, position: Letter.A)
        enigmaMachine.insert(reflector: reflectorB, position: Letter.A)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample()
    {
        Logger.pushLevel(.debug, forName: "EnigmaMachine.Components.Connection")
        defer { Logger.popLevel(forName: "EnigmaMachine.Components.Connection") }

        enigmaMachine.plugIn(pair: (Letter.A, Letter.D))
        enigmaMachine.keyDown(aLetter: Letter.A)
        XCTAssert(enigmaMachine.litLamp != nil && enigmaMachine.litLamp! == Letter.M, "Wrong lamp lit \(enigmaMachine.litLamp?.description ?? "")")
        enigmaMachine.keyUp()
        print("\(enigmaMachine.rotorReadOut)")
        XCTAssert(enigmaMachine.litLamp == nil, "A lamp is lit")
    }
}
