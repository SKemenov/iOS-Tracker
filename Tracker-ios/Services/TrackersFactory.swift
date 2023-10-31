//
//  TrackersFactory.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 19.10.2023.
//

import Foundation

// MARK: - Class

final class TrackersFactory {
  // MARK: - Private properties
  private (set) var trackers: [Tracker] = []
  private (set) var categories: [TrackerCategory] = []
  private (set) var completedTrackers: [TrackerRecord] = []

  // MARK: - Public singleton

  static let shared = TrackersFactory()

  // MARK: - Init

  private init() { }

  // MARK: - Public methods

  func addTracker(_ tracker: Tracker, toCategory index: Int) {
    addToFactoryNew(tracker: tracker)
    addToCompletedNew(tracker: tracker)
    var currentCategories = categories
    let currentCategory = currentCategories[index]
    var categoryTrackers = currentCategory.items
    categoryTrackers.append(tracker)
    let updatedCategory = TrackerCategory(
      id: currentCategory.id,
      name: currentCategory.name,
      items: categoryTrackers
    )
    currentCategories.remove(at: index)
    currentCategories.append(updatedCategory)
    categories = currentCategories
  }

  func addNew(category: TrackerCategory) {
    categories.append(category)
  }

  func setTrackerDone(with id: UUID, on date: Date) -> (Int, Bool) {
    var isCompleted = false
    var currentCompletedTrackers = completedTrackers
    let index = findInCompletedTrackerIndex(by: id)
    let currentCompletedTracker = currentCompletedTrackers[index]
    var newDates = currentCompletedTracker.dates
    if let newDatesIndex = newDates.firstIndex(
      where: { Calendar.current.compare($0, to: date, toGranularity: .day) == .orderedSame }
    ) {
      newDates.remove(at: newDatesIndex)
    } else {
      newDates.append(date)
      isCompleted = true
    }
    let updatedCompletedTracker = TrackerRecord(
      id: currentCompletedTracker.id,
      tracker: currentCompletedTracker.tracker,
      dates: newDates,
      days: newDates.count
    )
    currentCompletedTrackers.remove(at: index)
    currentCompletedTrackers.append(updatedCompletedTracker)
    completedTrackers = currentCompletedTrackers
    return (newDates.count, isCompleted)
  }

  func getCounter(with id: UUID, on date: Date) -> (Int, Bool) {
    let tracker = completedTrackers[findInCompletedTrackerIndex(by: id)]
    guard tracker.dates.firstIndex(where: {
      Calendar.current.compare($0, to: date, toGranularity: .day) == .orderedSame
    }) != nil else {
      return (tracker.days, false)
    }
    return (tracker.days, true)
  }
}

// MARK: - Private methods

private extension TrackersFactory {
  func addToFactoryNew(tracker: Tracker) {
    trackers.append(tracker)
  }

  func addToCompletedNew(tracker: Tracker) {
    completedTrackers.append(TrackerRecord(id: UUID(), tracker: tracker, dates: [], days: [].count))
  }

  func findInFactoryTrackerIndex(by id: UUID) -> Int {
    guard let index = trackers.firstIndex(where: { $0.id == id }) else {
      preconditionFailure("Cannot obtain the index")
    }
    return index
  }

  func findInCompletedTrackerIndex(by id: UUID) -> Int {
    let tracker = trackers[findInFactoryTrackerIndex(by: id)]
    guard let index = completedTrackers.firstIndex(where: { $0.tracker == tracker }) else {
      preconditionFailure("Cannot obtain the index")
    }
    return index
  }
}
