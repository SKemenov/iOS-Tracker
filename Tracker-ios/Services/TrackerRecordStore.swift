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
    let calendar = Calendar.current
    let request = TrackerRecordCoreData.fetchRequest()
    guard let records = try? context.fetch(request) else { return }
    for record in records where record.tracker == tracker {
      guard let recordDate = record.date else { return }
      if calendar.compare(recordDate, to: date, toGranularity: .day) == .orderedSame {
        context.delete(record)
      }
    }
    saveContext()
  }

  func countRecords(for tracker: TrackerCoreData) -> Int {
    fetchRecords(for: tracker).count
  }

  func fetchRecords(for tracker: TrackerCoreData) -> [Date] {
    var dates: [Date] = []
    let request = TrackerRecordCoreData.fetchRequest()
    request.returnsObjectsAsFaults = false
    guard let records = try? context.fetch(request) else { return dates }
    for record in records where record.tracker == tracker {
      guard let date = record.date else { break }
      dates.append(date)
    }
    return dates
  }
}

// MARK: - Private methods

private extension TrackerRecordStore {
  func isTrackerRecordCoreDataEmpty() -> Bool { // TODO: - delete in Sprint 16
    let checkRequest = TrackerRecordCoreData.fetchRequest()
    guard
      let result = try? context.fetch(checkRequest),
      result.isEmpty
    else {
      return false
    }
    return true
  }

  func showTrackerRecordsFromCoreData() { // TODO: - delete in Sprint 16
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
