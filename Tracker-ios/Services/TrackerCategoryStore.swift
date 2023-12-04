//
//  TrackerCategoryStore.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 04.11.2023.
//

import UIKit.UIApplication
import CoreData

enum TrackerCategoryStoreError: Error {
  case decodingErrorInvalidId
  case decodingErrorInvalidName
  case decodingErrorInvalidTrackers
  case decodingErrorInvalidEmoji
  case decodingErrorInvalidColor
  case decodingErrorInvalidSchedule
  case decodingError
}

// MARK: - Protocol

protocol TrackerCategoryStoreDelegate: AnyObject {
  func trackerCategoryStore(didUpdate store: TrackerCategoryStore)
}

// MARK: - Class

final class TrackerCategoryStore: NSObject {
  // MARK: - Private properties
  private let context: NSManagedObjectContext
  private var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData>

  private var insertedSectionIndexes: IndexSet?
  private var deletedSectionIndexes: IndexSet?
  private var updatedSectionIndexes: IndexSet?

  // MARK: - Public singleton

  static let shared = TrackerCategoryStore()

  // MARK: - Public properties

  weak var delegate: TrackerCategoryStoreDelegate?

  var allCategories: [TrackerCategory] {
    guard
      let objects = self.fetchedResultsController.fetchedObjects,
      let categories = try? objects.map({ try self.trackerCategory(from: $0) })
    else { return [] }
    return categories
  }

  var pinnedCategoryId: UUID? {
    UUID(uuidString: UserDefaults.standard.pinnedCategoryId)
  }

  // MARK: - Inits

  convenience override init() {
    guard let application = UIApplication.shared.delegate as? AppDelegate else {
      fatalError("Cannot init AppDelegate")
    }
    let context = application.persistentContainer.viewContext
    self.init(context: context)
  }

  private init(context: NSManagedObjectContext) {
    self.context = context

    let fetchRequest = TrackerCategoryCoreData.fetchRequest()
    fetchRequest.sortDescriptors = [
      NSSortDescriptor(keyPath: \TrackerCategoryCoreData.name, ascending: true)
    ]
    let controller = NSFetchedResultsController(
      fetchRequest: fetchRequest,
      managedObjectContext: context,
      sectionNameKeyPath: nil,
      cacheName: nil
    )
    self.fetchedResultsController = controller
    super.init()
    controller.delegate = self
    try? controller.performFetch()
    setupPinnedCategory()
  }
}

// MARK: - Public methods

extension TrackerCategoryStore {
  func deleteCategoriesFromCoreData() { // service method
    print("TCS Run deleteCategoriesFromCoreData()")
    guard !isCategoryCoreDataEmpty() else { return }
    self.fetchedResultsController.fetchedObjects?.forEach { context.delete($0) }
    saveContext()
  }

  func addNew(category: TrackerCategory) throws {
    let categoryInCoreData = TrackerCategoryCoreData(context: context)
    categoryInCoreData.name = category.name
    categoryInCoreData.id = category.id
    saveContext()
  }

  func fetchCategoryBy(id: UUID) -> TrackerCategoryCoreData? {
    self.fetchedResultsController.fetchedObjects?.first { $0.id == id }
  }

  func renameCategoryBy(id: UUID, newName: String) {
    guard let category = fetchCategoryBy(id: id) else { return }
    category.name = newName
    saveContext()
  }

  func trackerCategory(from trackerCategoryCoreData: TrackerCategoryCoreData) throws -> TrackerCategory {
    guard let id = trackerCategoryCoreData.id else {
      throw TrackerCategoryStoreError.decodingErrorInvalidId
    }
    guard let name = trackerCategoryCoreData.name else {
      throw TrackerCategoryStoreError.decodingErrorInvalidName
    }
    guard let trackersFromCoreData = trackerCategoryCoreData.trackers else {
      throw TrackerCategoryStoreError.decodingErrorInvalidTrackers
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
    return TrackerCategory(id: id, name: name, items: trackers.sorted { $0.title < $1.title })
  }
}

// MARK: - NSFetchedResultsControllerDelegate

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    delegate?.trackerCategoryStore(didUpdate: self)
  }
}

// MARK: - Private methods

private extension TrackerCategoryStore {
  func tracker(from trackerFromCoreData: TrackerCoreData) throws -> Tracker {
    guard let id = trackerFromCoreData.id else {
      throw TrackerCategoryStoreError.decodingErrorInvalidId
    }
    guard let title = trackerFromCoreData.title else {
      throw TrackerCategoryStoreError.decodingErrorInvalidName
    }
    return Tracker(
      id: id,
      title: title,
      emoji: Int(trackerFromCoreData.emoji),
      color: Int(trackerFromCoreData.color),
      isPinned: trackerFromCoreData.isPinned,
      schedule: [
        trackerFromCoreData.monday,
        trackerFromCoreData.tuesday,
        trackerFromCoreData.wednesday,
        trackerFromCoreData.thursday,
        trackerFromCoreData.friday,
        trackerFromCoreData.saturday,
        trackerFromCoreData.sunday
      ]
    )
  }

  func setupPinnedCategory() {
    if isCategoryCoreDataEmpty() {
      let pinnedCategoryId = UUID()
      try? addNew(category: TrackerCategory(id: pinnedCategoryId, name: Resources.pinCategoryName, items: []))
      UserDefaults.standard.pinnedCategoryId = pinnedCategoryId.uuidString
    }
    if
      let pinnedCategoryId,
      let pinnedCategory = fetchCategoryBy(id: pinnedCategoryId),
      pinnedCategory.name != Resources.pinCategoryName {
        renameCategoryBy(id: pinnedCategoryId, newName: Resources.pinCategoryName)
    }
  }

  func isCategoryCoreDataEmpty() -> Bool {
    guard let categories = self.fetchedResultsController.fetchedObjects else { return true }
    return categories.isEmpty
  }

  func isCategoryCoreDataHasTrackers() -> Bool {
    var hasTrackers = false
    let request = TrackerCategoryCoreData.fetchRequest()
    request.returnsObjectsAsFaults = false
    if let categories = try? context.fetch(request) {
      hasTrackers = categories.compactMap { Int($0.trackers?.count ?? 0) }.first { $0 > 0 } != nil
    }
    return hasTrackers
  }
}

// MARK: - Mock methods

private extension TrackerCategoryStore {
  func showCategoriesFromCoreData() { // service method
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
