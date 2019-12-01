//
//  RandomTestData.swift
//  Lightning
//
//  Created by Göksel Köksal on 1.12.2019.
//  Copyright © 2019 GK. All rights reserved.
//

import Foundation
import Lightning

struct UserDetails: Codable, Equatable {
  let username: String
  let email: String
}

enum TemperatureUnit: String {
  case celsius, fahrenheit
}

enum WeightUnit: String {
  case grams, oz
}

struct RandomTestData {
  var string: String = "string"
  var date: Date = Date()
  var number: NSNumber = NSNumber(integerLiteral: 1)
  var int: Int = -1
  var uint: UInt = 1
  var double: Double = 2.0
  var float: Float = 3.0
  var bool: Bool = true
  var url: URL = URL(string: "https://goksel.dev")!
  var data: Data = "Here goes some data".data(using: .utf8)!
  var array: [UInt] = [1, 2, 3]
  var dictionary: [String: Int] = ["a": 1, "b": 2]
  var userDetails: UserDetails = UserDetails(username: "gokselkk", email: "gokselkoksal@gmail.com")
  var temperatureUnit: TemperatureUnit = .celsius
}
