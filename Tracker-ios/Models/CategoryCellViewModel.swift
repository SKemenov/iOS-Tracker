//
//  CategoryCellViewModel.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 19.11.2023.
//

import Foundation

struct CategoryCellViewModel: Identifiable {
  let id: UUID
  let name: String
  let isCompleted: Bool
}
