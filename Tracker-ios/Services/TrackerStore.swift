//
//  TrackerStore.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 04.11.2023.
//

import UIKit
import CoreData

final class TrackerStore {
  // MARK: - Private properties
  private let context: NSManagedObjectContext
  // private let categoryStore = TrackerCategoryStore.shared

  // MARK: - Inits

  convenience init() {
    guard let application = UIApplication.shared.delegate as? AppDelegate else {
      fatalError("Cannot init AppDelegate")
    }
    let context = application.persistentContainer.viewContext
    self.init(context: context)
  }

  init(context: NSManagedObjectContext) {
    self.context = context
    print("TS init. Total Trackers in Store \(countTrackers())")
    if !isTrackerCoreDataEmpty() { // TODO: - delete before PR
      showTrackersFromCoreData()
      // deleteTrackersFromCoreData() // Uncomment to clear CoreData (Trackers the first, TrackerCategory the second one)
    }
  }

  deinit {
    print("TS deinit")
  }

  func addNew(tracker: Tracker, to category: TrackerCategoryCoreData) throws {
    print("TS Run addNew(tracker:)")
    print(tracker)
    print(category)
    let trackerInCoreData = TrackerCoreData(context: context)
    print(trackerInCoreData)
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
    print(trackerInCoreData)
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
    print("TS Run fetchTracker(byID:)")
    let request = TrackerCoreData.fetchRequest()
    request.returnsObjectsAsFaults = false
    guard let trackers = try? context.fetch(request) else { return nil }
    for tracker in trackers where tracker.id == id {
      print("For id[\(id)] found this tracker \(tracker)")
      return tracker
    }
    print("Tracker not found")
    return nil
  }

  func isTrackerCoreDataEmpty() -> Bool { // TODO: - delete before PR
    print("TS Run isTrackerCoreDataEmpty()")
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

  func showTrackersFromCoreData() {  // TODO: - delete before PR
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

  func deleteTrackersFromCoreData() { // TODO: - delete before PR
    print("TS Run deleteTrackersFromCoreData()")
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
