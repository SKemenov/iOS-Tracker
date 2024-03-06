//
//  CategoryCell.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 19.11.2023.
//

import UIKit

final class CategoryCell: UITableViewCell {
  // MARK: - Private properties
  private let cellView: UIView = {
    let view = UIView()
    view.backgroundColor = .ypBackground
    view.layer.masksToBounds = true
    view.layer.cornerRadius = Resources.Dimensions.cornerRadius
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

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

  private let cellID = "CategoryCell"

  // MARK: - Inits

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: cellID)
    configureUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Public methods

extension CategoryCell {
  func selectIt(_ isSelected: Bool) {
    selectImageView.isHidden = !isSelected
  }

  func configureCell(for category: CategoryCellViewModel) {
    nameLabel.text = category.name
    selectImageView.isHidden = !category.isSelected

    let isFirstCell = category.isFirst
    let isLastCell = category.isLast
    if isFirstCell && isLastCell {
      cellView.layer.maskedCorners = [
        .layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner
      ]
    } else if isFirstCell {
      cellView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    } else if isLastCell {
      cellView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    } else {
      cellView.layer.maskedCorners = []
    }

    if isLastCell {
      self.separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0)
    } else {
      self.separatorInset = UIEdgeInsets(
        top: .zero,
        left: Resources.Layouts.leadingElement,
        bottom: .zero,
        right: Resources.Layouts.leadingElement
      )
    }
  }
}

// MARK: - Configure CategoryCell UI Section

private extension CategoryCell {
  func configureUI() {
    contentView.addSubview(cellView)
    contentView.addSubview(nameLabel)
    contentView.addSubview(selectImageView)

    NSLayoutConstraint.activate([
      cellView.topAnchor.constraint(equalTo: topAnchor),
      cellView.bottomAnchor.constraint(equalTo: bottomAnchor),
      cellView.leadingAnchor.constraint(equalTo: leadingAnchor),
      cellView.trailingAnchor.constraint(equalTo: trailingAnchor),

      nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Resources.Layouts.leadingElement),
      nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: selectImageView.leadingAnchor),
      nameLabel.heightAnchor.constraint(equalToConstant: Resources.Dimensions.smallIcon),

      selectImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
      selectImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Resources.Layouts.leadingElement),
      selectImageView.widthAnchor.constraint(equalToConstant: Resources.Dimensions.markSize),
      selectImageView.heightAnchor.constraint(equalToConstant: Resources.Dimensions.markSize)
    ])
  }
}
