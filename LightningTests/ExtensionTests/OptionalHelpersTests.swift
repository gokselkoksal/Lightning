//
//  OptionalHelpersTests.swift
//  Lightning
//
//  Created by Göksel Köksal on 5.03.2018.
//  Copyright © 2018 GK. All rights reserved.
//

import XCTest
@testable import Lightning

class OptionalHelpersTests: XCTestCase {
  
  func testExample() throws {
    var string: String? = "x"
    XCTAssertEqual(try string.unwrap(), "x")
    
    string = nil
    XCTAssertThrowsError(try string.unwrap(), "Expected to throw.") { (error) in
      XCTAssertTrue(error is Optional<String>.FoundNilWhileUnwrappingError)
    }
  }
}
