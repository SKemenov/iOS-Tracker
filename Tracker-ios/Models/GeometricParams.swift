//
//  GeometricParams.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 10.10.2023.
//

import Foundation

struct GeometricParams {
  let cellCount: Int
  let leftInset: CGFloat
  let rightInset: CGFloat
  let cellSpacing: CGFloat
  let paddingWidth: CGFloat

  init(cellCount: Int, leftInset: CGFloat, rightInset: CGFloat, cellSpacing: CGFloat, paddingWidth: CGFloat) {
    self.cellCount = cellCount
    self.leftInset = leftInset
    self.rightInset = rightInset
    self.cellSpacing = cellSpacing
    self.paddingWidth = leftInset + rightInset + CGFloat(cellCount - 1) * cellSpacing
  }
}
