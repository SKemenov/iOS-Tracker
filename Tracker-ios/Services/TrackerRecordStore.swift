//
//  TrackerRecordStore.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 04.11.2023.
//

import UIKit
import CoreData

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

  func addNew(record: TrackerRecord) throws { }
}


// MARK: - Core Data Saving support

private extension TrackerRecordStore {

  func saveContext() {
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
}
