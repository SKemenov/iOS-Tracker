//
//  SplashScreenViewController.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 10.10.2023.
//

import UIKit

final class SplashScreenViewController: UIViewController {
  // MARK: - Inits

  init() {
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Life

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .ypWhite
  }
}
