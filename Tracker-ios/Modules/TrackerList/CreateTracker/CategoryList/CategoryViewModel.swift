//
//  CategoryViewModel.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 21.11.2023.
//

import Foundation

// MARK: - CategoryViewModel

final class CategoryViewModel {
  var onChange: (() -> Void)?

  private (set) var categories: [TrackerCategory] = [] {
    didSet {
      onChange?()
    }
  }

  private let trackerCategoryStore = TrackerCategoryStore.shared

  init() {
    trackerCategoryStore.delegate = self
    fetchCategoriesFromCoreData()
  }

  func fetchCategoriesFromCoreData() {
    categories = trackerCategoryStore.allCategories.filter { $0.name != Resources.pinCategoryName }
  }

  func addCategory(_ category: TrackerCategory) {
    try? trackerCategoryStore.addNew(category: category)
  }

  func deleteCategoryBy(id: UUID) {
    trackerCategoryStore.deleteCategoryBy(id: id)
  }

  func rename(id: UUID, newName: String) {
    trackerCategoryStore.renameCategoryBy(id: id, newName: newName)
  }
}

// MARK: - TrackerCategoryStoreDelegate

extension CategoryViewModel: TrackerCategoryStoreDelegate {
  func trackerCategoryStore(didUpdate store: TrackerCategoryStore) {
    fetchCategoriesFromCoreData()
  }
}
