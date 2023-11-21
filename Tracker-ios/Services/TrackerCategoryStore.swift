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
    //    if isCategoryCoreDataEmpty() {
    //      setupCategoryCoreDataWithMockData()
    //    } else {
    //      showCategoriesFromCoreData()
    //    }
  }

  var allCategories: [TrackerCategory] {
    print(#fileID, #function)
    guard
      let objects = self.fetchedResultsController.fetchedObjects,
      let categories = try? objects.map({ try self.trackerCategory(from: $0) })
    else { return [] }
    return categories
  }
}

// MARK: - Public methods

extension TrackerCategoryStore {
  var numberOfSections: Int {
    allCategories.count
  }

  func numberOfItemsInSection(_ section: Int) -> Int {
    allCategories[section].items.count
  }

  func deleteCategoriesFromCoreData() { // TODO: - delete in Sprint 16
    print("TCS Run deleteCategoriesFromCoreData()")
    guard !isCategoryCoreDataEmpty() else { return }
    let request = TrackerCategoryCoreData.fetchRequest()
    let categories = try? context.fetch(request)
    categories?.forEach { context.delete($0) }
    saveContext()
  }

  func countCategories() -> Int {
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
    let request = TrackerCategoryCoreData.fetchRequest()
    request.returnsObjectsAsFaults = false
    var categoryName: String = ""
    guard let categories = try? context.fetch(request) else { return categoryName }
    for (index, category) in categories.enumerated() where index == thisIndex {
      categoryName = category.name ?? ""
    }
    return categoryName
  }

  func addNew(category: TrackerCategory) throws {
    let categoryInCoreData = TrackerCategoryCoreData(context: context)
    categoryInCoreData.name = category.name
    categoryInCoreData.id = category.id
    saveContext()
  }

  func fetchCategory(by thisId: UUID) -> TrackerCategoryCoreData? {
    let request = TrackerCategoryCoreData.fetchRequest()
    request.returnsObjectsAsFaults = false
    guard let categories = try? context.fetch(request) else { return nil }
    for category in categories where category.id == thisId {
      return category
    }
    return nil
  }
}

// MARK: - NSFetchedResultsControllerDelegate

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
  //  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
  //    switch type {
  //    case .insert:
  //      insertedSectionIndexes?.insert(sectionIndex)
  //    case .delete:
  //      deletedSectionIndexes?.insert(sectionIndex)
  //    case .update:
  //      updatedSectionIndexes?.insert(sectionIndex)
  //    default:
  //      break
  //    }
  //  }

  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    print(#fileID, #function)
    delegate?.trackerCategoryStore(didUpdate: self)
  }
}

// MARK: - Private methods

private extension TrackerCategoryStore {
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

  func isCategoryCoreDataEmpty() -> Bool {
    let checkRequest = TrackerCategoryCoreData.fetchRequest()
    guard
      let result = try? context.fetch(checkRequest),
      result.isEmpty
    else {
      return false
    }
    return true
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
  //  func setupCategoryCoreDataWithMockData() { // TODO: - delete in Sprint 16
  //    print("TCS Run setupCategoryCoreDataWithMockData()")
  //    Resources.categories.forEach { try? addNew(category: TrackerCategory(id: UUID(), name: $0, items: [])) }
  //  }

  func showCategoriesFromCoreData() { // TODO: - delete after Sprint 16
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
