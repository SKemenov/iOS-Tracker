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
    static let newTracker = NSLocalizedString("labels.newTracker", comment: "labels for newTracker")
    static let newEvent = NSLocalizedString("labels.newEvent", comment: "labels for newEvent")
    static let newHabit = NSLocalizedString("labels.newHabit", comment: "labels for newHabit")
    static let newCategory = NSLocalizedString("labels.newCategory", comment: "labels for newCategory")
    static let addCategory = NSLocalizedString("labels.addCategory", comment: "labels for addCategory")
    static let habit = NSLocalizedString("labels.habit", comment: "labels for habit")
    static let event = NSLocalizedString("labels.event", comment: "labels for event")
    static let category = NSLocalizedString("labels.category", comment: "labels for category")
    static let schedule = NSLocalizedString("labels.schedule", comment: "labels for schedule")
    static let statistic = NSLocalizedString("labels.statistic", comment: "labels for statistic")
    static let trackers = NSLocalizedString("labels.trackers", comment: "labels for trackers")
    static let searchBar = NSLocalizedString("labels.searchBar", comment: "labels for searchBar")
    static let cancel = NSLocalizedString("labels.cancel", comment: "labels for cancel")
    static let create = NSLocalizedString("labels.create", comment: "labels for create")
    static let done = NSLocalizedString("labels.done", comment: "labels for done")
    static let emoji = NSLocalizedString("labels.emoji", comment: "labels for emoji")
    static let color = NSLocalizedString("labels.color", comment: "labels for color")
    static let filters = NSLocalizedString("labels.filters", comment: "labels for filters")
    static let emptyStatistic = NSLocalizedString("labels.emptyStatistic", comment: "labels for emptyStatistic")
    static let emptyTracker = NSLocalizedString("labels.emptyTracker", comment: "labels for emptyTracker")
    static let emptySearch = NSLocalizedString("labels.emptySearch", comment: "labels for emptySearch")
    static let emptyCategory = NSLocalizedString("labels.emptyCategory", comment: "labels for emptyCategory")
    static let oneDay = NSLocalizedString("labels.oneDay", comment: "labels for oneDay")
    static let fewDays = NSLocalizedString("labels.fewDays", comment: "labels for fewDays")
    static let manyDays = NSLocalizedString("labels.manyDays", comment: "labels for manyDays")
    static let everyDays = NSLocalizedString("labels.everyDays", comment: "labels for everyDays")
    static let weekDays = NSLocalizedString("labels.weekDays", comment: "labels for weekDays")
    static let weekEnds = NSLocalizedString("labels.weekEnds", comment: "labels for weekEnds")
    static let onboardingPage1 = NSLocalizedString("labels.onboardingPage1", comment: "labels for onboardingPage1")
    static let onboardingPage2 = NSLocalizedString("labels.onboardingPage2", comment: "labels for onboardingPage2")
    static let onboardingButton = NSLocalizedString("labels.onboardingButton", comment: "labels for onboardingButton")
    static let textFieldPlaceholder = NSLocalizedString(
      "labels.textFieldPlaceholder",
      comment: "labels for textFieldPlaceholder"
    )
    static let categoryNamePlaceholder = NSLocalizedString(
      "labels.categoryNamePlaceholder",
      comment: "labels for categoryNamePlaceholder"
    )
    static let textFieldRestriction = NSLocalizedString(
      "labels.textFieldRestriction",
      comment: "labels for textFieldRestriction"
    )

    // swift lint:disable:next nesting // TODO: Remove before PR
    //    enum WeekDays: String, CaseIterable {
    //      case monday = "Понедельник"
    //      case tuesday = "Вторник"
    //      case wednesday = "Среда"
    //      case thursday = "Четверг"
    //      case friday = "Пятница"
    //      case saturday = "Суббота"
    //      case sunday = "Воскресенье"
    //    }
    static let filtersList = [
      NSLocalizedString("labels.filter0", comment: "labels for filter - All Trackers"),
      NSLocalizedString("labels.filter1", comment: "labels for filter - Trackers for today"),
      NSLocalizedString("labels.filter2", comment: "labels for filter - Completed"),
      NSLocalizedString("labels.filter3", comment: "labels for filter - Unfinished")
    ]

    static let statisticsList = [
      NSLocalizedString("labels.stat0", comment: "labels for stat - Best Period"),
      NSLocalizedString("labels.stat1", comment: "labels for stat - Ideal Days"),
      NSLocalizedString("labels.stat2", comment: "labels for stat - Trackers Completed"),
      NSLocalizedString("labels.stat3", comment: "labels for stat - Average")
    ]

    static let fullWeekDays = [
      NSLocalizedString("labels.fullWeekDays.monday", comment: "labels for Monday"),
      NSLocalizedString("labels.fullWeekDays.tuesday", comment: "labels for Tuesday"),
      NSLocalizedString("labels.fullWeekDays.wednesday", comment: "labels for Wednesday"),
      NSLocalizedString("labels.fullWeekDays.thursday", comment: "labels for Thursday"),
      NSLocalizedString("labels.fullWeekDays.friday", comment: "labels for Friday"),
      NSLocalizedString("labels.fullWeekDays.saturday", comment: "labels for Saturday"),
      NSLocalizedString("labels.fullWeekDays.sunday", comment: "labels for Sunday")
    ]

    static let shortWeekDays = [
      NSLocalizedString("labels.shortWeekDays.0", comment: "short labels for Monday"),
      NSLocalizedString("labels.shortWeekDays.1", comment: "short labels for Tuesday"),
      NSLocalizedString("labels.shortWeekDays.2", comment: "short labels for Wednesday"),
      NSLocalizedString("labels.shortWeekDays.3", comment: "short labels for Thursday"),
      NSLocalizedString("labels.shortWeekDays.4", comment: "short labels for Friday"),
      NSLocalizedString("labels.shortWeekDays.5", comment: "short labels for Saturday"),
      NSLocalizedString("labels.shortWeekDays.6", comment: "short labels for Sunday")
    ]
  }

  // MARK: - UI element's SF symbols
  enum SfSymbols {
    static let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium, scale: .large)
    static let addTracker = UIImage(systemName: "plus", withConfiguration: largeConfig)
    static let tracker = UIImage(systemName: "record.circle.fill")
    static let statistic = UIImage(systemName: "hare.fill")
    static let chevron = UIImage(systemName: "chevron.forward") // It's correct for RTL also
    static let addCounter = UIImage(systemName: "plus")
    static let doneMark = UIImage(systemName: "checkmark")
    static let pinTracker = UIImage(systemName: "pin")
  }

  // MARK: - UI element's images
  enum Images {
    static let emptySearch = UIImage(named: "DummySearch")
    static let emptyTrackers = UIImage(named: "DummyTrackers")
    static let emptyStatistic = UIImage(named: "DummyStatistic")
    static let onboardingPage1 = UIImage(named: "OnboardingBgPage1")
    static let onboardingPage2 = UIImage(named: "OnboardingBgPage2")
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
    static let contentHeight: CGFloat = 90
    static let trackerCounterHeight: CGFloat = 58
    static let sectionHeight: CGFloat = 46
    static let iPhoneSeWidth: CGFloat = 320
    static let optionCell: CGFloat = 52
    static let optionHeader: CGFloat = 20
    static let optionViewHeight: CGFloat = 204
    static let optionBorder: CGFloat = 3
    static let gradientBorder: CGFloat = 1
    static let dividerHeight: CGFloat = 0.5
    static let markSize: CGFloat = 20
    static let filterWidth: CGFloat = 114
    static let filterHeight: CGFloat = 50
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
    static let optionCellPerLine: CGFloat = 6
    static let vSpacingOnboardingButton: CGFloat = 84
    static let vSpacingOnboardingPageCtl: CGFloat = 134
  }

  // MARK: - Fonts
  enum Fonts {
    static let titleUsual = UIFont.systemFont(ofSize: 16, weight: .medium)
    static let titleLarge = UIFont.systemFont(ofSize: 34, weight: .bold)
    static let textNotification = UIFont.systemFont(ofSize: 12, weight: .medium)
    static let textField = UIFont.systemFont(ofSize: 17, weight: .regular)
    static let sectionHeader = UIFont.systemFont(ofSize: 19, weight: .bold)
    static let emoji = UIFont.systemFont(ofSize: 32, weight: .bold)
    static let statCounter = UIFont.systemFont(ofSize: 34, weight: .bold)
  }


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
  static let shiftTimeZone = 60 * 60 * 3
  static let dateFormat = "dd.MM.YYYY"
  static let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = Resources.dateFormat
    return dateFormatter
  }()
}
