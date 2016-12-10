//
//  TimerController.swift
//  Lightning
//
//  Created by Göksel Köksal on 09/12/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import Foundation

public class TimerController {
    
    public struct State {
        public let total: TimeInterval
        public let interval: TimeInterval
        public fileprivate(set) var remaining: TimeInterval
        public fileprivate(set) var isTicking: Bool = false
        public var isFinished: Bool {
            return remaining == 0.0
        }
    }
    
    public typealias TickHandler = ((TimerController.State) -> Void)
    
    public private(set) var state: State
    public var tickHandler: TickHandler?
    private var timer: Timer?
    
    public init(total: TimeInterval, interval: TimeInterval = 1.0, tickHandler: TickHandler? = nil) {
        self.state = State(
            total: total,
            interval: interval,
            remaining: total,
            isTicking: false
        )
        self.tickHandler = tickHandler
    }
    
    deinit {
        stopTimer()
    }
    
    public func startTimer() {
        guard state.isTicking == false else { return }
        state.isTicking = true
        Timer.scheduledTimer(
            timeInterval: state.interval,
            target: self,
            selector: #selector(tick),
            userInfo: nil,
            repeats: true
        )
    }
    
    public func stopTimer() {
        timer?.invalidate()
        timer = nil
        state.remaining = 0.0
        state.isTicking = false
    }
    
    @objc private func tick() {
        guard state.isTicking else { return }
        let newRemaining = state.remaining - state.interval
        
        if newRemaining > 0.0 {
            state.remaining = newRemaining
        } else {
            state.remaining = 0.0
        }
        
        tickHandler?(state)
        
        if state.remaining == 0.0 {
            stopTimer()
        }
    }
}
