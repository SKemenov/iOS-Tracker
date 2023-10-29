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
//    print("TF trackers \(trackers)")
//    print("TF categories \(categories)")
//    print("TF completedTrackers \(completedTrackers)")
  }


  func addNew(category: TrackerCategory) {
    categories.append(category)
  }

  func setTrackerDone(with id: UUID, on date: Date) -> (Int, Bool) {
    print("TF Run isTrackerDone()")
    var isCompleted = false
    var currentCompletedTrackers = completedTrackers
    print("TF currentCompletedTrackers \(currentCompletedTrackers)")
    let index = findInCompletedTrackerIndex(by: id)
    print("TF currentCompletedTrackers \(currentCompletedTrackers)")
    print("TF index \(index)")
    let currentCompletedTracker = currentCompletedTrackers[index]

    print("TF Try to catch day \(date) in Dates \(currentCompletedTracker.dates)")
    let indexDate = currentCompletedTracker.dates.firstIndex { $0 == date }
    print("TF isTrackerDone() has index \(String(describing: indexDate))")

    print("TF currentCompletedTracker \(currentCompletedTracker)")
    var newDates = currentCompletedTracker.dates
    if indexDate == nil {
      newDates.append(date)
      print("TF Trying to add new date \(date)")
      isCompleted = true
    } else {
      guard let indexDate else {
        preconditionFailure("Cannot obtain the index")
      }
      newDates.remove(at: indexDate)
      print("TF Trying to remove date at index \(indexDate)")
    }
    print("TF newDates \(newDates)")
    let updatedCompletedTracker = TrackerRecord(
      id: currentCompletedTracker.id,
      tracker: currentCompletedTracker.tracker,
      dates: newDates
    )
    print("TF currentCompletedTrackers before remove \(currentCompletedTrackers)")
    currentCompletedTrackers.remove(at: index)
    print("TF currentCompletedTrackers before append \(currentCompletedTrackers)")
    currentCompletedTrackers.append(updatedCompletedTracker)
    print("TF currentCompletedTrackers final \(currentCompletedTrackers)")
    completedTrackers = currentCompletedTrackers
    print("TF completedTrackers \(completedTrackers)")

    let counter = countDays(for: index)
    print("TF countDays \(String(describing: countDays))")
    return (counter, isCompleted)
  }

  func getCounter(with id: UUID, on date: Date) -> (Int, Bool) {
    let index = findInCompletedTrackerIndex(by: id)
    let trackerDates = completedTrackers[index].dates
    guard trackerDates.firstIndex(where: { $0 == date }) != nil else {
      return (countDays(for: index), false)
    }
    return (countDays(for: index), true)
  }
}

// MARK: - Private methods

private extension TrackersFactory {
  func addToFactoryNew(tracker: Tracker) {
    trackers.append(tracker)
  }

  func addToCompletedNew(tracker: Tracker) {
    print("TF Run addNewCompleted()")
    completedTrackers.append(TrackerRecord(id: UUID(), tracker: tracker, dates: []))
  }

  func countDays(for index: Int) -> Int {
    let trackerRecord = completedTrackers[index]
    let dates = trackerRecord.dates.count
    return dates
  }

  func findInFactoryTrackerIndex(by id: UUID) -> Int {
    print("TF Run findTrackerIndex()")
    guard let index = trackers.firstIndex(where: { $0.id == id }) else {
      preconditionFailure("Cannot obtain the index")
    }
    print("TF Find index of trackers[\(index)] - \(trackers[index])")
    return index
  }

  func findInCompletedTrackerIndex(by id: UUID) -> Int {
    print("TF Run fetchCompletedTrackerIndex()")
    let tracker = trackers[findInFactoryTrackerIndex(by: id)]
    guard let index = completedTrackers.firstIndex(where: { $0.tracker == tracker }) else {
      preconditionFailure("Cannot obtain the index")
    }
    print("TF Find index of completedTrackers[\(index)] - \(completedTrackers[index])")
    return index
  }
}
