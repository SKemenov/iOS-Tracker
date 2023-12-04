//
//  Tracker.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 10.10.2023.
//

import Foundation

struct Tracker: Hashable {
  let id: UUID
  let title: String
  let emoji: Int
  let color: Int
  let isPinned: Bool
  let schedule: [Bool]
}

struct TrackerCategory: Hashable {
  let id: UUID
  let name: String
  let items: [Tracker]
}

// struct TrackerRecord: Hashable {
//  let id: UUID
//  let tracker: Tracker
//  let dates: [Date]
//  let days: Int
// }

struct EditTracker: Hashable {
  let tracker: Tracker
  let counter: Int
  let category: TrackerCategory
}
