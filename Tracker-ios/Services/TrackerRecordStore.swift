//
//  TrackerRecordStore.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 04.11.2023.
//

import UIKit.UIApplication
import CoreData

// MARK: - Class

final class TrackerRecordStore {
  // MARK: - Private properties
  private let context: NSManagedObjectContext

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
  }

  // MARK: - Public properties

  var totalRecords: Int {
    let request = TrackerRecordCoreData.fetchRequest()
    request.returnsObjectsAsFaults = false
    guard let records = try? context.fetch(request) else { return 0 }
    return records.count
  }
}

// MARK: - Public methods

extension TrackerRecordStore {
  func addNew(recordDate date: Date, toTracker tracker: TrackerCoreData) throws {
    let trackerRecordInCoreData = TrackerRecordCoreData(context: context)
    trackerRecordInCoreData.date = date
    trackerRecordInCoreData.tracker = tracker
    saveContext()
  }

  func removeRecord(on date: Date, toTracker tracker: TrackerCoreData) {
    let request = TrackerRecordCoreData.fetchRequest()
    guard let records = try? context.fetch(request) else { return }
    records.filter { $0.tracker == tracker }.forEach { if let day = $0.date, day.sameDay(date) { context.delete($0) } }
    saveContext()
  }

  func deleteAllRecordsFor(tracker: TrackerCoreData) {
    let request = TrackerRecordCoreData.fetchRequest()
    guard let records = try? context.fetch(request) else { return }
    records.filter { $0.tracker == tracker }.forEach { context.delete($0) }
    saveContext()
  }

  func countRecords(for tracker: TrackerCoreData) -> Int {
    fetchRecords(for: tracker).count
  }

  func fetchRecords(for tracker: TrackerCoreData) -> [Date] {
    let request = TrackerRecordCoreData.fetchRequest()
    request.returnsObjectsAsFaults = false
    guard let records = try? context.fetch(request) else { return [] }
    return records.filter { $0.tracker == tracker }.compactMap { $0.date }
  }

  func deleteTrackerRecordsFromCoreData() { // service method
    print(#fileID, #function)
    let request = TrackerRecordCoreData.fetchRequest()
    let records = try? context.fetch(request)
    records?.forEach { context.delete($0) }
    saveContext()
  }
}

// MARK: - Private methods

private extension TrackerRecordStore {
  func isTrackerRecordCoreDataEmpty() -> Bool { // service method
    let checkRequest = TrackerRecordCoreData.fetchRequest()
    guard
      let result = try? context.fetch(checkRequest),
      result.isEmpty
    else {
      return false
    }
    return true
  }

  func showTrackerRecordsFromCoreData() { // service method
    let request = TrackerRecordCoreData.fetchRequest()
    request.returnsObjectsAsFaults = false
    let records = try? context.fetch(request)
    records?.enumerated().forEach { index, record in
      guard
        let date = record.date,
        let trackerTitle = record.tracker?.title
      else { return }
      print("record[\(index)] detailed information")
      print("record's date: \(date)")
      print("record's trackerTitle: \(trackerTitle)")
    }
  }
}

// MARK: - Core Data Saving support

private extension TrackerRecordStore {
  func saveContext() {
    if context.hasChanges {
      do {
        try context.save()
        print("TRS - content has changed and successfully saved")
      } catch {
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
}
