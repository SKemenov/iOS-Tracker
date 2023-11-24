//
//  ColorCell.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 08.11.2023.
//

import UIKit

// MARK: - Class

final class ColorCell: UICollectionViewCell {
  // MARK: - Private properties
  private let centerView: UIView = {
    let view = UIView()
    view.layer.cornerRadius = Resources.Dimensions.smallCornerRadius
    view.layer.masksToBounds = true
    view.layer.borderColor = UIColor.ypWhite.cgColor
    view.layer.borderWidth = Resources.Dimensions.optionBorder
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  // MARK: - Inits

  override init(frame: CGRect) {
    super.init(frame: frame)
    configureColorCell()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Public methods

extension ColorCell {
  func configureCell(bgColor: UIColor) {
    centerView.backgroundColor = bgColor
  }
}

// MARK: - Configure ColorCell UI Section

private extension ColorCell {
  func configureColorCell() {
    contentView.addSubview(centerView)
    configureColorCellConstraints()
  }

  func configureColorCellConstraints() {
    let colorCellSize = Resources.Dimensions.optionCell - Resources.Dimensions.optionBorder * 2
    NSLayoutConstraint.activate([
      centerView.centerXAnchor.constraint(equalTo: centerXAnchor),
      centerView.centerYAnchor.constraint(equalTo: centerYAnchor),
      centerView.widthAnchor.constraint(equalToConstant: colorCellSize),
      centerView.heightAnchor.constraint(equalToConstant: colorCellSize)
    ])
  }
}
