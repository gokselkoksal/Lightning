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
    case update(IndexPathSetConvertible)
    case insertion(IndexPathSetConvertible)
    case deletion(IndexPathSetConvertible)
    case move(from: IndexPathConvertible, to: IndexPathConvertible)
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

// MARK: IndexPathConvertible

public protocol IndexPathConvertible {
    func asIndexPath() -> IndexPath
}

extension UInt: IndexPathConvertible {
    public func asIndexPath() -> IndexPath {
        return IndexPath(index: Int(self))
    }
}

extension Int: IndexPathConvertible {
    public func asIndexPath() -> IndexPath {
        return IndexPath(index: self)
    }
}

// MARK: IndexPathSetConvertible

public protocol IndexPathSetConvertible {
    func asIndexPathSet() -> Set<IndexPath>
}

extension IndexSet: IndexPathSetConvertible {
    public func asIndexPathSet() -> Set<IndexPath> {
        var set = Set<IndexPath>()
        self.forEach { set.insert($0.asIndexPath()) }
        return set
    }
}

extension IndexPathSetConvertible where Self: IndexPathConvertible {
    public func asIndexPathSet() -> Set<IndexPath> {
        return Set(arrayLiteral: self.asIndexPath())
    }
}

extension UInt: IndexPathSetConvertible { }
extension Int: IndexPathSetConvertible { }

// MARK: Equatable

public func ==(left: IndexSetConvertible, right: IndexSetConvertible) -> Bool {
    return left.asIndexSet() == right.asIndexSet()
}

public func ==(left: IndexPathConvertible, right: IndexPathConvertible) -> Bool {
    return left.asIndexPath() == right.asIndexPath()
}

public func ==(left: IndexPathSetConvertible, right: IndexPathSetConvertible) -> Bool {
    return left.asIndexPathSet() == right.asIndexPathSet()
}

extension CollectionChange: Equatable {
    
    public static func ==(lhs: CollectionChange, rhs: CollectionChange) -> Bool {
        switch (lhs, rhs) {
        case (.reload, .reload):
            return true
        case (.insertion(let indexes1), .insertion(let indexes2)):
            return indexes1 == indexes2
        case (.deletion(let indexes1), .deletion(let indexes2)):
            return indexes1 == indexes2
        case (.update(let indexes1), .update(let indexes2)):
            return indexes1 == indexes2
        case (.move(let from1, let to1), .move(let from2, let to2)):
            return from1 == from2 && to1 == to2
        default:
            return false
        }
    }
}
