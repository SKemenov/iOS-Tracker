//
//  CategoryCell.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 19.11.2023.
//

import UIKit

final class CategoryCell: UICollectionViewCell {
  // MARK: - Private properties
  private let nameLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 1
    label.textAlignment = .natural
    label.textColor = .ypBlack
    label.font = Resources.Fonts.textField
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  private let selectImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = Resources.SfSymbols.doneMark
    imageView.tintColor = .ypBlue
    imageView.contentMode = .scaleAspectFill
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()

  // MARK: - Inits

  override init(frame: CGRect) {
    super.init(frame: frame)
    configureCategoryCell()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func prepareForReuse() {
    super.prepareForReuse()
  }
}

// MARK: - Public methods

extension CategoryCell {
  func selectIt(_ isSelected: Bool) {
    selectImageView.isHidden = !isSelected
  }

  func configureCell(name: String, isSelected: Bool = false) {
    nameLabel.text = name
    selectImageView.isHidden = !isSelected
  }
}

// MARK: - Configure CategoryCell UI Section

private extension CategoryCell {
  func configureCategoryCell() {
    configureCategoryCellSubviews()
    configureCategoryCellConstraints()
  }

  func configureCategoryCellSubviews() {
    contentView.addSubview(nameLabel)
    contentView.addSubview(selectImageView)
  }

  func configureCategoryCellConstraints() {
    NSLayoutConstraint.activate([
      nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Resources.Layouts.leadingElement),
      nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: selectImageView.leadingAnchor),
      nameLabel.heightAnchor.constraint(equalToConstant: Resources.Dimensions.smallIcon),

      selectImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
      selectImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Resources.Layouts.leadingElement),
      selectImageView.widthAnchor.constraint(equalToConstant: Resources.Dimensions.smallIcon),
      selectImageView.heightAnchor.constraint(equalToConstant: Resources.Dimensions.smallIcon)
    ])
  }
}
