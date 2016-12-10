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
    
    func testStartTimer() {
        let exp = expectation(description: "timer")
        var remaining = 2.0
        let timerController = TimerController(total: remaining) { state in
            remaining -= state.interval
            XCTAssert(state.remaining == remaining)
            XCTAssert(state.isTicking == true)
            if state.isFinished {
                exp.fulfill()
            }
        }
        timerController.startTimer()
        waitForExpectations(timeout: remaining + 0.1) { error in
            if let error = error {
                XCTFail("TimerController timed out. \(error)")
            } else {
                timerController.testIfStopped()
            }
        }
    }
    
    func testStopTimer() {
        let exp = expectation(description: "timer")
        let total = 2.0
        let timerController = TimerController(total: total)
        timerController.tickHandler = { state in
            XCTAssert(state.remaining == 1.0)
            XCTAssert(state.isTicking == true)
            XCTAssert(state.isFinished == false)
            timerController.stopTimer()
            XCTAssert(timerController.state.isFinished)
            exp.fulfill()
        }
        timerController.startTimer()
        waitForExpectations(timeout: total + 0.1) { error in
            if let error = error {
                XCTFail("TimerController timed out. \(error)")
            } else {
                timerController.testIfStopped()
            }
        }
    }
}

extension TimerController {
    func testIfStopped() {
        XCTAssert(state.remaining == 0.0)
        XCTAssert(state.isTicking == false)
        XCTAssert(state.isFinished)
    }
}
