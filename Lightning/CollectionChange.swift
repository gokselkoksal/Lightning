//
//  CollectionChange.swift
//  Lightning
//
//  Created by Göksel Köksal on 19/11/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import Foundation

public enum CollectionChange {
    case reload
    case update(IndexSetConvertible)
    case insertion(IndexSetConvertible)
    case deletion(IndexSetConvertible)
    case move(from: Int, to: Int)
}

// MARK: IndexSetConvertible

public protocol IndexSetConvertible {
    func asIndexSet() -> IndexSet
}

extension IndexSet: IndexSetConvertible {
    public func asIndexSet() -> IndexSet {
        return self
    }
}

extension UInt: IndexSetConvertible {
    public func asIndexSet() -> IndexSet {
        return IndexSet(integer: Int(self))
    }
}

extension Int: IndexSetConvertible {
    public func asIndexSet() -> IndexSet {
        return IndexSet(integer: self)
    }
}

// MARK: Equatable

extension CollectionChange: Equatable {
    
    public static func ==(lhs: CollectionChange, rhs: CollectionChange) -> Bool {
        switch (lhs, rhs) {
        case (.reload, .reload):
            return true
        case (.insertion(let indexes1), .insertion(let indexes2)):
            return indexes1.asIndexSet() == indexes2.asIndexSet()
        case (.deletion(let indexes1), .deletion(let indexes2)):
            return indexes1.asIndexSet() == indexes2.asIndexSet()
        case (.update(let indexes1), .update(let indexes2)):
            return indexes1.asIndexSet() == indexes2.asIndexSet()
        case (.move(let from1, let to1), .move(let from2, let to2)):
            return (from1, to1) == (from2, to2)
        default:
            return false
        }
    }
}
