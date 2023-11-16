//
//  Date+Extensions.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 26.10.2023.
//

import Foundation

extension Date {

  func weekday() -> Int {
    // Use this Int for Index -> Monday is 0
    let systemWeekday = Calendar.current.component(.weekday, from: self)
    if Calendar.current.firstWeekday == 1 {
      switch systemWeekday {
      case 2...7:
        return systemWeekday - 2
      default:
        return 6
      }
    } else {
      return systemWeekday - 2
    }
  }

  func sameDay(_ date: Date) -> Bool {
    Calendar.current.compare(self, to: date, toGranularity: .day) == .orderedSame
  }

  func beforeDay(_ date: Date) -> Bool {
    Calendar.current.compare(self, to: date, toGranularity: .day) == .orderedAscending
  }
}
