//
//  StringMask.swift
//  Lightning
//
//  Created by Göksel Köksal on 20/12/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import Foundation

public class StringMask {
    
    public let ranges: [NSRange]
    public let character: Character
    
    public init(ranges: [NSRange], character: Character = "*") {
        self.ranges = ranges
        self.character = character
    }
    
    public func mask(_ string: String) -> String {
        guard string.count > 0 else { return string }
        let stringRanges = ranges.compactMap { string.zap_rangeIntersection(with: $0) }
        func shouldMaskIndex(_ index: String.Index) -> Bool {
            for range in stringRanges {
                if range.contains(index) {
                    return true
                }
            }
            return false
        }
        var result = ""
        var index = string.startIndex
        for char in string {
            result += String(shouldMaskIndex(index) ? character : char)
            index = string.index(after: index)
        }
        return result
    }
}

public struct StringMaskStorage {
    
    public var mask: StringMask {
        didSet {
            update()
        }
    }
    
    public var original: String? {
        didSet {
            update()
        }
    }
    
    public private(set) var masked: String?
    
    public init(mask: StringMask) {
        self.mask = mask
    }
    
    private mutating func update() {
        if let original = original {
            masked = mask.mask(original)
        } else {
            masked = nil
        }
    }
}
