//
//  TabBarViewController.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 10.10.2023.
//

import UIKit

// MARK: - Class

final class TabBarViewController: UITabBarController {
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTabBarView()
    setupTabBarViewController()
  }
}

// MARK: - Private methods to setup UI

private extension TabBarViewController {

  func setupTabBarView() {
    tabBar.barStyle = .default
    tabBar.tintColor = .ypBlue
    tabBar.backgroundColor = .ypWhite
    tabBar.layer.borderWidth = 0.50
    tabBar.layer.borderColor = UIColor.ypGray.cgColor
    tabBar.layer.masksToBounds = true
  }

  func setupTabBarViewController() {
    view.backgroundColor = .ypWhite

    let trackersVC = TrackersViewController()
    let navViewController = UINavigationController(rootViewController: trackersVC)
    setupTabBarItem(for: navViewController, with: Resources.Labels.trackers, image: Resources.SfSymbols.tracker)

    let statisticVC = StatisticViewController()
    setupTabBarItem(for: statisticVC, with: Resources.Labels.statistic, image: Resources.SfSymbols.statistic)

    viewControllers = [navViewController, statisticVC]
    selectedIndex = 0
  }

  func setupTabBarItem(for viewController: UIViewController, with title: String, image: UIImage?) {
    viewController.tabBarItem = UITabBarItem(
      title: title,
      image: image,
      selectedImage: nil
    )
  }
}

// MARK: - UITabBarControllerDelegate

extension TabBarViewController: UITabBarControllerDelegate {
  func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    selectedViewController = viewController
  }
}
