//
//  StringFormatterTests.swift
//  Lightning
//
//  Created by Goksel Koksal on 19/12/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import XCTest
@testable import Lightning

class StringFormatterTests: XCTestCase {
  
  let pair1 = (unformatted: "0530880", formatted: "0 (530) 880")
  let pair2 = (unformatted: "05308808080", formatted: "0 (530) 880 80 80")
  let pair3 = (unformatted: "053088080802", formatted: "0 (530) 880 80 802")
  let pair4 = (unformatted: "0", formatted: "0")
  let pair5 = (unformatted: "05", formatted: "0 (5")
  
  let formatter = StringFormatter(pattern: "# (###) ### ## ##")
  
  func testFormat() {
    XCTAssert(formatter.format("") == "")
    XCTAssert(formatter.format(pair1.unformatted) == pair1.formatted)
    XCTAssert(formatter.format(pair2.unformatted) == pair2.formatted)
    XCTAssert(formatter.format(pair3.unformatted) == pair3.formatted)
    XCTAssert(formatter.format(pair4.unformatted) == pair4.formatted)
    XCTAssert(formatter.format(pair5.unformatted) == pair5.formatted)
  }
  
  func testUnformat() {
    XCTAssert(formatter.unformat("") == "")
    XCTAssert(formatter.unformat(pair1.formatted) == pair1.unformatted)
    XCTAssert(formatter.unformat(pair2.formatted) == pair2.unformatted)
    XCTAssert(formatter.unformat(pair3.formatted) == pair3.unformatted)
    XCTAssert(formatter.unformat(pair4.formatted) == pair4.unformatted)
    XCTAssert(formatter.unformat(pair5.formatted) == pair5.unformatted)
  }
  
  func testIsFormatted() {
    XCTAssert(formatter.isFormatted(pair1.formatted))
    XCTAssert(formatter.isFormatted(pair2.formatted))
    XCTAssert(formatter.isFormatted(pair3.formatted))
    XCTAssert(formatter.isFormatted(pair4.formatted))
    XCTAssert(formatter.isFormatted(pair5.formatted))
    
    XCTAssert(formatter.isFormatted("") == false)
    XCTAssert(formatter.isFormatted(pair1.unformatted) == false)
    XCTAssert(formatter.isFormatted(pair2.unformatted) == false)
    XCTAssert(formatter.isFormatted(pair3.unformatted) == false)
    // Pair 4 is an exception: formatted == unformatted
    XCTAssert(formatter.isFormatted(pair5.unformatted) == false)
  }
}
