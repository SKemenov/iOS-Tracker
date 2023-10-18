//
//  StatisticViewController.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 10.10.2023.
//

import UIKit

final class StatisticViewController: UIViewController {

  private var isEmpty = true
  private let emptyView = EmptyView()

  private lazy var statisticTitle: UILabel = {
    $0.text = Resources.Labels.statistic
    $0.textColor = .ypBlack
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.font = UIFont.systemFont(ofSize: 34, weight: .bold)
    $0.frame = CGRect(x: 0, y: 0, width: 254, height: 44)
    return $0
  }(UILabel())


  // MARK: - Inits

  init() {
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Life

  override func viewDidLoad() {
    super.viewDidLoad()
    print("SVC Run viewDidLoad()")

    view.backgroundColor = .ypWhite
    view.addSubview(statisticTitle)
    NSLayoutConstraint.activate([
      statisticTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
      statisticTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      statisticTitle.trailingAnchor.constraint(
        lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -105)
    ])

    if isEmpty {
      emptyView.makeStack(for: self, title: "Анализировать пока нечего", image: Resources.Images.dummyStatistic)
    }
  }
}
