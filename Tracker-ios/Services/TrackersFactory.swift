//
//  TrackersFactory.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 19.10.2023.
//

import Foundation

final class TrackersFactory {
  static let shared = TrackersFactory()

  private (set) var trackers: [Tracker] = []
  private (set) var categories: [TrackerCategory] = []

  private init() { }

  func addTracker(_ tracker: Tracker, toCategory index: Int) {
    var currentCategories = categories
    var currentCategory = currentCategories[index]
    var categoryTrackers = currentCategory.items
    categoryTrackers.append(tracker)
    var updatedCategory = TrackerCategory(
      id: currentCategory.id,
      name: currentCategory.name,
      items: categoryTrackers
    )
    currentCategories.remove(at: index)
    currentCategories.append(updatedCategory)
    categories = currentCategories
  }

  func addNew(tracker: Tracker) {
    trackers.append(tracker)
  }

  func addNew(category: TrackerCategory) {
    categories.append(category)
  }

  func removeTrackerWith(index: Int) {
    trackers.remove(at: index)
  }

  func removeCategoryWith(index: Int) {
    categories.remove(at: index)
  }
}
