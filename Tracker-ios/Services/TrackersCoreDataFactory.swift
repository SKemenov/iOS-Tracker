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
    trackerCategoryStore.countCategories()
  }

  func fetchCategoryName(by thisIndex: Int) -> String {
    trackerCategoryStore.fetchCategoryName(by: thisIndex)
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
    //    guard let trackersFromCoreData = trackerCategoryCoreData.trackers else {
    //      throw TrackersCoreDataFactoryError.decodingErrorInvalidTrackers
    //    }
    let trackers: [Tracker] = [] // try trackersFromCoreData.map { try self.tracker(from: $0) }
    return TrackerCategory(id: id, name: name, items: trackers)
  }
}

extension TrackersCoreDataFactory {
  func tracker(from trackerCoreData: TrackerCoreData) throws -> Tracker {
    // var color: Int
    guard let id = trackerCoreData.id else {
      throw TrackersCoreDataFactoryError.decodingErrorInvalidId
    }
    guard let title = trackerCoreData.title else {
      throw TrackersCoreDataFactoryError.decodingErrorInvalidName
    }
    //    guard color = Int(trackerCoreData.color) else {
    //      throw TrackersCoreDataFactoryError.decodingErrorInvalidColor
    //    }
    //    guard let emoji = trackerCoreData.emoji else {
    //      throw TrackersCoreDataFactoryError.decodingErrorInvalidEmoji
    // }
    return Tracker(id: id, title: title, emoji: 0, color: 0, schedule: [])
  }
}
