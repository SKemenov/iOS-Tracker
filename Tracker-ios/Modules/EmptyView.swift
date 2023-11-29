//
//  EmptyView.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 10.10.2023.
//

import UIKit

// MARK: - Class

final class EmptyView: UIView {
  // MARK: - Private properties

  private let fullView = UIView()
  private let centeredView = UIView()
  private let iconImageView = UIImageView()
  private let primaryLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.textColor = .ypBlack
    label.numberOfLines = 2
    label.font = Resources.Fonts.textNotification
    return label
  }()

  // MARK: - Inits

  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Public methods

  func configure(title: String, iconImage: UIImage?) {
    primaryLabel.text = title
    iconImageView.image = iconImage
  }
}

// MARK: - Private methods

private extension EmptyView {
  func configureUI() {
    fullView.translatesAutoresizingMaskIntoConstraints = false
    centeredView.translatesAutoresizingMaskIntoConstraints = false
    iconImageView.translatesAutoresizingMaskIntoConstraints = false
    primaryLabel.translatesAutoresizingMaskIntoConstraints = false

    addSubview(fullView)
    fullView.addSubview(centeredView)
    centeredView.addSubview(iconImageView)
    centeredView.addSubview(primaryLabel)

    let imageSize = Resources.Dimensions.bigIcon
    let titleHeight = Resources.Dimensions.notificationHeight * 2
    let spacing = Resources.Layouts.spacingElement
    let height = imageSize + spacing + titleHeight
    let width = Resources.Dimensions.iPhoneSeWidth - spacing * 2

    NSLayoutConstraint.activate([
      fullView.leadingAnchor.constraint(equalTo: leadingAnchor),
      fullView.trailingAnchor.constraint(equalTo: trailingAnchor),
      fullView.topAnchor.constraint(equalTo: topAnchor),
      fullView.bottomAnchor.constraint(equalTo: bottomAnchor),

      centeredView.centerXAnchor.constraint(equalTo: fullView.centerXAnchor),
      centeredView.centerYAnchor.constraint(equalTo: fullView.centerYAnchor),
      centeredView.widthAnchor.constraint(equalToConstant: width),
      centeredView.heightAnchor.constraint(equalToConstant: height),

      iconImageView.centerXAnchor.constraint(equalTo: centeredView.centerXAnchor),
      iconImageView.topAnchor.constraint(equalTo: centeredView.topAnchor),
      iconImageView.widthAnchor.constraint(equalToConstant: imageSize),
      iconImageView.heightAnchor.constraint(equalToConstant: imageSize),

      primaryLabel.leadingAnchor.constraint(equalTo: centeredView.leadingAnchor, constant: spacing),
      primaryLabel.trailingAnchor.constraint(equalTo: centeredView.trailingAnchor, constant: -spacing),
      primaryLabel.bottomAnchor.constraint(equalTo: centeredView.bottomAnchor),
      primaryLabel.heightAnchor.constraint(equalToConstant: titleHeight)
    ])
  }
}
