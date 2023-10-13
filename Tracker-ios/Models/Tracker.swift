//
//  Tracker.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 10.10.2023.
//

import Foundation
import UIKit.UIColor

struct Tracker {
  let id: UUID
  let title: String
  let emoji: String
  let color: UIColor
  let schedule: [DateComponents]?
}

struct TrackerCategory {
  let id: UUID
  let name: String
}

struct TrackerRecord {
  let id: UUID
  let tracker: Tracker
  let date: Date
}
