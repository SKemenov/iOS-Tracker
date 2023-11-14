//
//  UICollectionView+Extensions.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 14.11.2023.
//

import UIKit.UICollectionView

extension UICollectionView {
  func reloadItems(inSection section: Int) {
    reloadItems(at: (0..<numberOfItems(inSection: section)).map {
      IndexPath(item: $0, section: section)
    })
  }
}
