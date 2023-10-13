//
//  Resources.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 08.10.2023.
//

import UIKit

enum Resources {
  // MARK: - Localised UI elements
  enum Labels {
    static let newTracker = "Создание трекера"
    static let newEvent = "Новое нерегулярное событие"
    static let newHabit = "Новая привычка"
    static let habit = "Привычка"
    static let event = "Нерегулярное событие"
    static let statistic = "Статистика"
    static let trackers = "Трекеры"
    static let searchBar = "Поиск"
    static let searchBarCancel = "Отменить"
  }

  // MARK: - UI element's SF symbols
  enum SfSymbols {
    static let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium, scale: .large)
    static let addTracker = UIImage(systemName: "plus", withConfiguration: largeConfig)
    static let tracker = UIImage(systemName: "record.circle.fill")
    static let statistic = UIImage(systemName: "hare.fill")
  }

  // MARK: - UI element's images
  enum Images {
    static let dummySearch = UIImage(named: "DummySearch")
    static let dummyTrackers = UIImage(named: "DummyTrackers")
    static let dummyStatistic = UIImage(named: "DummyStatistic")
  }

  // MARK: - Fonts
  enum Fonts {
    static let titleUsual = UIFont.systemFont(ofSize: 16, weight: .medium)
    static let textNofification = UIFont.systemFont(ofSize: 12, weight: .medium)
    static let textField = UIFont.systemFont(ofSize: 17, weight: .regular)
    static let sectionHeader = UIFont.systemFont(ofSize: 19, weight: .bold)
  }
  // MARK: - Default date formatter
  static let dateFormat = "dd.MM.YY"
  static let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = Resources.dateFormat
    return dateFormatter
  }()
}
