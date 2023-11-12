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
    if isTrackerRecordCoreDataEmpty() { // TODO: - delete before PR
      print("TRS - no TrackerRecords in CoreData")
    } else {
      showTrackerRecordsFromCoreData()
    }
  }

  func addNew(recordDate date: Date, toTracker tracker: TrackerCoreData) throws {
    print("TRS Run addNew(recordDate:toTracker:)")
    print(date)
    print(tracker)
    let trackerRecordInCoreData = TrackerRecordCoreData(context: context)
    print(trackerRecordInCoreData)
    trackerRecordInCoreData.date = date
    trackerRecordInCoreData.tracker = tracker
    print("trackerRecordInCoreData: Trying to add date [\(date)] to tracker - \(String(describing: tracker.title))")
    print(trackerRecordInCoreData)
    saveContext()
  }

  func removeRecord(on date: Date) {
    print("TRS Run remove(trackerRecord:)")
    let calendar = Calendar.current
    let request = TrackerRecordCoreData.fetchRequest()
    guard let records = try? context.fetch(request) else { return }
    records.forEach { record in
      guard let recordDate = record.date else { return }
      if calendar.compare(recordDate, to: date, toGranularity: .day) == .orderedSame {
        print("Deleting record: \(String(describing: record))")
        context.delete(record)
      }
    }
    saveContext()
  }

  func countRecords(for tracker: TrackerCoreData) -> Int {
    print("TRS Run countRecords(forTracker:)")
    return fetchRecords(for: tracker).count
    //    let request = TrackerRecordCoreData.fetchRequest()
    //    request.resultType = .countResultType
    //    request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.tracker), tracker)
    //    guard
    //      let objects = try? context.execute(request) as? NSAsynchronousFetchResult<NSFetchRequestResult>,
    //      let counter = objects.finalResult?[0] as? Int32
    //    else {
    //      return .zero
    //    }
    //    return Int(counter)
  }

  func fetchRecords(for tracker: TrackerCoreData) -> [Date] {
    print("TRS Run fetchRecords(forTracker:)")
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

  private func isTrackerRecordCoreDataEmpty() -> Bool { // TODO: - delete before PR
    print("TRS Run isTrackerRecordCoreDataEmpty()")
    let checkRequest = TrackerRecordCoreData.fetchRequest()
    guard
      let result = try? context.fetch(checkRequest),
      result.isEmpty
    else {
      print("isTrackerRecordCoreDataEmpty = false")
      return false
    }
    print("isTrackerRecordCoreDataEmpty = true")
    return true
  }

  private func showTrackerRecordsFromCoreData() { // TODO: - delete before PR
    print("TRS Run showTrackerRecordsFromCoreData()")
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
