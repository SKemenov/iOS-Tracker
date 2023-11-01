//
//  UIViewController+Extensions.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 31.10.2023.
//

import UIKit

extension UIViewController {

  @objc func hideKeyboardWhenTappedAround() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }

  @objc private func dismissKeyboard() {
    view.endEditing(true)
  }
}
