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
  
  fileprivate final class Ref {
    var name: String
    
    init(name: String) {
      self.name = name
    }
  }
  
  func testExample() {
    // Note: NSString is most probably inferred as String at some point.
    // It will not work with Weak struct.
    
    var ref1: Ref? = Ref(name: "str1")
    var ref2: Ref? = Ref(name: "str2")
    var ref3: Ref? = Ref(name: "str3")
    var array = WeakArray<Ref>()
    
    array.assert(weakCount: 0, nonNilCount: 0, elements: [])
    array.append(ref1)
    array.assert(weakCount: 1, nonNilCount: 1, elements: [ref1!])
    array.append(ref2)
    array.assert(weakCount: 2, nonNilCount: 2, elements: [ref1!, ref2!])
    ref1 = nil
    array.assert(weakCount: 2, nonNilCount: 1, elements: [ref2!])
    array.compact()
    array.assert(weakCount: 1, nonNilCount: 1, elements: [ref2!])
    array.append(ref3)
    array.assert(weakCount: 2, nonNilCount: 2, elements: [ref2!, ref3!])
    ref2 = nil
    ref3 = nil
    array.assert(weakCount: 2, nonNilCount: 0, elements: [])
    array.weakElements.removeAll()
    array.assert(weakCount: 0, nonNilCount: 0, elements: [])
  }
}

private extension WeakArray where Element == WeakTests.Ref {
  
  func assert(
    weakCount: Int,
    nonNilCount: Int,
    elements expectedElements: [Element],
    file: StaticString = #file,
    line: UInt = #line)
  {
    let actualElements = self.strongElements()
    
    XCTAssertEqual(weakCount, weakElements.count, file: file, line: line)
    XCTAssertEqual(nonNilCount, actualElements.count, file: file, line: line)
    XCTAssertEqual(actualElements.count, expectedElements.count, file: file, line: line)
    
    for pair in zip(actualElements, expectedElements) {
      XCTAssertTrue(pair.0 === pair.1, file: file, line: line)
    }
  }
}
