//
//  Array_Extensions.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 04.12.2023.
//

import Foundation

extension Array {
  func shift(withDistance distance: Int = 1) -> [Element] {
    let offsetIndex = distance >= 0 ?
    self.index(startIndex, offsetBy: distance, limitedBy: endIndex) :
    self.index(endIndex, offsetBy: distance, limitedBy: startIndex)

    guard let index = offsetIndex else { return self }
    return Array(self[index ..< endIndex] + self[startIndex ..< index])
  }
}
