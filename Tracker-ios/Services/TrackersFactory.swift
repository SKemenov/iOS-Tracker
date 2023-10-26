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
  private (set) var completedTrackers: [TrackerRecord] = []

  private init() { }

  func addTracker(_ tracker: Tracker, toCategory index: Int) {
    print("TF Run addTracker()")
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

  func addDayToTracker(with id: UUID, for date: Date) {
    print("TF Run addDayToTracker()")
    var currentCompletedTrackers = completedTrackers
    print("TF currentCompletedTrackers \(currentCompletedTrackers)")
    let index = fetchCompletedTrackerIndex(by: id)
    print("TF currentCompletedTrackers \(currentCompletedTrackers)")
    print("TF index \(index)")
    let currentCompletedTracker = currentCompletedTrackers[index]
    print("TF currentCompletedTracker \(currentCompletedTracker)")
    var newDates = currentCompletedTracker.date
    newDates.append(date)
    print("TF newDates \(newDates)")
    let updatedCompletedTracker = TrackerRecord(
      id: currentCompletedTracker.id,
      tracker: currentCompletedTracker.tracker,
      date: newDates
    )
    print("TF currentCompletedTrackers before remove \(currentCompletedTrackers)")
    currentCompletedTrackers.remove(at: index)
    print("TF currentCompletedTrackers before append \(currentCompletedTrackers)")
    currentCompletedTrackers.append(updatedCompletedTracker)
    print("TF currentCompletedTrackers final \(currentCompletedTrackers)")
    completedTrackers = currentCompletedTrackers
    print("TF completedTrackers \(completedTrackers)")
  }

  func addNewCompleted(tracker: Tracker) {
    print("TF Run addNewCompleted()")
    completedTrackers.append(TrackerRecord(id: UUID(), tracker: tracker, date: []))
  }

  func findTrackerIndex(by id: UUID) -> Tracker {
    print("TF Run findTrackerIndex()")
    guard let index = trackers.firstIndex(where: { $0.id == id }) else {
      preconditionFailure("error")
    }
    return trackers[index]
  }

  func findIndexForCompleted(_ tracker: Tracker) -> Int {
    print("TF Run findIndexForCompleted()")
    guard let index = completedTrackers.firstIndex(where: { $0.tracker == tracker }) else {
      preconditionFailure("error")
    }
    return index
  }

  func isCompleted(_ tracker: Tracker) -> Bool {
    completedTrackers.contains { $0.tracker == tracker }
  }

  func fetchCompletedTrackerIndex(by id: UUID) -> Int {
    print("TF Run fetchCompletedTrackerIndex()")
    let tracker = findTrackerIndex(by: id)
    if !isCompleted(tracker) {
      addNewCompleted(tracker: tracker)
    }
    return findIndexForCompleted(tracker)
  }
}
