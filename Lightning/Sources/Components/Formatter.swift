//
//  Formatter.swift
//  Lightning
//
//  Created by Goksel Koksal on 19/12/2016.
//  Copyright © 2016 GK. All rights reserved.
//

import Foundation

public protocol Formatter {
    associatedtype Value
    func format(_ value: Value) -> Value
    func unformat(_ value: Value) -> Value
    func isFormatted(_ value: Value) -> Bool
}
