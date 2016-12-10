//
//  ActivityState.swift
//  Lightning
//
//  Created by Göksel Köksal on 19/11/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import Foundation

/// Model that tracks live activities by counting them.
public struct ActivityState {
    
    /// Possible `ActivityState` exceptions.
    ///
    /// - nothingToRemove: Thrown when `remove()` is called when `count` is 0.
    public enum Exception: Error {
        case nothingToRemove
    }
    
    /// Count of live activities.
    public private(set) var count: UInt = 0 {
        didSet {
            let wasActive = (oldValue > 0)
            isToggled = (wasActive != isActive)
        }
    }
    
    /// True if `isActive` flag is toggled recently.
    public private(set) var isToggled = false
    
    /// Creates an empty activity state.
    public init() { }
    
    /// Flag to indicate if there are live activities.
    public var isActive: Bool {
        return count > 0
    }
    
    /// Adds a new activity to tracker.
    public mutating func add() {
        count += 1
    }
    
    /// Removes an activity from tracker.
    public mutating func remove() throws {
        guard count > 0 else {
            throw Exception.nothingToRemove
        }
        count -= 1
    }
}

extension ActivityState: Equatable {
    
    public static func ==(left: ActivityState, right: ActivityState) -> Bool {
        return left.isToggled == right.isToggled && left.count == right.count
    }
}
