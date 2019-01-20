//
//  StringMaskTests.swift
//  Lightning
//
//  Created by Göksel Köksal on 20/12/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import XCTest
@testable import Lightning

class StringMaskTests: XCTestCase {
  
  func testMasking() {
    let range01 = NSRange(location: 0, length: 1)
    let range21 = NSRange(location: 2, length: 1)
    let range42 = NSRange(location: 4, length: 2)
    let range53 = NSRange(location: 5, length: 3)
    
    var storage = StringMaskStorage(mask: StringMask(ranges: [range01, range21]))
    
    XCTAssert(storage.original == nil)
    XCTAssert(storage.masked == nil)
    
    storage.original = "G😀ksel"
    XCTAssert(storage.masked == "*😀*sel")
    
    storage.original = "😀😀😀"
    XCTAssert(storage.masked == "*😀*")
    
    storage.original = "Koksal"
    XCTAssert(storage.masked == "*o*sal")
    
    storage.mask = StringMask(ranges: [range01, range42, range53])
    XCTAssert(storage.masked == "*oks**")
    
    storage.mask = StringMask(ranges: [])
    XCTAssert(storage.masked == "Koksal")
  }
}
