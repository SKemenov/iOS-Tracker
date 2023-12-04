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
    static let newTracker = NSLocalizedString("labels.newTracker", comment: "label for new Tracker")
    static let newEvent = NSLocalizedString("labels.newEvent", comment: "label for new Event")
    static let newHabit = NSLocalizedString("labels.newHabit", comment: "label for new Habit")
    static let editHabit = NSLocalizedString("labels.editHabit", comment: "label to edit Habit")
    static let newCategory = NSLocalizedString("labels.newCategory", comment: "label for new Category")
    static let editCategory = NSLocalizedString("labels.editCategory", comment: "label to edit Category")
    static let addCategory = NSLocalizedString("labels.addCategory", comment: "label to add Category")
    static let habit = NSLocalizedString("labels.habit", comment: "label for habit")
    static let event = NSLocalizedString("labels.event", comment: "label for event")
    static let category = NSLocalizedString("labels.category", comment: "label for category")
    static let schedule = NSLocalizedString("labels.schedule", comment: "label for schedule")
    static let statistic = NSLocalizedString("labels.statistic", comment: "label for statistic")
    static let trackers = NSLocalizedString("labels.trackers", comment: "label for trackers")
    static let searchBar = NSLocalizedString("labels.searchBar", comment: "label for searchBar")
    static let cancel = NSLocalizedString("labels.cancel", comment: "label for cancel")
    static let create = NSLocalizedString("labels.create", comment: "label for create")
    static let save = NSLocalizedString("labels.save", comment: "label for save")
    static let done = NSLocalizedString("labels.done", comment: "label for done")
    static let emoji = NSLocalizedString("labels.emoji", comment: "label for emoji")
    static let color = NSLocalizedString("labels.color", comment: "label for color")
    static let filters = NSLocalizedString("labels.filters", comment: "label for filters")
    static let emptyStatistic = NSLocalizedString("labels.emptyStatistic", comment: "label for empty Statistic")
    static let emptyTracker = NSLocalizedString("labels.emptyTracker", comment: "label for empty Tracker")
    static let emptySearch = NSLocalizedString("labels.emptySearch", comment: "label for empty Search")
    static let emptyCategory = NSLocalizedString("labels.emptyCategory", comment: "label for empty Category")
    static let everyDays = NSLocalizedString("labels.everyDays", comment: "label for everydays")
    static let weekDays = NSLocalizedString("labels.weekDays", comment: "label for weekDays")
    static let weekEnds = NSLocalizedString("labels.weekEnds", comment: "label for weekEnds")
    static let onboardingPage1 = NSLocalizedString("labels.onboardingPage1", comment: "label for onboarding Page 1")
    static let onboardingPage2 = NSLocalizedString("labels.onboardingPage2", comment: "label for onboarding Page 2")
    static let onboardingButton = NSLocalizedString("labels.onboardingButton", comment: "label for onboarding Button")
    static let confirmTrackerDelete = NSLocalizedString(
      "labels.confirmTrackerDelete",
      comment: "label to confirm Tracker Delete"
    )
    static let confirmCategoryDelete = NSLocalizedString(
      "labels.confirmCategoryDelete",
      comment: "label to confirm Category Delete"
    )
    static let cancelCategoryDelete = NSLocalizedString(
      "labels.cancelCategoryDelete",
      comment: "label to asking Category Deleting"
    )
    static let textFieldPlaceholder = NSLocalizedString(
      "labels.textFieldPlaceholder",
      comment: "label for text Field Placeholder"
    )
    static let categoryNamePlaceholder = NSLocalizedString(
      "labels.categoryNamePlaceholder",
      comment: "label for category Name Placeholder"
    )
    static let textFieldRestriction = NSLocalizedString(
      "labels.textFieldRestriction",
      comment: "label for text Field Restriction"
    )

    static let contextMenuList = [
      NSLocalizedString("labels.context.0", comment: "label for context menu - Pin"),
      NSLocalizedString("labels.context.1", comment: "label for context menu - Edit"),
      NSLocalizedString("labels.context.2", comment: "label for context menu - Delete"),
      NSLocalizedString("labels.context.3", comment: "label for context menu - Unpin")
    ]

    static let filtersList = [
      NSLocalizedString("labels.filter.0", comment: "label for filter - All Trackers"),
      NSLocalizedString("labels.filter.1", comment: "label for filter - Trackers for today"),
      NSLocalizedString("labels.filter.2", comment: "label for filter - Completed"),
      NSLocalizedString("labels.filter.3", comment: "label for filter - Unfinished")
    ]

    static let statisticsList = [
      NSLocalizedString("labels.stat.0", comment: "label for stat - Best Period"),
      NSLocalizedString("labels.stat.1", comment: "label for stat - Ideal Days"),
      NSLocalizedString("labels.stat.2", comment: "label for stat - Trackers Completed"),
      NSLocalizedString("labels.stat.3", comment: "label for stat - Average")
    ]

    static let fullWeekDays = Calendar.current.weekdaySymbols.shift()
    static let shortWeekDays = Calendar.current.shortWeekdaySymbols.shift()
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
    static let pinFillTracker = UIImage(systemName: "pin.fill")
    static let unpinTracker = UIImage(systemName: "pin.slash")
    static let editElement = UIImage(systemName: "rectangle.and.pencil.and.ellipsis")
    static let deleteElement = UIImage(systemName: "trash")
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

  static let pinCategoryName = NSLocalizedString("labels.pinCategoryName", comment: "label for Pinned Category's name")

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
