//
//  TrackerStoreUpdate.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 14.11.2023.
//

import Foundation

// MARK: - Structures for FRC delegates

struct TrackerStoreUpdate {
  let insertedIndexes: [IndexPath]
  let deletedIndexes: [IndexPath]
  let updatedIndexes: [IndexPath]
}

struct TrackerCategoryStoreUpdate {
  let insertedSectionIndexes: IndexSet
  let deletedSectionIndexes: IndexSet
  let updatedSectionIndexes: IndexSet
}
