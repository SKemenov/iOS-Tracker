//
//  TrackerCell.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 08.10.2023.
//

import UIKit

// MARK: - Class

final class TrackerCell: UICollectionViewCell {
  // MARK: - Public properties

  let titleView: UIView = {
    let view = UIView()
    view.layer.cornerRadius = Resources.Dimensions.cornerRadius
    view.layer.masksToBounds = true
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  let titleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 2
    label.textAlignment = .natural
    label.textColor = .ypWhite
    label.font = Resources.Fonts.textNotification
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  let emojiLabel: UILabel = {
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

  let counterLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 1
    label.textAlignment = .natural
    label.textColor = .ypBlack
    label.font = Resources.Fonts.textNotification
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  let counterView: UIView = {
    let view = UIView()
    view.layer.cornerRadius = Resources.Dimensions.cornerRadius
    view.layer.masksToBounds = true
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  private let counterImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = Resources.SfSymbols.addCounter
    imageView.tintColor = .ypWhite
    imageView.contentMode = .scaleAspectFill
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()

  // MARK: - Inits

  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(titleView)
    contentView.addSubview(emojiLabel)
    contentView.addSubview(titleLabel)
    contentView.addSubview(counterView)
    contentView.addSubview(counterLabel)
    contentView.addSubview(counterImageView)

    let height = Resources.Dimensions.trackerContentHeight
    let spacing = Resources.Layouts.leadingTracker
    let smallSpacing = Resources.Layouts.hSpacingButton
    let largeSpacing = Resources.Layouts.leadingElement

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

      counterView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: smallSpacing),
      counterView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -spacing),
      counterView.widthAnchor.constraint(equalToConstant: Resources.Dimensions.cornerRadius * 2),
      counterView.heightAnchor.constraint(equalToConstant: Resources.Dimensions.cornerRadius * 2),

      counterLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: spacing),
      counterLabel.trailingAnchor.constraint(equalTo: counterView.leadingAnchor, constant: -smallSpacing),
      counterLabel.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: largeSpacing),
      counterLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -spacing * 2),

      counterImageView.centerXAnchor.constraint(equalTo: counterView.centerXAnchor),
      counterImageView.centerYAnchor.constraint(equalTo: counterView.centerYAnchor),
      counterImageView.widthAnchor.constraint(equalToConstant: spacing),
      counterImageView.heightAnchor.constraint(equalToConstant: spacing)
    ])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
