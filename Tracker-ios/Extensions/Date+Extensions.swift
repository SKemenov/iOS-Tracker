//
//  Date+Extensions.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 26.10.2023.
//

import Foundation

extension Date {

//  func stripTime() -> Date {
//    let calendar = Calendar.current
//    let currentDate = self // + TimeInterval(Resources.shiftTimeZone)
//    var components = calendar.dateComponents([.year, .month, .day, .timeZone, .hour], from: currentDate)
//    guard let date = calendar.date(from: components) else {
//      preconditionFailure("Cannot strip the time")
//    }
//    return date
//  }

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
