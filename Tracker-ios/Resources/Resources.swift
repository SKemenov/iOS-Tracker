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
    static let cancel = "Отменить"
    static let create = "Создать"
    static let category = "Категория"
    static let newCategory = "Новая категория"
    static let schedule = "Расписание"
    static let textFieldPlaceholder = "Введите название трекера"
    static let textFieldRestriction = "Ограничение 38 символов"
    static let done = "Готово"
    static let emoji = "Emoji"
    static let color = "Цвет"
    static let filters = "Фильтры"
    static let emptyStatistic = "Анализировать пока нечего"
    static let emptyTracker = "Что будем отслеживать?"
    static let emptySearch = "Ничего не найдено"
    static let oneDay = "день"
    static let fewDays = "дня"
    static let manyDays = "дней"
    static let everyDays = "Каждый день"
    static let weekDays = "Будни"
    static let weekEnds = "Выходные"

    // swiftlint:disable:next nesting
    enum WeekDays: String, CaseIterable {
      case monday = "Понедельник"
      case tuesday = "Вторник"
      case wednesday = "Среда"
      case thursday = "Четверг"
      case friday = "Пятница"
      case saturday = "Суббота"
      case sunday = "Воскресенье"
    }
  }

  // MARK: - UI element's SF symbols
  enum SfSymbols {
    static let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium, scale: .large)
    static let addTracker = UIImage(systemName: "plus", withConfiguration: largeConfig)
    static let tracker = UIImage(systemName: "record.circle.fill")
    static let statistic = UIImage(systemName: "hare.fill")
    static let chevron = UIImage(systemName: "chevron.right")
    static let addCounter = UIImage(systemName: "plus")
    static let doneCounter = UIImage(systemName: "checkmark")
    static let pinTracker = UIImage(systemName: "pin")
  }

  // MARK: - UI element's images
  enum Images {
    static let emptySearch = UIImage(named: "DummySearch")
    static let emptyTrackers = UIImage(named: "DummyTrackers")
    static let emptyStatistic = UIImage(named: "DummyStatistic")
  }

  // MARK: - UI element's dimensions
  enum Dimensions {
    static let cornerRadius: CGFloat = 16
    static let mediumCornerRadius: CGFloat = 12
    static let smallCornerRadius: CGFloat = 8
    static let smallIcon: CGFloat = 24
    static let bigIcon: CGFloat = 80
    static let buttonHeight: CGFloat = 60
    static let fieldHeight: CGFloat = 75
    static let notificationHeight: CGFloat = 18
    static let titleHeight: CGFloat = 42
    static let trackerHeight: CGFloat = 148
    static let trackerContentHeight: CGFloat = 90
    static let trackerCounterHeight: CGFloat = 58
    static let sectionHeight: CGFloat = 46
    static let iPhoneSeWidth: CGFloat = 320
  }

  // MARK: - UI element's layouts
  enum Layouts {
    static let leadingElement: CGFloat = 16
    static let spacingElement: CGFloat = 9
    static let vSpacingElement: CGFloat = 24
    static let leadingButton: CGFloat = 20
    static let vSpacingButton: CGFloat = 16
    static let hSpacingButton: CGFloat = 8
    static let vSpacingTitle: CGFloat = 28
    static let vSpacingLargeTitle: CGFloat = 44
    static let leadingTracker: CGFloat = 12
    static let leadingSection: CGFloat = 28
    static let vSpacingSection: CGFloat = 16
    static let vSpacingTracker: CGFloat = 12
    static let trackersPerLine: CGFloat = 2
    static let indicatorInset: CGFloat = 4
  }

  // MARK: - Fonts
  enum Fonts {
    static let titleUsual = UIFont.systemFont(ofSize: 16, weight: .medium)
    static let titleLarge = UIFont.systemFont(ofSize: 34, weight: .bold)
    static let textNotification = UIFont.systemFont(ofSize: 12, weight: .medium)
    static let textField = UIFont.systemFont(ofSize: 17, weight: .regular)
    static let sectionHeader = UIFont.systemFont(ofSize: 19, weight: .bold)
  }

  static let days = [
    "Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"
  ]
  static let colors: [UIColor] = [
    .ypSelection01, .ypSelection02, .ypSelection03, .ypSelection04, .ypSelection05, .ypSelection06,
    .ypSelection07, .ypSelection08, .ypSelection09, .ypSelection10, .ypSelection11, .ypSelection12,
    .ypSelection13, .ypSelection14, .ypSelection15, .ypSelection16, .ypSelection17, .ypSelection18
  ]
  static let emojis = [
    "🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝️", "😪"
  ]
  static let textFieldLimit = 38

  // MARK: - Default date formatter
  // static let shiftTimeZone = 60 * 60 * 3
  static let dateFormat = "dd.MM.YYYY"
  static let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = Resources.dateFormat
    return dateFormatter
  }()
}
