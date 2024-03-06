//
//  StatsView.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 29.11.2023.
//

import UIKit

// MARK: - Class

final class StatsView: UIView {
  // MARK: - Private properties

  private let fullView: UIView = {
    let view = UIView()
    view.layer.cornerRadius = Resources.Dimensions.cornerRadius
    view.layer.masksToBounds = true
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  private let counterLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .natural
    label.textColor = .ypBlack
    label.font = Resources.Fonts.statCounter
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  private let descriptionLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .natural
    label.textColor = .ypBlack
    label.font = Resources.Fonts.textNotification
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  // MARK: - Public properties

  var viewModel: StatsViewModel? {
    didSet {
      guard let viewModel else { return }
      counterLabel.text = String(viewModel.counter)
      descriptionLabel.text = viewModel.title
    }
  }

  var counter: Int? {
    didSet {
      guard let counter else { return }
      counterLabel.text = String(counter)
    }
  }

  // MARK: - Inits

  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Private methods

private extension StatsView {
  func configureUI() {
    addSubview(fullView)
    fullView.addSubview(counterLabel)
    fullView.addSubview(descriptionLabel)

    let spacing = Resources.Layouts.leadingTracker

    NSLayoutConstraint.activate([
      fullView.leadingAnchor.constraint(equalTo: leadingAnchor),
      fullView.trailingAnchor.constraint(equalTo: trailingAnchor),
      fullView.topAnchor.constraint(equalTo: topAnchor),
      fullView.bottomAnchor.constraint(equalTo: bottomAnchor),

      counterLabel.leadingAnchor.constraint(equalTo: fullView.leadingAnchor, constant: spacing),
      counterLabel.trailingAnchor.constraint(equalTo: fullView.trailingAnchor, constant: -spacing),
      counterLabel.topAnchor.constraint(equalTo: fullView.topAnchor, constant: spacing),
      counterLabel.heightAnchor.constraint(equalToConstant: Resources.Dimensions.titleHeight),

      descriptionLabel.leadingAnchor.constraint(equalTo: fullView.leadingAnchor, constant: spacing),
      descriptionLabel.trailingAnchor.constraint(equalTo: fullView.trailingAnchor, constant: -spacing),
      descriptionLabel.bottomAnchor.constraint(equalTo: fullView.bottomAnchor, constant: -spacing),
      descriptionLabel.heightAnchor.constraint(equalToConstant: Resources.Dimensions.notificationHeight)
    ])
  }
}
