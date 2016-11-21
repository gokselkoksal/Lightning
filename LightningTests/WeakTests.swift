//
//  WeakTests.swift
//  Lightning
//
//  Created by Göksel Köksal on 22/11/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import XCTest
@testable import Lightning

class WeakTests: XCTestCase {
    
    func testExample() {
        var string1: NSString? = "str1"
        var string2: NSString? = "str2"
        var string3: NSString? = "str3"
        var array = WeakArray<NSString>()
        
        array.test(weakCount: 0, nonNilCount: 0, elements: [])
        array.appendWeak(string1)
        array.test(weakCount: 1, nonNilCount: 1, elements: [string1!])
        array.appendWeak(string2)
        array.test(weakCount: 2, nonNilCount: 2, elements: [string1!, string2!])
        string1 = nil
        array.test(weakCount: 2, nonNilCount: 1, elements: [string2!])
        array.compact()
        array.test(weakCount: 1, nonNilCount: 1, elements: [string2!])
        array.appendWeak(string3)
        array.test(weakCount: 2, nonNilCount: 2, elements: [string2!, string3!])
        string2 = nil
        string3 = nil
        array.test(weakCount: 2, nonNilCount: 0, elements: [])
        array.removeAll()
        array.test(weakCount: 0, nonNilCount: 0, elements: [])
    }
}

extension WeakArray where Element: Equatable {
    
    func test(weakCount: Int, nonNilCount: Int, elements: [Element]) {
        XCTAssert(weakCount == weakElements.count)
        XCTAssert(nonNilCount == self.elements.count)
        XCTAssert(elements == self.elements)
    }
}
