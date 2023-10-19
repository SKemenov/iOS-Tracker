//
//  TrackersFactory.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 19.10.2023.
//

import Foundation

final class TrackersFactory {
  static let shared = TrackersFactory()

  var trackers: [Tracker] = []
  var categories: [TrackerCategory] = []

  private init() { }
}
