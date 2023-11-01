//
//  BorderView.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 18.10.2023.
//

import UIKit

// MARK: - Class

final class BorderView {
  // MARK: - Public method

  func configure(for containerView: UIView, width: CGFloat, repeat times: Int) {
    for time in 1...times {
      let borderView = UIView()
      borderView.frame = CGRect(
        x: Resources.Layouts.leadingElement,
        y: Resources.Dimensions.fieldHeight * CGFloat(time),
        width: width,
        height: 2
      )
      borderView.backgroundColor = .ypLightGray
      containerView.addSubview(borderView)
    }
  }
}
