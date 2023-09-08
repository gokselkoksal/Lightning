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
  private let tolerance: TimeInterval?
  private let runLoopMode: RunLoop.Mode
  
  public var isTicking: Bool {
    return internalTimer != nil
  }  
  
  /// Creates a ticker instance.
  /// - Parameters:
  ///   - tolerance: Timer tolerance. Defaults to nil, which is Foundation default. (See `Foundation.Timer.tolerance`)
  ///   - runLoopMode: Run loop mode for the timer. Defaults to `common`.
  public init(tolerance: TimeInterval? = nil,
              runLoopMode: RunLoop.Mode = .common)
  {
    self.tolerance = tolerance
    self.runLoopMode = runLoopMode
  }
  
  public func start(interval: TimeInterval, handler: @escaping () -> Void) {
    guard isTicking == false else { return }
    
    let timer = Timer(timeInterval: interval, repeats: true) { _ in
      handler()
    }
    // This is an effort to save power. This will tell the scheduling system:
    // "Look, I want this to run every second, but I don’t care if it’s x
    // seconds too late." The tolerance will never cause a timer to fire early,
    // only later. And the tolerance will neither cause a timer to "drift",
    // i.e. when one timer fire is too late, it won’t affect the scheduled time
    // of the next timer fire.
    if let tolerance = tolerance {
      timer.tolerance = tolerance
    }
    // Using `Timer.scheduledTimer(...)` method adds the timer in the default
    // run loop, which can be busy with UI events at times. When it's busy (if
    // the user is scrolling like crazy, for example) timer ticks we receive
    // can get delayed (a few seconds!) That's why we create the timer manually
    // and schedule it with common mode.
    // For more: https://learnappmaking.com/timer-swift-how-to/
    RunLoop.main.add(timer, forMode: runLoopMode)
    self.internalTimer = timer
  }
  
  public func stop() {
    internalTimer?.invalidate()
    internalTimer = nil
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
