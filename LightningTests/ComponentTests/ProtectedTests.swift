//
//  ProtectedTests.swift
//  Lightning
//
//  Created by Goksel Koksal on 21/11/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import XCTest
@testable import Lightning

class ProtectedTests: XCTestCase {
  
  func testReadWrite_array() {
    let protectedList = Protected(["item1"])
    XCTAssert(protectedList.value == ["item1"])
    protectedList.value = ["item1", "item2"]
    XCTAssert(protectedList.value == ["item1", "item2"])
    protectedList.read { items in
      XCTAssert(items == ["item1", "item2"])
    }
    protectedList.write { list in
      list.append("item3")
      list.append("item4")
      list = list.map { string in
        let index = string.index(string.startIndex, offsetBy: 4)
        return String(string[index..<string.endIndex])
      }
    }
    XCTAssert(protectedList.value == ["1", "2", "3", "4"])
  }
  
  func testReadWrite_int() {
    let protectedNumber = Protected(1)
    protectedNumber.write { (number) in
      number = 2
    }
    XCTAssertEqual(protectedNumber.value, 2)
  }
  
  func testReadWrite_string() {
    let protectedString = Protected("Goksel")
    protectedString.write { (string) in
      string = "Koksal"
    }
    XCTAssertEqual(protectedString.value, "Koksal")
  }
  
  func testReadWrite_struct() {
    
    struct SomeStruct { // Local struct for testing purposes.
      
      var number: Int
      
      mutating func increment() {
        number += 1
      }
    }
    
    let protectedSomeStruct = Protected(SomeStruct(number: 1))
    protectedSomeStruct.write { (someStruct) in
      someStruct.increment()
    }
    XCTAssertEqual(protectedSomeStruct.value.number, 2)
  }
}
