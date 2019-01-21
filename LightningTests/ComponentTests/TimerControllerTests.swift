//
//  TimerControllerTests.swift
//  Lightning
//
//  Created by Göksel Köksal on 09/12/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import XCTest
@testable import Lightning

class TimerControllerTests: XCTestCase {
  
  private let total: TimeInterval = 3
  private let interval: TimeInterval = 1
  private var ticker: MockTicker!
  private var timerController: TimerController!
  
  override func setUp() {
    super.setUp()
    ticker = MockTicker()
    timerController = TimerController(total: total, interval: interval, ticker: ticker)
  }
  
  func testStartTimer() throws {
    // Given:
    var states: [TimerController.State] = []
    timerController.startTimer { state in
      XCTAssertEqual(self.ticker.interval, state.interval)
      XCTAssertEqual(self.ticker.isTicking, state.isTicking)
      states.append(state)
    }
    
    // When:
    ticker.tick(times: 3)
    
    // Then:
    XCTAssertFalse(ticker.isTicking)
    XCTAssertEqual(states.count, 3)
    try states.element(at: 0).assertTicking(total: total, interval: interval, remaining: 2)
    try states.element(at: 1).assertTicking(total: total, interval: interval, remaining: 1)
    try states.element(at: 2).assertStopped(total: total, interval: interval)
  }
  
  func testStopTimer() throws {
    // Given:
    var states: [TimerController.State] = []
    timerController.startTimer { (state) in
      XCTAssertEqual(self.ticker.interval, state.interval)
      XCTAssertEqual(self.ticker.isTicking, state.isTicking)
      states.append(state)
    }
    
    // When:
    ticker.tick()
    ticker.tick()
    timerController.stopTimer()
    
    // Then:
    XCTAssertFalse(ticker.isTicking)
    XCTAssertEqual(states.count, 2)
    try states.element(at: 0).assertTicking(total: total, interval: interval, remaining: 2)
    try states.element(at: 1).assertTicking(total: total, interval: interval, remaining: 1)
  }
  
  func testRealTicker() throws {
    let interval: TimeInterval = 0.01
    let total: TimeInterval = 0.03
    let ticker = Ticker()
    let timerController = TimerController(total: total, interval: interval, ticker: ticker)
    
    // Given:
    var states: [TimerController.State] = []
    let exp = expectation(description: "timer")
    timerController.startTimer { state in
      XCTAssertEqual(ticker.isTicking, state.isTicking)
      states.append(state)
      
      if state.isFinished {
        exp.fulfill()
      }
    }
    
    // When:
    wait(for: [exp], timeout: 0.1)
    
    // Then:
    XCTAssertFalse(ticker.isTicking)
    XCTAssertEqual(states.count, 3)
    try states.element(at: 0).assertTicking(total: total, interval: interval, remaining: 0.02)
    try states.element(at: 1).assertTicking(total: total, interval: interval, remaining: 0.01)
    try states.element(at: 2).assertStopped(total: total, interval: interval)
  }
}

extension TimerController.State {
  
  func assertTicking(total: TimeInterval, interval: TimeInterval, remaining: TimeInterval, file: StaticString = #file, line: UInt = #line) {
    let accuracy: Double = 0.001
    XCTAssertEqual(self.total, total, accuracy: accuracy, file: file, line: line)
    XCTAssertEqual(self.interval, interval, accuracy: accuracy, file: file, line: line)
    XCTAssertEqual(self.remaining, remaining, accuracy: accuracy, file: file, line: line)
    XCTAssertTrue(self.isTicking, file: file, line: line)
    XCTAssertFalse(self.isFinished, file: file, line: line)
  }
  
  func assertStopped(total: TimeInterval, interval: TimeInterval, file: StaticString = #file, line: UInt = #line) {
    let accuracy: Double = 0.001
    XCTAssertEqual(self.total, total, accuracy: accuracy, file: file, line: line)
    XCTAssertEqual(self.interval, interval, accuracy: accuracy, file: file, line: line)
    XCTAssertEqual(self.remaining, 0.0, accuracy: accuracy, file: file, line: line)
    XCTAssertFalse(self.isTicking, file: file, line: line)
    XCTAssertTrue(self.isFinished, file: file, line: line)
  }
}
