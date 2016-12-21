//
//  StringMask.swift
//  Lightning
//
//  Created by Göksel Köksal on 20/12/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import Foundation

struct StringMask {
    
    let ranges: [NSRange]
    let character: Character
    
    init(ranges: [NSRange], character: Character = "*") {
        self.ranges = ranges
        self.character = character
    }
    
    func mask(_ string: String) -> String {
        guard string.characters.count > 0 else { return string }
        let stringRanges = ranges.flatMap { string.zap_rangeIntersection(with: $0) }
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
        for char in string.characters {
            result += String(shouldMaskIndex(index) ? character : char)
            index = string.index(after: index)
        }
        return result
    }
}

struct StringMaskStorage {
    
    var mask: StringMask {
        didSet {
            update()
        }
    }
    
    var original: String? {
        didSet {
            update()
        }
    }
    
    private(set) var masked: String?
    
    init(mask: StringMask) {
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
