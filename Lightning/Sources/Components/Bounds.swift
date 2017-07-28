//
//  Bounds.swift
//  Lightning
//
//  Created by Göksel Köksal on 28/07/2017.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

public enum Bound<T> {
    
    case inclusive(T)
    case exclusive(T)
    
    public var isInclusive: Bool {
        switch self {
        case .inclusive(_):
            return true
        default:
            return false
        }
    }
    
    public var value: T {
        switch self {
        case .inclusive(let value):
            return value
        case .exclusive(let value):
            return value
        }
    }
}

public struct Bounds<T: Comparable> {
    
    public let lower: Bound<T>
    public let upper: Bound<T>
    
    public init(_ lower: Bound<T>, _ upper: Bound<T>) {
        self.lower = lower
        self.upper = upper
    }
    
    public func contains(_ value: T) -> Bool {
        let lowerOK: Bool
        let upperOK: Bool
        
        switch lower {
        case .inclusive(let bound):
            lowerOK = value >= bound
        case .exclusive(let bound):
            lowerOK = value > bound
        }
        
        switch upper {
        case .inclusive(let bound):
            upperOK = value <= bound
        case .exclusive(let bound):
            upperOK = value < bound
        }
        
        return lowerOK && upperOK
    }
}
