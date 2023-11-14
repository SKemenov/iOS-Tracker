//
//  TrackersCoreDataFactory.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 04.11.2023.
//

import Foundation

// MARK: - Class

final class TrackersCoreDataFactory {
  // MARK: - Private properties
  private let trackerStore = TrackerStore()
  private let trackerCategoryStore = TrackerCategoryStore.shared
  private let trackerRecordStore = TrackerRecordStore()

  // MARK: - Public singleton

  static let shared = TrackersCoreDataFactory()

  // MARK: - Init

  private init() {
    // clearDataStores() // uncomment to reset trackerStore & trackerCategoryStore
  }

  func countCategories() -> Int {
    return trackerCategoryStore.countCategories()
  }


  func fetchCategoryName(by thisIndex: Int) -> String {
    trackerCategoryStore.fetchCategoryName(by: thisIndex)
  }

  func addToStoreNew(tracker: Tracker, toCategory categoryIndex: Int) {
    if let category = trackerCategoryStore.fetchCategory(by: categoryIndex) {
      try? trackerStore.addNew(tracker: tracker, to: category)
    }
  }

  func setTrackerDone(with id: UUID, on date: Date) -> Bool {
    var isCompleted = false
    if isTrackerDone(with: id, on: date) {
      trackerRecordStore.removeRecord(on: date, toTracker: fetchTracker(byID: id))
    } else {
      try? trackerRecordStore.addNew(recordDate: date, toTracker: fetchTracker(byID: id))
      isCompleted.toggle()
    }
    return isCompleted
  }

  func isTrackerDone(with id: UUID, on date: Date) -> Bool {
    var isCompleted = false
    let dates = trackerRecordStore.fetchRecords(for: fetchTracker(byID: id))
    let calendar = Calendar.current
    if (dates.firstIndex(where: { calendar.compare($0, to: date, toGranularity: .day) == .orderedSame }) != nil) {
      isCompleted.toggle()
    }
    return isCompleted
  }

  func getRecordsCounter(with id: UUID) -> Int {
    trackerRecordStore.countRecords(for: fetchTracker(byID: id))
  }
}

// MARK: - Private methods

private extension TrackersCoreDataFactory {
  func clearDataStores() {
    print(#fileID, #function)
    trackerStore.deleteTrackersFromCoreData()
    trackerCategoryStore.deleteCategoriesFromCoreData()
  }

  func fetchTracker(byID id: UUID) -> TrackerCoreData {
    guard let tracker = trackerStore.fetchTracker(byID: id) else {
      preconditionFailure("Cannot fount tracker with ID \(id)")
    }
    return tracker
  }
}
