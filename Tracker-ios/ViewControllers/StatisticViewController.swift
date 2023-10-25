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

  private var isEmpty = true
  private var emptyView = EmptyView()
  private lazy var titleLabel = UILabel()

  private lazy var safeArea: UILayoutGuide = {
    view.safeAreaLayoutGuide
  }()

  // MARK: - Life circle

  override func viewDidLoad() {
    super.viewDidLoad()
    print("StVC Run viewDidLoad()")

    view.backgroundColor = .ypWhite
    configureTitleSection()
    configureEmptyViewSection()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    print("StVC Run viewWillAppear()")
    emptyView.isHidden = !isEmpty
  }
}

// MARK: - Private methods to configure Title section

private extension StatisticViewController {
  func configureTitleSection() {
    print("StVC Run configureTitleSection()")
    titleLabel.text = Resources.Labels.statistic
    titleLabel.font = Resources.Fonts.titleLarge
    titleLabel.textAlignment = .natural
    titleLabel.frame = CGRect(
      x: 0,
      y: 0,
      width: view.frame.width,
      height: Resources.Dimensions.titleHeight
    )
    view.addSubview(titleLabel)
    configureTitleSectionConstraints()
  }

  func configureTitleSectionConstraints() {
    print("StVC Run configureTitleSectionConstraints()")
    let leading = Resources.Layouts.leadingElement
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Resources.Layouts.vSpacingLargeTitle),
      titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: leading),
      titleLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -leading),
      titleLabel.heightAnchor.constraint(equalToConstant: Resources.Dimensions.titleHeight)
    ])
  }
}

// MARK: - Private methods to configure EmptyView section

private extension StatisticViewController {
  func configureEmptyViewSection() {
    print("StVC Run configureEmptyViewSection()")
    emptyView.translatesAutoresizingMaskIntoConstraints = false
    emptyView.configure(
      title: Resources.Labels.emptyStatistic,
      iconImage: Resources.Images.emptyStatistic
    )
    view.addSubview(emptyView)
    configureEmptyViewSectionConstraints()
  }

  func configureEmptyViewSectionConstraints() {
    print("StVC Run configureEmptyViewSectionConstraints()")
    emptyView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      emptyView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Resources.Layouts.vSpacingTitle * 2),
      emptyView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
      emptyView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
      emptyView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
    ])
  }
}
