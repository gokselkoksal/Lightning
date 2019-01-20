//
//  ResultTests.swift
//  Lightning
//
//  Created by Göksel Köksal on 19/11/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import XCTest
@testable import Lightning

class ResultTests: XCTestCase {
  
  enum ResultError: Error {
    case dummy
    case mapFailed
  }
  
  func testValue() {
    let result = Result.success("1")
    let value = result.value
    XCTAssertNotNil(value)
    XCTAssert(value! == "1")
    XCTAssertNil(result.error)
  }
  
  func testError() {
    let result = Result<Any>.failure(ResultError.dummy)
    XCTAssertNil(result.value)
    let error = result.error as? ResultError
    XCTAssertNotNil(error)
    XCTAssert(error! == ResultError.dummy)
  }
  
  func testIsSuccess() {
    let result1 = Result.success("1")
    let result2 = Result<Any>.failure(ResultError.dummy)
    XCTAssert(result1.isSuccess)
    XCTAssert(result2.isSuccess == false)
  }
  
  func testMap() {
    let result = Result.success("1").map { $0 + "2" }.map { $0 + "3" }
    switch result {
    case .success(let value):
      XCTAssert(value == "123")
    default:
      XCTFail("Should be successful.")
    }
  }
  
  func testFlatMap() {
    let result = Result.success("1")
    let mappedResult = result.flatMap { (value) -> Result<Int> in
      if let intVal = Int(value) {
        return Result.success(intVal)
      } else {
        return Result.failure(ResultError.mapFailed)
      }
    }
    switch mappedResult {
    case .success(let value):
      XCTAssertTrue(value == 1)
    default:
      XCTFail("Should be successful.")
    }
  }
}
