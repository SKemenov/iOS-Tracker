//
//  OptionButton.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 14.10.2023.
//


import UIKit

// MARK: - Class

final class OptionButton: UIButton {
  // MARK: - Private properties

  private let primaryLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 1
    label.textAlignment = .natural
    label.textColor = .ypBlack
    label.font = Resources.Fonts.textField
    return label
  }()

  private let secondaryLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 1
    label.textAlignment = .natural
    label.textColor = .ypGray
    label.font = Resources.Fonts.textField
    label.isHidden = true
    return label
  }()

  private let iconImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = Resources.SfSymbols.chevron
    imageView.tintColor = .ypGray
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()

  private lazy var isRtl = UIView.userInterfaceLayoutDirection(
    for: primaryLabel.semanticContentAttribute
  ) == .rightToLeft

  // MARK: - Inits

  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(primaryLabel)
    addSubview(secondaryLabel)
    addSubview(iconImageView)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Public methods

  func configure(title: String) {
    primaryLabel.text = title
  }

  func configure(value: String) {
    secondaryLabel.text = value
    secondaryLabel.isHidden = false
    layoutSubviews()
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    let hSpacing = Resources.Layouts.leadingElement
    let iconSize = Resources.Dimensions.smallIcon
    let labelHeight = iconSize

    iconImageView.frame = CGRect(
      x: isRtl ? iconSize : frame.size.width - iconSize - hSpacing,
      y: (frame.size.height - iconSize / 2 ) / 2,
      width: iconSize / 3,
      height: iconSize / 2
    )

    if secondaryLabel.text == nil {
      primaryLabel.frame = CGRect(
        x: isRtl ? -hSpacing : hSpacing,
        y: (frame.size.height - labelHeight ) / 2,
        width: isRtl ? frame.size.width : frame.size.width - iconSize - hSpacing * 2,
        height: labelHeight
      )
    } else {
      primaryLabel.frame = CGRect(
        x: isRtl ? -hSpacing : hSpacing,
        y: labelHeight / 2,
        width: isRtl ? frame.size.width : frame.size.width - iconSize - hSpacing * 2,
        height: labelHeight
      )
      secondaryLabel.frame = CGRect(
        x: isRtl ? -hSpacing : hSpacing,
        y: labelHeight + labelHeight / 2,
        width: isRtl ? frame.size.width : frame.size.width - iconSize - hSpacing * 2,
        height: labelHeight
      )
    }
  }

  // MARK: - Animation effects for custom buttons

  override func draw(_ rect: CGRect) {
    self.addTarget(self, action: #selector(tapped), for: .touchDown)
    self.addTarget(self, action: #selector(untapped), for: .touchUpInside)
  }

  @objc private func tapped() {
    self.alpha = 0.7
  }

  @objc private func untapped() {
    self.alpha = 1
  }
}
