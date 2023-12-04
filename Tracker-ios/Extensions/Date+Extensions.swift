//
//  Date+Extensions.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 26.10.2023.
//

import Foundation

extension Date {

  func weekdayNumberMondayIsFirst() -> Int {
    // Use this Int for Index -> Monday is 1
    [0, 7, 1, 2, 3, 4, 5, 6][Calendar.current.component(.weekday, from: self)]
  }

  func sameDay(_ date: Date) -> Bool {
    Calendar.current.compare(self, to: date, toGranularity: .day) == .orderedSame
  }

  func beforeDay(_ date: Date) -> Bool {
    Calendar.current.compare(self, to: date, toGranularity: .day) == .orderedAscending
  }
}
