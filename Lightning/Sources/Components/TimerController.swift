//
//  TimerController.swift
//  Lightning
//
//  Created by Göksel Köksal on 09/12/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import Foundation

public final class TimerController {
  
  public struct State {
    public let total: TimeInterval
    public let interval: TimeInterval
    public fileprivate(set) var remaining: TimeInterval
    public fileprivate(set) var isTicking: Bool = false
    
    public var isFinished: Bool {
      return remaining == 0.0
    }
  }
  
  public private(set) var state: State
  private let ticker: TickerProtocol
  
  public init(
    total: TimeInterval,
    interval: TimeInterval = 1.0,
    ticker: TickerProtocol = Ticker())
  {
    self.state = State(
      total: total,
      interval: interval,
      remaining: total,
      isTicking: false
    )
    self.ticker = ticker
  }
  
  deinit {
    stopTimer()
  }
  
  public func startTimer(handler: @escaping ((TimerController.State) -> Void)) {
    guard state.isTicking == false else { return }
    
    state.isTicking = true
    ticker.start(interval: state.interval) { [weak self] in
      guard let self = self, self.state.isTicking else { return }
      
      let newRemaining = self.state.remaining - self.state.interval
      
      if newRemaining > 0.0 {
        self.state.remaining = newRemaining
      } else {
        self.state.remaining = 0.0
      }
      
      if self.state.remaining == 0.0 {
        self.stopTimer()
      }
      
      handler(self.state)
    }
  }
  
  public func stopTimer() {
    ticker.stop()
    state.remaining = 0.0
    state.isTicking = false
  }
}

// MARK: - Ticker

public protocol TickerProtocol {
  var isTicking: Bool { get }
  func start(interval: TimeInterval, handler: @escaping () -> Void)
  func stop()
}

public final class Ticker: TickerProtocol {
  
  private var internalTimer: Foundation.Timer?
  private var handler: (() -> Void)?
  
  public var isTicking: Bool {
    return internalTimer != nil
  }
  
  public init() { }
  
  public func start(interval: TimeInterval, handler: @escaping () -> Void) {
    guard isTicking == false else { return }
    self.handler = handler
    
    internalTimer = Timer.scheduledTimer(
      timeInterval: interval,
      target: self,
      selector: #selector(tick),
      userInfo: nil,
      repeats: true
    )
  }
  
  public func stop() {
    internalTimer?.invalidate()
    handler = nil
    internalTimer = nil
  }
  
  @objc private func tick() {
    handler?()
  }
}

public final class MockTicker: TickerProtocol {
  
  private var handler: (() -> Void)?
  
  public var interval: TimeInterval?
  public var isTicking: Bool {
    return handler != nil
  }
  
  public init() { }
  
  public func start(interval: TimeInterval, handler: @escaping () -> Void) {
    guard isTicking == false else { return }
    self.interval = interval
    self.handler = handler
  }
  
  public func stop() {
    handler = nil
  }
  
  public func tick(times: Int = 1) {
    for _ in 0..<times {
      handler?()
    }
  }
}

// MARK: - Helpers

extension TimerController.State: Equatable {
  
  public static func ==(a: TimerController.State, b: TimerController.State) -> Bool {
    return a.total == b.total
      && a.interval == b.interval
      && a.remaining == b.remaining
      && a.isTicking == b.isTicking
      && a.isFinished == b.isFinished
  }
}
