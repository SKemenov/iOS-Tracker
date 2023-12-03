//
//  Date+Extensions.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 26.10.2023.
//

import Foundation

extension Date {

  //  func weekday() -> Int {
  //    // Use this Int for Index -> Monday is 0
  //    return Calendar.current.component(.weekday, from: self)
  //    let systemWeekday = Calendar.current.component(.weekday, from: self)
  //    let weekdaySymbols = Calendar.current.weekdaySymbols
  //    let shortWeekdaySymbols = Calendar.current.shortWeekdaySymbols
  //    let veryShortWeekdaySymbols = Calendar.current.veryShortWeekdaySymbols
  //    let shortStandaloneWeekdaySymbols = Calendar.current.shortStandaloneWeekdaySymbols
  //    let firstWeekday = Calendar.current.firstWeekday
  //    print(#function, systemWeekday, Calendar.current.firstWeekday)
  //    if Calendar.current.firstWeekday == 1 {
  //      switch systemWeekday {
  //      case 2...7:
  //        return systemWeekday - 2
  //      default:
  //        return 6
  //      }
  //    } else {
  //      return systemWeekday - 1
  //    }
  //  }

  func sameDay(_ date: Date) -> Bool {
    Calendar.current.compare(self, to: date, toGranularity: .day) == .orderedSame
  }

  func beforeDay(_ date: Date) -> Bool {
    Calendar.current.compare(self, to: date, toGranularity: .day) == .orderedAscending
  }
}
