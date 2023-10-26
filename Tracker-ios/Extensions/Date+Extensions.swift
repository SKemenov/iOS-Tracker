//
//  Date+Extensions.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 26.10.2023.
//

import Foundation

extension Date {

  func stripTime() -> Date {
    let calendar = Calendar.current
    let timeZone = calendar.timeZone
    let currentDate = self
    let currentDateString = Resources.dateFormatter.string(from: currentDate)

    var components = calendar.dateComponents([.year, .month, .day], from: self)
    components.timeZone = TimeZone.current
    // guard let date = calendar.date(from: components) else {
    guard let date = dateStringToDate(dateString: currentDateString) else {
      preconditionFailure("Cannot strip the time")
    }

    print("currentDateString \(currentDateString), currentDate \(currentDate), components \(components), date \(date)")
    return date
  }

  func dateStringToDate(dateString: String) -> Date? {
    let dateFormatter = DateFormatter()
    // dateFormatter.locale = Locale.autoupdatingCurrent
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.dateFormat = Resources.dateFormat
    return dateFormatter.date(from: dateString)
  }

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
