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
    try? loadingState.remove()
    loadingState.test(isActive: true, count: 1, isToggled: false)
    try? loadingState.remove()
    loadingState.test(isActive: false, count: 0, isToggled: true)
    do {
      try loadingState.remove()
    } catch let error as ActivityState.Exception {
      XCTAssert(error == ActivityState.Exception.nothingToRemove)
    } catch {
      XCTFail("Cannot throw anything else.")
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
