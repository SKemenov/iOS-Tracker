//
//  TrackerCategoryStore.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 04.11.2023.
//

import UIKit.UIApplication
import CoreData

enum TrackerCategoryStoreError: Error {
  case decodingError
}

// MARK: - Protocol
protocol TrackerCategoryStoreDelegate: AnyObject {
  func trackerCategory(from trackerCategoryCoreData: TrackerCategoryCoreData) throws -> TrackerCategory
}

// MARK: - Class

final class TrackerCategoryStore {
  // MARK: - Private properties
  private let context: NSManagedObjectContext

  // MARK: - Public singleton

  static let shared = TrackerCategoryStore()

  // MARK: - Public properties

  weak var delegate: TrackerCategoryStoreDelegate?

  // MARK: - Inits

  convenience init() {
    guard let application = UIApplication.shared.delegate as? AppDelegate else {
      fatalError("Cannot init AppDelegate")
    }
    let context = application.persistentContainer.viewContext
    self.init(context: context)
  }

  private init(context: NSManagedObjectContext) {
    self.context = context
    if isCategoryCoreDataEmpty() {
      setupCategoryCoreDataWithMockData()
    }
    //    else { // delete Trackers first! // TODO: - delete before PR
    //      deleteCategoriesFromCoreData()
    //    }

    print("TCS total categories in Store \(countCategories())")
    if isCategoryCoreDataHasTrackers() {
      showCategoriesFromCoreData()
    }
  }

  func addNew(category: TrackerCategory) throws {
    print("TCS Run addNew(category:)")
    let categoryInCoreData = TrackerCategoryCoreData(context: context)
    categoryInCoreData.name = category.name
    categoryInCoreData.id = category.id
    print("CategoryCoreData: Trying to add category with ID [\(category.id)] and name - \(category.name)")
    saveContext()
  }
}

// MARK: - Mock methods

extension TrackerCategoryStore {
  func setupCategoryCoreDataWithMockData() { // TODO: - delete in Sprint 16
    print("TCS Run setupCategoryCoreDataWithMockData()")
    Resources.categories.forEach { raw in
      try? addNew(category: TrackerCategory(
        id: UUID(),
        name: raw,
        items: []
      ))
      print("CategoryCoreData: Trying to add category's element - \(raw)")
    }
  }

  func deleteCategoriesFromCoreData() { // TODO: - delete before PR
    print("TCS Run deleteCategoriesFromCoreData()")
    guard !isCategoryCoreDataEmpty() else { return }
    let request = TrackerCategoryCoreData.fetchRequest()
    let categories = try? context.fetch(request)
    categories?.forEach { category in
      print("Deleting category: \(String(describing: category.name))")
      context.delete(category)
    }
    saveContext()
  }

  func isCategoryCoreDataEmpty() -> Bool {
    print("TCS Run isCategoryCoreDataEmpty()")
    let checkRequest = TrackerCategoryCoreData.fetchRequest()
    guard
      let result = try? context.fetch(checkRequest),
      result.isEmpty
    else {
      print("isCategoryCoreDataEmpty = false")
      return false
    }
    print("isCategoryCoreDataEmpty = true")
    return true
  }

  func isCategoryCoreDataHasTrackers() -> Bool {
    print("TCS Run isCategoryCoreDataHasTrackers()")
    var hasTrackers = false
    let request = TrackerCategoryCoreData.fetchRequest()
    request.returnsObjectsAsFaults = false
    let categories = try? context.fetch(request)
    categories?.forEach { category in
      guard let trackers = category.trackers else { return }
      // swiftlint:disable:next empty_count
      if trackers.count != 0 {
        hasTrackers = true
      }
    }
    print("isCategoryCoreDataHasTrackers = \(hasTrackers)")
    return hasTrackers
  }

  func countCategories() -> Int {
    print("TCS Run countCategories()")
    let request = TrackerCategoryCoreData.fetchRequest()
    request.resultType = .countResultType
    guard
      let objects = try? context.execute(request) as? NSAsynchronousFetchResult<NSFetchRequestResult>,
      let counter = objects.finalResult?[0] as? Int32
    else {
      return .zero
    }
    return Int(counter)
  }
  func fetchCategoryName(by thisIndex: Int) -> String {
    print("TCS Run fetchCategoryName(by:)")
    let request = TrackerCategoryCoreData.fetchRequest()
    request.returnsObjectsAsFaults = false
    var categoryName: String = ""
    guard let categories = try? context.fetch(request) else { return categoryName }
    for (index, category) in categories.enumerated() where index == thisIndex {
      categoryName = category.name ?? ""
    }
    print("Category's name: \(categoryName)")
    return categoryName
  }

  func fetchCategory(by thisIndex: Int) -> TrackerCategoryCoreData? {
    print("TCS Run fetchCategory(by:)")
    let request = TrackerCategoryCoreData.fetchRequest()
    request.returnsObjectsAsFaults = false
    guard let categories = try? context.fetch(request) else { return nil }
    for (index, category) in categories.enumerated() where index == thisIndex {
      print("New value for finalCategory \(category)")
      return category
    }
    print("Category not found")
    return nil
  }

  func showCategoriesFromCoreData() { // TODO: - delete before PR
    let request = TrackerCategoryCoreData.fetchRequest()
    request.returnsObjectsAsFaults = false
    let categories = try? context.fetch(request)
    categories?.enumerated().forEach { index, category in
      guard
        let name = category.name,
        let id = category.id,
        let trackers = category.trackers
      else {
        return
      }
      print("Category[\(index)] detailed information")
      print("Category name: \(name)")
      print("Category ID: \(id)")
      print("Category's trackers: \(trackers.count)")
    }
  }
}

// MARK: - Core Data Saving support

private extension TrackerCategoryStore {
  func saveContext() {
    if context.hasChanges {
      print("TCS - content has changed")
      do {
        try context.save()
        print("TCS - content has changed and successfully saved")
      } catch {
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
}

extension TrackerCategoryStore {
  func fetchVisibleCategories() throws -> [TrackerCategory] {
    let request = TrackerCategoryCoreData.fetchRequest()
    request.returnsObjectsAsFaults = false
    request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
    let categoriesFromCoreData = try context.fetch(request)
    var categories: [TrackerCategory] = []
    try categoriesFromCoreData.forEach { category in
      guard let category = try delegate?.trackerCategory(from: category) else {
        throw TrackerCategoryStoreError.decodingError
      }
      if !category.items.isEmpty {
        categories.append(category)
      }
    }
    return categories
    // return try categories.map { try self.trackerCategory(from: $0) }
  }

//  func trackerCategory(from trackerCategoryCoreData: TrackerCategoryCoreData) throws -> TrackerCategory {
//    guard let id = trackerCategoryCoreData.id else {
//      throw TrackerCategoryStoreError.decodingErrorInvalidId
//    }
//    guard let name = trackerCategoryCoreData.name else {
//      throw TrackerCategoryStoreError.decodingErrorInvalidName
//    }
//    guard let trackersFromCoreData = trackerCategoryCoreData.trackers else {
//      throw TrackerCategoryStoreError.decodingErrorInvalidTrackers
//    }
//    let trackers: [Tracker] = [] // try trackersFromCoreData.map { try self.tracker(from: $0) }
//    return TrackerCategory(id: id, name: name, items: trackers)
//  }
}
