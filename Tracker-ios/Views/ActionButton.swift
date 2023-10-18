//
//  ActionButton.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 13.10.2023.
//

import UIKit

final class ActionButton: UIButton {
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupButton()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setupButton() {
    setTitleColor(.ypWhite, for: .normal)
    setTitleColor(.ypLightGray, for: .disabled)
    backgroundColor = .ypBlack
    titleLabel?.font = Resources.Fonts.titleUsual
    layer.cornerRadius = Resources.Dimensions.cornerRadius
    layer.masksToBounds = true
  }
}
