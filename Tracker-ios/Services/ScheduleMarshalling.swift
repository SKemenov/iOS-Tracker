//
//  ScheduleMarshalling.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 05.11.2023.
//

import Foundation

// MARK: - Class

final class ScheduleMarshalling {
  // MARK: - Public methods

  func makeArray(from string: String) -> [Bool] {
    var array: [Bool] = []
    string.forEach { array.append($0 == "1" ? true : false) }
    return array
  }

  func makeString(from schedule: [Bool]) -> String {
    var scheduleToString: [String] = []
    schedule.forEach { scheduleToString.append($0 == true ? "1" : "0") }
    return scheduleToString.joined()
  }
}
