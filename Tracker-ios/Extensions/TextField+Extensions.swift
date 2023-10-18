//
//  TextField+Extensions.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 17.10.2023.
//

import UIKit

class TextField: UITextField {

  let padding = UIEdgeInsets(
    top: Resources.Layouts.vSpacingElement / 4,
    left: Resources.Layouts.leadingElement,
    bottom: Resources.Layouts.vSpacingElement / 4,
    right: Resources.Layouts.spacingElement * 4
  )

  override open func textRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }

  override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }

  override open func editingRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }
}
