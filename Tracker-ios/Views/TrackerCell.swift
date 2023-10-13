//
//  TrackerCell.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 08.10.2023.
//

import UIKit

// MARK: - Class EmojiCell

final class TrackerCell: UICollectionViewCell {
  // MARK: - Public properties

  let titleEmoji: UILabel = {
    $0.font = UIFont.systemFont(ofSize: 36)
    $0.translatesAutoresizingMaskIntoConstraints = false
    return $0
  }(UILabel(frame: .zero))

  // MARK: - Inits

  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(titleEmoji)

    NSLayoutConstraint.activate([
      titleEmoji.centerXAnchor.constraint(equalTo: centerXAnchor),
      titleEmoji.topAnchor.constraint(equalTo: topAnchor),
      titleEmoji.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
