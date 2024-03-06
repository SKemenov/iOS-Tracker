//
//  UIView+Extensions.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 29.11.2023.
//

import UIKit

extension UIView {
  func gradientBorder(width: CGFloat, colors: [UIColor]) {
    let border = CAGradientLayer()
    border.frame = CGRect(
      x: bounds.origin.x,
      y: bounds.origin.y,
      width: bounds.size.width + width,
      height: bounds.size.height + width
    )
    border.colors = colors.map { $0.cgColor }
    border.startPoint = CGPoint(x: 0.0, y: 1.0)
    border.endPoint = CGPoint(x: 1.0, y: 1.0)

    let mask = CAShapeLayer()
    let maskRect = CGRect(
      x: bounds.origin.x + width / 2,
      y: bounds.origin.y + width / 2,
      width: bounds.size.width - width,
      height: bounds.size.height - width
    )
    mask.path = UIBezierPath(roundedRect: maskRect, cornerRadius: Resources.Dimensions.cornerRadius).cgPath
    mask.fillColor = UIColor.clear.cgColor
    mask.strokeColor = UIColor.white.cgColor
    mask.lineWidth = width

    border.mask = mask
    layer.addSublayer(border)
  }
}
