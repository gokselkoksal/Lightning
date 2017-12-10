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
    
    private final class Ref: Equatable {
        var name: String
        
        init(name: String) {
            self.name = name
        }
        
        static func ==(a: Ref, b: Ref) -> Bool {
            return a.name == b.name
        }
    }
    
    func testExample() {
        // Note: NSString is most probably inferred as String at some point.
        // It will not work with Weak struct.
        
        var ref1: Ref? = Ref(name: "str1")
        var ref2: Ref? = Ref(name: "str2")
        var ref3: Ref? = Ref(name: "str3")
        var array = WeakArray<Ref>()
        
        array.test(weakCount: 0, nonNilCount: 0, elements: [])
        array.appendWeak(ref1)
        array.test(weakCount: 1, nonNilCount: 1, elements: [ref1!])
        array.appendWeak(ref2)
        array.test(weakCount: 2, nonNilCount: 2, elements: [ref1!, ref2!])
        ref1 = nil
        array.test(weakCount: 2, nonNilCount: 1, elements: [ref2!])
        array.compact()
        array.test(weakCount: 1, nonNilCount: 1, elements: [ref2!])
        array.appendWeak(ref3)
        array.test(weakCount: 2, nonNilCount: 2, elements: [ref2!, ref3!])
        ref2 = nil
        ref3 = nil
        array.test(weakCount: 2, nonNilCount: 0, elements: [])
        array.removeAll()
        array.test(weakCount: 0, nonNilCount: 0, elements: [])
    }
}

private extension WeakArray where Element: Equatable {
    
    func test(weakCount: Int, nonNilCount: Int, elements: [Element], file: StaticString = #file, line: UInt = #line) {
        let arrayElements = self.elements
        
        XCTAssertEqual(weakCount, weakElements.count, file: file, line: line)
        XCTAssertEqual(nonNilCount, arrayElements.count, file: file, line: line)
        XCTAssertEqual(elements, arrayElements, file: file, line: line)
    }
}
