//
//  AnalyticsService.swift
//  Tracker-ios
//  Refactored `AnalyticsService` class
//  Created by Sergey Kemenov on 30.11.2023.
//

import Foundation
import YandexMobileMetrica

// MARK: - Class

final class AnalyticsService {
  // MARK: - Public methods

  static func activate() {
    guard let configuration = YMMYandexMetricaConfiguration(apiKey: "269441e0-ab7b-4c03-9f29-ec3e375b961a") else {
      return
    }
    YMMYandexMetrica.activate(with: configuration)
  }

  func report(event: String, params: [AnyHashable: Any]) {
    YMMYandexMetrica.reportEvent(event, parameters: params) { error in
      print("REPORT ERROR: %@", error.localizedDescription)
    }
  }
}
