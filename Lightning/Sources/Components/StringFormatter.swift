//
//  StringFormatter.swift
//  Lightning
//
//  Created by Goksel Koksal on 19/12/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import Foundation

public class StringFormatter: Formatter {
    
    public let pattern: String
    public let valueCharacter: Character
    
    public init(pattern: String, valueCharacter: Character = "#") {
        self.pattern = pattern
        self.valueCharacter = valueCharacter
    }
    
    public func format(_ value: String) -> String {
        var result = ""
        var index = value.startIndex
        var numberOfChars = 0
        for char in pattern {
            if index == value.endIndex {
                break
            }
            if char == valueCharacter {
                result += String(value[index])
                numberOfChars += 1
                index = value.index(after: index)
            } else {
                result += String(char)
            }
        }
        if numberOfChars < value.count {
            // Add leftover characters to the end:
            result += value[index..<value.endIndex]
        }
        return result
    }
    
    public func unformat(_ value: String) -> String {
        var index = pattern.startIndex
        var result = ""
        var numberOfChars = 0
        for charInPattern in pattern {
            if index == value.endIndex {
                break
            }
            let charInValue = value[index]
            if charInPattern == valueCharacter {
                result += String(charInValue)
                numberOfChars += 1
            } else if charInPattern != valueCharacter && charInPattern != charInValue {
                // Means that the string is not formatted. Abort mission.
                return value
            }
            index = pattern.index(after: index)
        }
        if numberOfChars < value.count {
            // Add leftover characters to the end:
            result += value[index..<value.endIndex]
        }
        return result
    }
    
    public func isFormatted(_ value: String) -> Bool {
        guard value.count > 0 else { return false }
        var index = pattern.startIndex
        for charInPattern in pattern {
            if index == value.endIndex {
                break
            }
            let charInValue = value[index]
            if charInPattern != valueCharacter && charInPattern != charInValue {
                // Means that the string is not formatted. Abort mission.
                return false
            }
            index = pattern.index(after: index)
        }
        return true
    }
}
