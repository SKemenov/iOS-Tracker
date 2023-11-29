//
//  StatisticViewController.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 10.10.2023.
//

import UIKit

// MARK: - Class

final class StatisticViewController: UIViewController {
  // MARK: - Private properties

  private var emptyView = EmptyView()
  private var titleLabel = UILabel()
  private var stackView = UIStackView()
  private var statBestPeriod = StatsView()
  private var statIdealDays = StatsView()
  private var statCompleted = StatsView()
  private var statAverage = StatsView()

  private lazy var safeArea: UILayoutGuide = {
    view.safeAreaLayoutGuide
  }()

  private lazy var statWidth: CGFloat = {
    view.frame.width - 2 * Resources.Layouts.leadingElement
  }()

  private lazy var statHeight: CGFloat = {
    Resources.Dimensions.contentHeight
  }()

  private lazy var statSpacing: CGFloat = {
    Resources.Layouts.vSpacingButton
  }()

  private let factory = TrackersCoreDataFactory.shared

  private var trackersCompletedCounter: Int = 0 {
    didSet {
      statCompleted.update(counter: trackersCompletedCounter)
    }
  }

  private var isEmpty: Bool {
    trackersCompletedCounter == 0
  }

  // MARK: - Life circle

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .ypWhite
    configureUI()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateStatisticView()
  }
}

// MARK: - Private methods

private extension StatisticViewController {
  func updateStatisticView() {
    trackersCompletedCounter = factory.totalRecords
    emptyView.isHidden = !isEmpty
    stackView.isHidden = isEmpty
  }

  func addToStat(_ view: StatsView, viewModel: StatsViewModel) {
    view.frame.size = CGSize(width: statWidth, height: statHeight)
    view.configure(viewModel: StatsViewModel(counter: viewModel.counter, title: viewModel.title))
    view.translatesAutoresizingMaskIntoConstraints = false
    view.gradientBorder(width: Resources.Dimensions.gradientBorder, colors: [.ypRed, .green, .ypBlue])
    stackView.addArrangedSubview(view)
  }
}

// MARK: - Private methods to configure Title section

private extension StatisticViewController {
  func configureUI() {
    configureTitleSection()
    configureStackViewSection()
    configureEmptyViewSection()
  }

  func configureTitleSection() {
    titleLabel.text = Resources.Labels.statistic
    titleLabel.font = Resources.Fonts.titleLarge
    titleLabel.textAlignment = .natural
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(titleLabel)

    let leading = Resources.Layouts.leadingElement
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Resources.Layouts.vSpacingLargeTitle),
      titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: leading),
      titleLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -leading),
      titleLabel.heightAnchor.constraint(equalToConstant: Resources.Dimensions.titleHeight)
    ])
  }
}

// MARK: - Private methods to configure stackView section

private extension StatisticViewController {
  func configureStackViewSection() {
    stackView.axis = .vertical
    stackView.distribution = .fillEqually
    stackView.spacing = statSpacing
    stackView.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(stackView)

    // mock datas
    addToStat(statBestPeriod, viewModel: StatsViewModel(counter: .zero, title: Resources.Labels.statisticsList[0]))
    addToStat(statIdealDays, viewModel: StatsViewModel(counter: .zero, title: Resources.Labels.statisticsList[1]))
    addToStat(statCompleted, viewModel: StatsViewModel(counter: .zero, title: Resources.Labels.statisticsList[2]))
    addToStat(statAverage, viewModel: StatsViewModel(counter: .zero, title: Resources.Labels.statisticsList[3]))


    NSLayoutConstraint.activate([
      stackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
      stackView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
      stackView.heightAnchor.constraint(equalToConstant: 4 * statHeight + 3 * statSpacing),
      stackView.widthAnchor.constraint(equalToConstant: statWidth)
    ])
  }
}

// MARK: - Private methods to configure EmptyView section

private extension StatisticViewController {
  func configureEmptyViewSection() {
    emptyView.translatesAutoresizingMaskIntoConstraints = false
    emptyView.configure(title: Resources.Labels.emptyStatistic, iconImage: Resources.Images.emptyStatistic)

    view.addSubview(emptyView)

    NSLayoutConstraint.activate([
      emptyView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Resources.Layouts.vSpacingTitle * 2),
      emptyView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
      emptyView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
      emptyView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
    ])
  }
}
