//
//  ActionButton.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 13.10.2023.
//

import UIKit

// MARK: - Class

final class ActionButton: UIButton {
  // MARK: - Inits

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupButton()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Private method

  private func setupButton() {
    setTitleColor(.ypWhite, for: .normal)
    setTitleColor(.ypGray, for: .focused)
    setTitleColor(.ypLightGray, for: .disabled)
    backgroundColor = .ypBlack
    titleLabel?.font = Resources.Fonts.titleUsual
    layer.cornerRadius = Resources.Dimensions.cornerRadius
    layer.masksToBounds = true
  }

  // MARK: - Animation effects for custom buttons

  override func draw(_ rect: CGRect) {
    self.addTarget(self, action: #selector(tapped), for: .touchDown)
    self.addTarget(self, action: #selector(untapped), for: .touchUpInside)
  }

  @objc func tapped() {
    self.setTitleColor(.ypGray, for: .normal)
  }

  @objc func untapped() {
    self.setTitleColor(.ypWhite, for: .normal)
  }
}
