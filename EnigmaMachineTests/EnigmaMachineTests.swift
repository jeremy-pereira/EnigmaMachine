//
//  EnigmaMachineTests.swift
//  EnigmaMachineTests
//
//  Created by Jeremy Pereira on 24/02/2015.
//  Copyright (c) 2015 Jeremy Pereira. All rights reserved.
//

import Cocoa
import XCTest

class EnigmaMachineTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample()
    {
        var data: NSData = "Error".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        var outputString:NSString = NSString(data:data, encoding:NSUTF8StringEncoding)!
        NSLog("outputString: %@", outputString)
        XCTAssert(outputString == "Error", "outputString is wrong \(outputString)")
     }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
