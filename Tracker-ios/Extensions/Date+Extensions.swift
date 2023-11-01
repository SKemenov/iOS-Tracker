//
//  Date+Extensions.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 26.10.2023.
//

import Foundation

extension Date {

  func weekday() -> Int {
    let systemWeekday = Calendar.current.component(.weekday, from: self)
    if Calendar.current.firstWeekday == 1 {
      switch systemWeekday {
      case 2...7:
        return systemWeekday - 1
      default:
        return 7
      }
    } else {
      return systemWeekday
    }
  }
}
