//
//  TrackerTests.swift
//  TrackerTests
//  Refactored `TrackerTests`
//  Created by Sergey Kemenov on 29.11.2023.
//

import XCTest
import SnapshotTesting
@testable import Tracker_ios

final class TrackerTests: XCTestCase {

  func testViewController() {
    let vc = TabBarViewController()
    let isRewrite = false
    assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .dark)), record: isRewrite)
    assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .light)), record: isRewrite)
  }
}
