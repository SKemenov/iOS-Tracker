//
//  OptionCellHeader.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 08.11.2023.
//

import UIKit

// MARK: - Class

final class OptionCellHeader: UICollectionReusableView {
  // MARK: - Property

  private let titleLabel: UILabel = {
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

// MARK: - Public methods

extension OptionCellHeader {
  func configure(header: String) {
    titleLabel.text = header
  }
}
// MARK: - Private methods

private extension OptionCellHeader {
  func configureUI() {
    addSubview(titleLabel)

    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Resources.Layouts.leadingSection),
      titleLabel.topAnchor.constraint(equalTo: topAnchor),
      titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
}
