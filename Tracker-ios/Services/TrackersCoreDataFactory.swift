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
  private var selectedWeekDayIndex = 0 {
    didSet {
      print(#function, selectedWeekDayIndex)
    }
  }

  // MARK: - Public singleton

  static let shared = TrackersCoreDataFactory()

  // MARK: - Public properties

  var visibleCategoriesForWeekDay: [TrackerCategory] {
    var newCategories: [TrackerCategory] = []
    if
      !pinnedTrackers.isEmpty,
      let pinnedCategoryId = trackerCategoryStore.pinnedCategoryId,
      let pinnedCategory = allCategories.first(where: { $0.id == pinnedCategoryId }) {
      // print(#function, "pinnedTrackers.isEmpty is ", pinnedTrackers.isEmpty)
      // let pinnedCategory = allCategories.filter { $0.name == Resources.pinCategoryName }[0]
      newCategories.append(
        TrackerCategory(id: pinnedCategory.id, name: pinnedCategory.name, items: filteredTrackers(from: pinnedTrackers))
      )
    }
    trackerCategoryStore.allCategories.forEach {
      newCategories.append(TrackerCategory(
        id: $0.id,
        name: $0.name,
        items: filteredTrackers(from: $0.items.filter { !pinnedTrackers.contains($0) })
      ))
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

  var pinnedTrackers: [Tracker] {
    trackerStore.pinnedTrackers
  }
  
  var customCalendar = Calendar(identifier: .gregorian) {
    didSet {
      customCalendar.firstWeekday = 2
      print(#function, customCalendar.firstWeekday)
    }
  }

  var selectedDate = Date() {
    didSet {
      // selectedWeekDayIndex = selectedDate.weekday()
      selectedWeekDayIndex = Calendar.current.component(.weekday, from: selectedDate) - 1
    }
  }

  var selectedFilterIndex = 0

  // MARK: - Init

  private init() {
    customCalendar.firstWeekday = 2
    print(#function, customCalendar.firstWeekday)
    // clearDataStores() // uncomment to reset trackerStore & trackerCategoryStore
  }
}

// MARK: - Public methods

extension TrackersCoreDataFactory {
  //  func countCategories() -> Int {
  //    return trackerCategoryStore.countCategories()
  //  }

  func fetchCategoryName(by thisIndex: Int) -> String {
    trackerCategoryStore.fetchCategoryName(by: thisIndex)
  }

  func filteredTrackers(from trackers: [Tracker]) -> [Tracker] {
    trackers.filter {
      switch selectedFilterIndex {
      case 2:
        $0.schedule[selectedWeekDayIndex] && (isTrackerDone(with: $0.id, on: selectedDate) == true)
      case 3:
        $0.schedule[selectedWeekDayIndex] && (isTrackerDone(with: $0.id, on: selectedDate) == false)
      default:
        $0.schedule[selectedWeekDayIndex]
      }
    }
  }

  func addToStoreNew(category: TrackerCategory) {
    try? trackerCategoryStore.addNew(category: category)
  }

  func addNewOrUpdate(tracker: Tracker, toCategory categoryId: UUID) {
    if let category = trackerCategoryStore.fetchCategoryBy(id: categoryId) {
      try? trackerStore.addNewOrUpdate(tracker: tracker, to: category)
    }
  }

  func setPinFor(tracker: Tracker) {
    let newPinValue = !tracker.isPinned
    let newTracker = Tracker(
      id: tracker.id,
      title: tracker.title,
      emoji: tracker.emoji,
      color: tracker.color,
      isPinned: newPinValue,
      schedule: tracker.schedule
    )
    try? trackerStore.setPinFor(tracker: newTracker)
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

  func setWeekDayForTracker(with schedule: [Bool]) {
    guard schedule[selectedWeekDayIndex] == false else { return }
    var shiftDays = 0
    for day in (0...selectedWeekDayIndex).reversed() where schedule[day] {
      shiftDays = selectedWeekDayIndex - day
      break
    }
    if shiftDays == 0 {
      for day in (selectedWeekDayIndex..<Resources.Labels.shortWeekDays.count) where schedule[day] {
        shiftDays = Resources.Labels.shortWeekDays.count - day + 1
        break
      }
    }
    selectedDate -= TimeInterval(shiftDays * 24 * 60 * 60)
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
    guard let tracker = trackerStore.fetchTrackerBy(id: id) else {
      preconditionFailure("Cannot fount tracker with ID \(id)")
    }
    return tracker
  }
}
