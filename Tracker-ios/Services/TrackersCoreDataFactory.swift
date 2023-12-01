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
  private var selectedWeekDay = 0

  // MARK: - Public singleton

  static let shared = TrackersCoreDataFactory()

  // MARK: - Public properties

  var visibleCategoriesForWeekDay: [TrackerCategory] {
    var newCategories: [TrackerCategory] = []
    trackerCategoryStore.allCategories.forEach { newCategories.append(
      TrackerCategory(id: $0.id, name: $0.name, items: $0.items.filter {
        switch selectedFilterIndex {
        case 2:
          $0.schedule[selectedWeekDay] && (isTrackerDone(with: $0.id, on: selectedDate) == true)
        case 3:
          $0.schedule[selectedWeekDay] && (isTrackerDone(with: $0.id, on: selectedDate) == false)
        default:
          $0.schedule[selectedWeekDay]
        }
      })
    )
    }
    return newCategories.filter { !$0.items.isEmpty }
  }

  var visibleCategoriesForSearch: [TrackerCategory] {
    trackerCategoryStore.allCategories.filter { !$0.items.isEmpty }
  }

  var allCategories: [TrackerCategory] {
    trackerCategoryStore.allCategories
  }

  var totalRecords: Int {
    trackerRecordStore.totalRecords
  }

  var selectedDate = Date() {
    didSet {
      selectedWeekDay = selectedDate.weekday()
    }
  }

  var selectedFilterIndex = 0

  // MARK: - Init

  private init() {
    // clearDataStores() // uncomment to reset trackerStore & trackerCategoryStore
  }
}

// MARK: - Public methods

extension TrackersCoreDataFactory {
  func countCategories() -> Int {
    return trackerCategoryStore.countCategories()
  }

  func fetchCategoryName(by thisIndex: Int) -> String {
    trackerCategoryStore.fetchCategoryName(by: thisIndex)
  }

  func addToStoreNew(category: TrackerCategory) {
    try? trackerCategoryStore.addNew(category: category)
  }

  func addToStoreNew(tracker: Tracker, toCategory categoryId: UUID) {
    if let category = trackerCategoryStore.fetchCategory(by: categoryId) {
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
    !trackerRecordStore.fetchRecords(for: fetchTracker(byID: id)).filter { $0.sameDay(date) }.isEmpty
  }

  func getRecordsCounter(with id: UUID) -> Int {
    trackerRecordStore.countRecords(for: fetchTracker(byID: id))
  }

  func setWeekDayForTracker(with schedule: [Bool]) -> TimeInterval {
    guard schedule[selectedWeekDay] == false else { return 0 }
    var shiftDays = 0
    for day in (0...selectedWeekDay).reversed() where schedule[day] {
      shiftDays = selectedWeekDay - day
      break
    }
    if shiftDays == 0 {
      for day in (selectedWeekDay..<Resources.Labels.shortWeekDays.count) where schedule[day] {
        shiftDays = Resources.Labels.shortWeekDays.count - day + 1
        break
      }
    }
    return TimeInterval(shiftDays * 24 * 60 * 60)
  }
}

// MARK: - Private methods

private extension TrackersCoreDataFactory {
  func clearDataStores() {
    print(#fileID, #function)
    trackerRecordStore.deleteTrackerRecordsFromCoreData()
    trackerStore.deleteTrackersFromCoreData()
    trackerCategoryStore.deleteCategoriesFromCoreData()
    UserDefaults.standard.hasOnboarded = false
    fatalError("STOP! Comment the clearDataStores() method in the init() and restart the app")
  }

  func fetchTracker(byID id: UUID) -> TrackerCoreData {
    guard let tracker = trackerStore.fetchTracker(byID: id) else {
      preconditionFailure("Cannot fount tracker with ID \(id)")
    }
    return tracker
  }
}
