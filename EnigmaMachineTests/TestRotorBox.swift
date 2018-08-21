//
//  TestRotorBox.swift
//  EnigmaMachine
//
//  Created by Jeremy Pereira on 09/03/2015.
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
        let rotorBox = SpareRotorBox()
        let aRotor = rotorBox.removeRotor(name: "IV")
    	XCTAssert(aRotor != nil && aRotor!.name == "IV", "Wrong name for rotor")
		XCTAssert(rotorBox.count == 4, "Wrong rotor box count")
    }
}
