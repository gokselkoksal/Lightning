//
//  StringHelpersTests.swift
//  Lightning
//
//  Created by Göksel Köksal on 21/12/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import XCTest
@testable import Lightning

class StringHelpersTests: XCTestCase {
    
    let string = "Goksel"
    
    func testIndex() {
        XCTAssert(string[string.zap_index(0)] == "G")
        XCTAssert(string[string.zap_index(1)] == "o")
        XCTAssert(string[string.zap_index(5)] == "l")
        
        XCTAssert(string.zap_character(at: 0) == "G")
        XCTAssert(string.zap_character(at: 1) == "o")
        XCTAssert(string.zap_character(at: 5) == "l")
    }
    
    func testRange() {
        let nsRange = NSRange(location: 0, length: 2)
        
        XCTAssert(string.zap_substring(with: nsRange) == "Go")
        
        let range = string.zap_range(from: nsRange)
        XCTAssert(string.substring(with: range) == "Go")
        
        let rangeIntersection = string.zap_rangeIntersection(with: NSRange(location: 5, length: 4))
        if let rangeIntersection = rangeIntersection {
            XCTAssert(string.substring(with: rangeIntersection) == "l")
        } else {
            XCTFail("StringHelpers: Range intersection should not be nil.")
        }
    }
}
