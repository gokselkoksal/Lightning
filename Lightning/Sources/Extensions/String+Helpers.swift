//
//  String+Helpers.swift
//  Lightning
//
//  Created by Göksel Köksal on 21/12/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import Foundation

public extension String {
    
    public func zap_index(_ distance: Int) -> String.Index {
        return index(startIndex, offsetBy: distance)
    }
    
    public func zap_range(from range: NSRange) -> Range<String.Index> {
        let rangeStartIndex = zap_index(range.location)
        let rangeEndIndex = zap_index(range.location + range.length)
        return Range(uncheckedBounds: (rangeStartIndex, rangeEndIndex))
    }
    
    public func zap_rangeIntersection(with range: NSRange) -> Range<String.Index>? {
        guard range.location < count else { return nil }
        let proposedEnd = range.location + range.length - 1
        let isOutOfBounds = proposedEnd >= count
        let start = range.location
        let end = isOutOfBounds ? count - 1 : proposedEnd
        let range = NSRange(location: start, length: end - start + 1)
        return zap_range(from: range)
    }
    
    public func zap_character(at distance: Int) -> Character {
        return self[zap_index(distance)]
    }
    
    public func zap_substring(with range: NSRange) -> String {
        let range = zap_range(from: range)
        return String(self[range])
    }
}
