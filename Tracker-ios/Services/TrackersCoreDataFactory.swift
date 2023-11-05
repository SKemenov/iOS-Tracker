//
//  TrackersCoreDataFactory.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 04.11.2023.
//

import Foundation

final class TrackersCoreDataFactory {
  // MARK: - Private properties
  private let trackerStore = TrackerStore()
  private let trackerCategoryStore = TrackerCategoryStore()
  private let trackerRecordStore = TrackerRecordStore()

  // MARK: - Public singleton

  static let shared = TrackersCoreDataFactory()

  // MARK: - Init

  private init() { }
}
