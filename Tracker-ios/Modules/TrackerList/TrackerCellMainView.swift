//
//  TrackerCellMainView.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 01.12.2023.
//

import UIKit

// MARK: - Class

final class TrackerCellMainView: UIView {
  // MARK: - Private UI properties
  private let titleView: UIView = {
    let view = UIView()
    view.layer.cornerRadius = Resources.Dimensions.cornerRadius
    view.layer.masksToBounds = true
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 2
    label.textAlignment = .natural
    label.textColor = .ypWhite
    label.font = Resources.Fonts.textNotification
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let emojiLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 1
    label.textAlignment = .center
    label.textColor = .ypWhite
    label.font = Resources.Fonts.textNotification
    label.backgroundColor = .ypWhiteAlpha
    label.layer.cornerRadius = Resources.Dimensions.mediumCornerRadius
    label.layer.masksToBounds = true
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let pinImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = Resources.SfSymbols.pinFillTracker
    imageView.tintColor = .ypWhite
    imageView.contentMode = .scaleAspectFill
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()

  // MARK: - Public properties

  var viewModel: Tracker? {
    didSet {
      guard let viewModel else { return }
      titleView.backgroundColor = Resources.colors[viewModel.color]
      titleLabel.text = viewModel.title
      emojiLabel.text = Resources.emojis[viewModel.emoji]
      isPinned = viewModel.isPinned
      print(#function, viewModel)
    }
  }

  var isPinned = false {
    didSet {
      pinImageView.isHidden = !isPinned
      print(#function, pinImageView.isHidden)
    }
  }

  // MARK: - Inits

  required init(frame: CGRect, tracker: Tracker?) {
    self.viewModel = tracker
    super.init(frame: frame)
    configureUI()
    pinImageView.isHidden = !isPinned
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Configure TrackerCell UI Section

private extension TrackerCellMainView {
  func configureUI() {
    self.addSubview(titleView)
    titleView.addSubview(emojiLabel)
    titleView.addSubview(titleLabel)
    titleView.addSubview(pinImageView)

    let height = Resources.Dimensions.contentHeight
    let spacing = Resources.Layouts.leadingTracker
    let smallSpacing = Resources.Layouts.hSpacingButton

    NSLayoutConstraint.activate([
      titleView.leadingAnchor.constraint(equalTo: leadingAnchor),
      titleView.trailingAnchor.constraint(equalTo: trailingAnchor),
      titleView.topAnchor.constraint(equalTo: topAnchor),
      titleView.heightAnchor.constraint(equalToConstant: height),

      emojiLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: spacing),
      emojiLabel.topAnchor.constraint(equalTo: titleView.topAnchor, constant: spacing),
      emojiLabel.widthAnchor.constraint(equalToConstant: Resources.Dimensions.smallIcon),
      emojiLabel.heightAnchor.constraint(equalToConstant: Resources.Dimensions.smallIcon),

      titleLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: spacing),
      titleLabel.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: -spacing),
      titleLabel.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: smallSpacing),
      titleLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor, constant: -spacing),

      pinImageView.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: -spacing),
      pinImageView.centerYAnchor.constraint(equalTo: emojiLabel.centerYAnchor),
      pinImageView.widthAnchor.constraint(equalToConstant: spacing),
      pinImageView.heightAnchor.constraint(equalToConstant: spacing)
    ])
  }
}
