//
//  ActivityStateTests.swift
//  Lightning
//
//  Created by Göksel Köksal on 19/11/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import XCTest
@testable import Lightning

class ActivityStateTests: XCTestCase {
  
  func test() {
    var loadingState = ActivityState()
    loadingState.test(isActive: false, count: 0, isToggled: false)
    loadingState.add()
    loadingState.test(isActive: true, count: 1, isToggled: true)
    loadingState.add()
    loadingState.test(isActive: true, count: 2, isToggled: false)
    XCTAssertNoThrow(try loadingState.remove())
    loadingState.test(isActive: true, count: 1, isToggled: false)
    XCTAssertNoThrow(try loadingState.remove())
    loadingState.test(isActive: false, count: 0, isToggled: true)
    XCTAssertThrowsError(try loadingState.remove(), "should throw on removal when there's no activity") { (error) in
      XCTAssertEqual(error as? ActivityState.Exception, ActivityState.Exception.nothingToRemove)
    }
  }
}

extension ActivityState {
  func test(isActive: Bool, count: UInt, isToggled: Bool) {
    XCTAssert(self.isActive == isActive)
    XCTAssert(self.count == count)
    XCTAssert(self.isToggled == isToggled)
  }
}
