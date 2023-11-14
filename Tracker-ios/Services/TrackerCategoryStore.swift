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

struct TrackerCategoryStoreUpdate {
  let insertedSectionIndexes: IndexSet
  let deletedSectionIndexes: IndexSet
  let updatedSectionIndexes: IndexSet
}


// MARK: - Protocol

protocol TrackerCategoryStoreDelegate: AnyObject {
  func store(didUpdate update: TrackerCategoryStoreUpdate)
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

    if isCategoryCoreDataEmpty() {
      setupCategoryCoreDataWithMockData()
    }
    //    else { // delete Trackers first! // TODO: - delete before PR
    //      deleteCategoriesFromCoreData()
    //    }

    print("TCS total categories in Store \(countCategories())")
    print("TCS visibleCategories from FRC \(visibleCategories)")
    //    if isCategoryCoreDataHasTrackers() {
    //      showCategoriesFromCoreData()
    //    }
  }

    var visibleCategories: [TrackerCategory] {
      guard
        let objects = self.fetchedResultsController.fetchedObjects,
        let categories = try? objects.map({ try self.trackerCategory(from: $0) })
      else { return [] }
      return categories.filter { !$0.items.isEmpty }
      //      var categories: [TrackerCategory] = []
      //      try? objects.forEach { category in
      //        guard let category = try? self.trackerCategory(from: category) else {
      //          throw TrackerCategoryStoreError.decodingError
      //        }
      //        if !category.items.isEmpty {
      //          categories.append(category)
      //        }
      //      }
      // return categories
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

extension TrackerCategoryStore {
  var numberOfSections: Int {
    visibleCategories.count
    //    fetchedResultsController.sections?.count ?? 0
  }

  func numberOfItemsInSection(_ section: Int) -> Int {
    print(#fileID, #function)
    return visibleCategories[section].items.count
    //    return fetchedResultsController.sections?[section].objects?.count ?? 0
    //    return fetchedResultsController.sections?[section].numberOfObjects ?? 0
  }

  //  func object(at indexPath: IndexPath) -> Tracker? {
  //    fetchedResultsController.object(at: indexPath)
  //  }
  //
  //  func addRecord(_ record: NotepadRecord) throws {
  //    try? dataStore.add(record)
  //  }
  //
  //  func deleteRecord(at indexPath: IndexPath) throws {
  //    let record = fetchedResultsController.object(at: indexPath)
  //    try? dataStore.delete(record)
  //  }
}

// MARK: - NSFetchedResultsControllerDelegate

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    insertedSectionIndexes = IndexSet()
    deletedSectionIndexes = IndexSet()
    updatedSectionIndexes = IndexSet()
    // movedIndexes = Set<TrackerCategoryStoreUpdate.Move>()
//    blockOperations.removeAll(keepingCapacity: false)
  }

  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    switch type {
    case .insert:
      insertedSectionIndexes?.insert(sectionIndex)
    case .delete:
      deletedSectionIndexes?.insert(sectionIndex)
    case .update:
      updatedSectionIndexes?.insert(sectionIndex)
    default:
      break
    }
  }

  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    guard
      let insertedFinalIndexes = insertedSectionIndexes,
      let deletedFinalIndexes = deletedSectionIndexes,
      let updatedFinalIndexes = updatedSectionIndexes
    else { return }
    delegate?.store(
      didUpdate: TrackerCategoryStoreUpdate(
        insertedSectionIndexes: insertedFinalIndexes,
        deletedSectionIndexes: deletedFinalIndexes,
        updatedSectionIndexes: updatedFinalIndexes // ,
        // movedIndexes: movedFinalIndexes
      )
    )
    insertedSectionIndexes = nil
    deletedSectionIndexes = nil
    updatedSectionIndexes = nil
    // movedIndexes = nil
  }

//  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//    switch type {
//    case .insert:
//      if let indexPath = newIndexPath {
//      insertedSectionIndexes?.insert(indexPath.item)
//      }
//    case .delete:
//      guard let indexPath else { preconditionFailure("Cannot get indexPath") }
//      deletedSectionIndexes?.insert(indexPath.item)
//    case .move:
//      guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else {preconditionFailure("Cannot get index")}
//      movedIndexes?.insert(.init(oldIndex: oldIndexPath.item, newIndex: newIndexPath.item))
//    case .update:
//      guard let indexPath else { preconditionFailure("Cannot get indexPath") }
//      updatedSectionIndexes?.insert(indexPath.item)
//    @unknown default:
//      return
//    }
//  }
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
//  func fetchVisibleCategories() throws -> [TrackerCategory] {
//    return visibleCategories
//    //    let request = TrackerCategoryCoreData.fetchRequest()
//    //    request.returnsObjectsAsFaults = false
//    //    request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
//    //    let categoriesFromCoreData = try context.fetch(request)
//    //    var categories: [TrackerCategory] = []
//    //    try categoriesFromCoreData.forEach { category in
//    //      guard let category = try delegate?.trackerCategory(from: category) else {
//    //        throw TrackerCategoryStoreError.decodingError
//    //      }
//    //      if !category.items.isEmpty {
//    //        categories.append(category)
//    //      }
//    //    }
//    //    return categories
//  }

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
    // let trackers: [Tracker] = try trackersFromCoreData.map { try self.tracker(from: $0 as! TrackerCoreData) }
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
}
