//
//  TrackerCell.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 08.10.2023.
//

import UIKit

// MARK: - Protocol
protocol TrackerCellDelegate: AnyObject {
  func trackerCellDidTapDone(for cell: TrackerCell)
}

// MARK: - Class

final class TrackerCell: UICollectionViewCell {
  // MARK: - Private properties
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

  private let counterLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 1
    label.textAlignment = .natural
    label.textColor = .ypBlack
    label.font = Resources.Fonts.textNotification
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let counterButton: UIButton = {
    let view = UIButton()
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

  // MARK: - Public properties

  weak var delegate: TrackerCellDelegate?

  // MARK: - Inits

  override init(frame: CGRect) {
    super.init(frame: frame)
    configureTrackerCell()
    counterButton.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Private methods

private extension TrackerCell {
  @objc func didTapDoneButton() {
    delegate?.trackerCellDidTapDone(for: self)
  }
}

// MARK: - Public methods

extension TrackerCell {
  func makeItDone(_ isCompleted: Bool) {
    counterImageView.image = isCompleted ? Resources.SfSymbols.doneMark : Resources.SfSymbols.addCounter
    counterButton.alpha = isCompleted ? 0.7 : 1
  }

  func configureCell(bgColor: UIColor, emoji: String, title: String, counter: Int) {
    titleView.backgroundColor = bgColor
    counterButton.backgroundColor = bgColor
    titleLabel.text = title
    emojiLabel.text = emoji
    updateCounter(counter)
  }

    func updateCounter(_ counter: Int) {
      counterLabel.text = String.localizedStringWithFormat(
        NSLocalizedString("numberOfDays", comment: "Counter of total tracker's completed days"),
        counter
      )
    }
}

// MARK: - Configure TrackerCell UI Section

private extension TrackerCell {
  func configureTrackerCell() {
    configureTrackerCellSubviews()
    configureTrackerCellConstraints()
  }

  func configureTrackerCellSubviews() {
    contentView.addSubview(titleView)
    contentView.addSubview(emojiLabel)
    contentView.addSubview(titleLabel)
    contentView.addSubview(counterButton)
    contentView.addSubview(counterLabel)
    contentView.addSubview(counterImageView)
  }

  func configureTrackerCellConstraints() {
    let height = Resources.Dimensions.contentHeight
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

      counterButton.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: smallSpacing),
      counterButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -spacing),
      counterButton.widthAnchor.constraint(equalToConstant: Resources.Dimensions.cornerRadius * 2),
      counterButton.heightAnchor.constraint(equalToConstant: Resources.Dimensions.cornerRadius * 2),

      counterLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: spacing),
      counterLabel.trailingAnchor.constraint(equalTo: counterButton.leadingAnchor, constant: -smallSpacing),
      counterLabel.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: largeSpacing),
      counterLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -spacing * 2),

      counterImageView.centerXAnchor.constraint(equalTo: counterButton.centerXAnchor),
      counterImageView.centerYAnchor.constraint(equalTo: counterButton.centerYAnchor),
      counterImageView.widthAnchor.constraint(equalToConstant: spacing),
      counterImageView.heightAnchor.constraint(equalToConstant: spacing)
    ])
  }
}
