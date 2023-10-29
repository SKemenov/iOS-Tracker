//
//  Tracker.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 10.10.2023.
//

import Foundation
import UIKit.UIColor

struct Tracker: Hashable {
  let id: UUID
  let title: String
  let emoji: Int
  let color: Int
  let schedule: [Bool]
}

struct TrackerCategory: Hashable {
  let id: UUID
  let name: String
  let items: [Tracker]
}

struct TrackerRecord: Hashable {
  let id: UUID
  let tracker: Tracker
  let dates: [Date]
}
