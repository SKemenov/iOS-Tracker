//
//  TrackerHeader.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 24.10.2023.
//

import UIKit

// MARK: - Class

final class TrackerHeader: UICollectionReusableView {
  // MARK: - Property

  let titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .ypBlack
    label.textAlignment = .natural
    label.font = Resources.Fonts.sectionHeader
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
}

// MARK: - Private methods

private extension TrackerHeader {
  func configureUI() {
    addSubview(titleLabel)

    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Resources.Layouts.leadingSection),
      titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Resources.Layouts.vSpacingSection),
      titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Resources.Layouts.vSpacingTracker)
    ])
  }
}
