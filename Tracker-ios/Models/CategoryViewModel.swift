//
//  CategoryViewModel.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 21.11.2023.
//

import UIKit.UIApplication

// MARK: - CategoryViewModel

final class CategoryViewModel {
  var onChange: (() -> Void)? {
    didSet {
      print("updateView установлен")
    }
  }

  private (set) var categories: [TrackerCategory] = [] {
    didSet {
      print(#fileID, #function)
      onChange?()
    }
  }

  private let trackerCategoryStore = TrackerCategoryStore.shared
  // private let factory = TrackersCoreDataFactory.shared

  init() {
    trackerCategoryStore.delegate = self
    fetchCategoriesFromCoreData()
  }

  func fetchCategoriesFromCoreData() {
    print(#fileID, #function)
    categories = trackerCategoryStore.allCategories
    print(categories.count, categories.isEmpty)
  }

  func addCategory(_ category: TrackerCategory) {
    print(#fileID, #function)
    try? trackerCategoryStore.addNew(category: category)
  }
}

// MARK: - nameTrackerCategoryStoreDelegate

extension CategoryViewModel: TrackerCategoryStoreDelegate {
  func trackerCategoryStore(didUpdate store: TrackerCategoryStore) {
    print(#fileID, #function)
    fetchCategoriesFromCoreData()
  }
}
