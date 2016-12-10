//
//  DictionaryHelpersTests.swift
//  Lightning
//
//  Created by Göksel Köksal on 10/12/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import XCTest
@testable import Lightning

class DictionaryHelpersTests: XCTestCase {
    
    func testSum() {
        let pair1 = (key: "k1", value: "v1")
        let pair2 = (key: "k2", value: "v2")
        let pair3 = (key: "k3", value: "v3")
        
        let dict1 = [pair1.key: pair1.value, pair2.key: pair2.value]
        let dict2 = [pair3.key: pair3.value]
        let dict3 = dict1 + dict2
        
        XCTAssert(dict3.keys.count == 3)
        XCTAssert(dict3[pair1.key] == pair1.value)
        XCTAssert(dict3[pair2.key] == pair2.value)
        XCTAssert(dict3[pair3.key] == pair3.value)
    }
    
    func testSumEqual() {
        let pair1 = (key: "k1", value: "v1")
        let pair2 = (key: "k2", value: "v2")
        let pair3 = (key: "k3", value: "v3")
        let pair4 = (key: "k1", value: "different-value") // test overwrite
        
        var dict1 = [pair1.key: pair1.value, pair2.key: pair2.value]
        let dict2 = [pair3.key: pair3.value, pair4.key: pair4.value]
        dict1 += dict2
        
        XCTAssert(dict1.keys.count == 3)
        XCTAssert(pair1.key == pair4.key)
        XCTAssert(dict1[pair1.key] == pair4.value)
        XCTAssert(dict1[pair2.key] == pair2.value)
        XCTAssert(dict1[pair3.key] == pair3.value)
    }
}
