//
//  TrackerStore.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 04.11.2023.
//

import UIKit.UIApplication
import CoreData

struct TrackerStoreUpdate {
  let insertedIndexes: [IndexPath]
  let deletedIndexes: [IndexPath]
  let updatedIndexes: [IndexPath]
}

// MARK: - Protocol

protocol TrackerStoreDelegate: AnyObject {
  func store(didUpdate update: TrackerStoreUpdate)
}

final class TrackerStore: NSObject {
  // MARK: - Private properties
  private let context: NSManagedObjectContext
  private var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>

  private var insertedIndexes: [IndexPath]?
  private var deletedIndexes: [IndexPath]?
  private var updatedIndexes: [IndexPath]?

  // MARK: - Public properties

  weak var delegate: TrackerStoreDelegate?

  // MARK: - Inits

  convenience override init() {
    guard let application = UIApplication.shared.delegate as? AppDelegate else {
      fatalError("Cannot init AppDelegate")
    }
    let context = application.persistentContainer.viewContext
    self.init(context: context)
  }

  init(context: NSManagedObjectContext) {
    self.context = context

    let fetchRequest = TrackerCoreData.fetchRequest()
    fetchRequest.sortDescriptors = [
      NSSortDescriptor(keyPath: \TrackerCoreData.title, ascending: true)
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
  }

  deinit {
    print(#fileID, #function)
  }

  func addNew(tracker: Tracker, to category: TrackerCategoryCoreData) throws {
    print(#fileID, #function)
    let trackerInCoreData = TrackerCoreData(context: context)
    trackerInCoreData.title = tracker.title
    trackerInCoreData.id = tracker.id
    trackerInCoreData.color = Int32(tracker.color)
    trackerInCoreData.emoji = Int32(tracker.emoji)
    trackerInCoreData.monday = tracker.schedule[0]
    trackerInCoreData.tuesday = tracker.schedule[1]
    trackerInCoreData.wednesday = tracker.schedule[2]
    trackerInCoreData.thursday = tracker.schedule[3]
    trackerInCoreData.friday = tracker.schedule[4]
    trackerInCoreData.saturday = tracker.schedule[5]
    trackerInCoreData.sunday = tracker.schedule[6]
    trackerInCoreData.category = category
    print("CategoryCoreData: Trying to add tracker with ID [\(tracker.id)] and title - \(tracker.title)")
    saveContext()
  }

  func countTrackers() -> Int {
    let request = TrackerCoreData.fetchRequest()
    request.resultType = .countResultType
    guard
      let objects = try? context.execute(request) as? NSAsynchronousFetchResult<NSFetchRequestResult>,
      let counter = objects.finalResult?[0] as? Int32
    else {
      return .zero
    }
    return Int(counter)
  }

  func fetchTracker(byID id: UUID) -> TrackerCoreData? {
    let request = TrackerCoreData.fetchRequest()
    request.returnsObjectsAsFaults = false
    guard let trackers = try? context.fetch(request) else { return nil }
    for tracker in trackers where tracker.id == id {
      return tracker
    }
    print("Tracker not found")
    return nil
  }

  func isTrackerCoreDataEmpty() -> Bool { // TODO: - delete in Sprint 16
    print(#fileID, #function)
    let checkRequest = TrackerCoreData.fetchRequest()
    guard
      let result = try? context.fetch(checkRequest),
      result.isEmpty
    else {
      print("isTrackerCoreDataEmpty = false")
      return false
    }
    print("isTrackerCoreDataEmpty = true")
    return true
  }

  func showTrackersFromCoreData() {  // TODO: - delete in Sprint 16
    print(#fileID, #function)
    let request = TrackerCoreData.fetchRequest()
    request.returnsObjectsAsFaults = false
    let trackers = try? context.fetch(request)
    trackers?.enumerated().forEach { index, tracker in
      guard
        let title = tracker.title,
        let id = tracker.id,
        let category = tracker.category
      else { return }
      let schedule = [
        tracker.monday, tracker.tuesday, tracker.wednesday, tracker.thursday, tracker.friday,
        tracker.saturday, tracker.sunday
      ]
      print("tracker[\(index)] detailed information")
      print("tracker's title: \(title)")
      print("tracker's ID: \(id)")
      print("tracker's color: \(tracker.color)")
      print("tracker's emoji: \(tracker.emoji)")
      print("tracker's schedule: \(schedule)")
      print("tracker's category: \(category)")
    }
  }

  func deleteTrackersFromCoreData() { // TODO: - delete in Sprint 16
    print(#fileID, #function)
    guard !isTrackerCoreDataEmpty() else { return }
    let request = TrackerCoreData.fetchRequest()
    let trackers = try? context.fetch(request)
    trackers?.forEach { tracker in
      print("Deleting tracker: \(String(describing: tracker.title))")
      context.delete(tracker)
    }
    saveContext()
  }
}

// MARK: - NSFetchedResultsControllerDelegate

extension TrackerStore: NSFetchedResultsControllerDelegate {
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    insertedIndexes = nil
    deletedIndexes = nil
    updatedIndexes = nil
  }

  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    switch type {
    case .insert:
      if let newIndexPath {
        insertedIndexes?.append(newIndexPath)
      }
    case .delete:
      if let indexPath {
        deletedIndexes?.append(indexPath)
      }
    case .move:
      if let indexPath, let newIndexPath {
        insertedIndexes?.append(newIndexPath)
        deletedIndexes?.append(indexPath)
      }
    case .update:
      if let indexPath {
        updatedIndexes?.append(indexPath)
      }
    @unknown default:
      break
    }
  }

  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    guard
      let insertedFinalIndexes = insertedIndexes,
      let deletedFinalIndexes = deletedIndexes,
      let updatedFinalIndexes = updatedIndexes
    else { return }
    delegate?.store(
      didUpdate: TrackerStoreUpdate(
        insertedIndexes: insertedFinalIndexes,
        deletedIndexes: deletedFinalIndexes,
        updatedIndexes: updatedFinalIndexes
      )
    )
    insertedIndexes = nil
    deletedIndexes = nil
    updatedIndexes = nil
  }
}

// MARK: - Core Data Saving support

private extension TrackerStore {
  func saveContext() {
    if context.hasChanges {
      do {
        try context.save()
        print("TS - content has changed and successfully saved")
      } catch {
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
}
