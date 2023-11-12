//
//  TrackersCoreDataFactory.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 04.11.2023.
//

import Foundation

enum TrackersCoreDataFactoryError: Error {
  case decodingErrorInvalidId
  case decodingErrorInvalidName
  case decodingErrorInvalidTrackers
  case decodingErrorInvalidEmoji
  case decodingErrorInvalidColor
  case decodingErrorInvalidSchedule
  case recordingErrorAddNewDate
}

final class TrackersCoreDataFactory {
  // MARK: - Private properties
  private let trackerStore = TrackerStore()
  private let trackerCategoryStore = TrackerCategoryStore.shared
  private let trackerRecordStore = TrackerRecordStore()

  // MARK: - Public singleton

  static let shared = TrackersCoreDataFactory()

  // MARK: - Init

  private init() {
    self.trackerCategoryStore.delegate = self
  }
}

extension TrackersCoreDataFactory {
  func fetchVisibleCategories() -> [TrackerCategory] {
    print("TCDF Run fetchVisibleCategories()")
    var categories: [TrackerCategory] = []
    let hasTrackers = trackerCategoryStore.isCategoryCoreDataHasTrackers()
    if hasTrackers {
      print("trackerCategoryStore.isCategoryCoreDataHasTrackers() = \(hasTrackers)")
      do {
        categories = try trackerCategoryStore.fetchVisibleCategories()
      } catch {
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
      print("fetchVisibleCategories return [TrackerCategory]")
      return categories
    } else {
      print("trackerCategoryStore.isCategoryCoreDataHasTrackers() = \(hasTrackers)")
      print("fetchVisibleCategories return []")
      return categories
    }
  }

  func countCategories() -> Int {
    print("TCDF Run countCategories()")
    return trackerCategoryStore.countCategories()
  }

  func fetchCategoryName(by thisIndex: Int) -> String {
    print("TCDF Run fetchCategoryName(by:)")
    return trackerCategoryStore.fetchCategoryName(by: thisIndex)
  }

  func addToStoreNew(tracker: Tracker, toCategory categoryIndex: Int) {
    print("TCDF Run addToStoreNew(tracker:)")
    guard let category = trackerCategoryStore.fetchCategory(by: categoryIndex) else {
      preconditionFailure("Cannot obtain category by index")
    }
    try? trackerStore.addNew(tracker: tracker, to: category)
  }

  func addToStoreNew(category: TrackerCategory) {
    print("TCDF Run addToStoreNew(category:)")
    try? trackerCategoryStore.addNew(category: category)
  }

  func fetchTracker(byID id: UUID) -> TrackerCoreData {
    guard let tracker = trackerStore.fetchTracker(byID: id) else {
      preconditionFailure("Cannot fount tracker with ID \(id)")
    }
    return tracker
  }

  func setTrackerDone(with id: UUID, on date: Date) -> Bool {
    print("TCDF Run setTrackerDone(withID:onDate:)")
    var isCompleted = false
    if isTrackerDone(with: id, on: date) {
      trackerRecordStore.removeRecord(on: date)
    } else {
      try? trackerRecordStore.addNew(recordDate: date, toTracker: fetchTracker(byID: id))
      isCompleted.toggle()
    }
    //    var currentCompletedTrackers = completedTrackers
    //    let index = findInCompletedTrackerIndex(by: id)
    //    let currentCompletedTracker = currentCompletedTrackers[index]
    //    var newDates = currentCompletedTracker.dates
    //    if let newDatesIndex = newDates.firstIndex(
    //      where: { Calendar.current.compare($0, to: date, toGranularity: .day) == .orderedSame }
    //    ) {
    //      newDates.remove(at: newDatesIndex)
    //    } else {
    //      newDates.append(date)
    //      isCompleted = true
    //    }
    //    let updatedCompletedTracker = TrackerRecord(
    //      id: currentCompletedTracker.id,
    //      tracker: currentCompletedTracker.tracker,
    //      dates: newDates,
    //      days: newDates.count
    //    )
    //    currentCompletedTrackers.remove(at: index)
    //    currentCompletedTrackers.append(updatedCompletedTracker)
    //    completedTrackers = currentCompletedTrackers
    //    return (newDates.count, isCompleted)
    return isCompleted
  }

  func isTrackerDone(with id: UUID, on date: Date) -> Bool {
    print("TCDF Run isTrackerDone(withID:onDate:)")
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

extension TrackersCoreDataFactory: TrackerCategoryStoreDelegate {
  func trackerCategory(from trackerCategoryCoreData: TrackerCategoryCoreData) throws -> TrackerCategory {
    guard let id = trackerCategoryCoreData.id else {
      throw TrackersCoreDataFactoryError.decodingErrorInvalidId
    }
    guard let name = trackerCategoryCoreData.name else {
      throw TrackersCoreDataFactoryError.decodingErrorInvalidName
    }
    guard let trackersFromCoreData = trackerCategoryCoreData.trackers else {
      throw TrackersCoreDataFactoryError.decodingErrorInvalidTrackers
    }
    var trackers: [Tracker] = []
    try trackersFromCoreData.forEach { tracker in
      guard
        let tracker = tracker as? TrackerCoreData,
        let tracker = try? self.tracker(from: tracker)
      else {
        throw TrackerCategoryStoreError.decodingError
      }
      trackers.append(tracker)
    }
    // let trackers: [Tracker] = try trackersFromCoreData.map { try self.tracker(from: $0 as? TrackerCoreData) }
    return TrackerCategory(id: id, name: name, items: trackers)
  }
}

extension TrackersCoreDataFactory {
  func tracker(from trackerCoreData: TrackerCoreData) throws -> Tracker {
    guard let id = trackerCoreData.id else {
      throw TrackersCoreDataFactoryError.decodingErrorInvalidId
    }
    guard let title = trackerCoreData.title else {
      throw TrackersCoreDataFactoryError.decodingErrorInvalidName
    }
    return Tracker(
      id: id,
      title: title,
      emoji: Int(trackerCoreData.emoji),
      color: Int(trackerCoreData.color),
      schedule: [
        trackerCoreData.monday,
        trackerCoreData.tuesday,
        trackerCoreData.wednesday,
        trackerCoreData.thursday,
        trackerCoreData.friday,
        trackerCoreData.saturday,
        trackerCoreData.sunday
      ]
    )
  }
}
