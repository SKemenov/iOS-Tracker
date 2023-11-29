//
//  TabBarViewController.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 10.10.2023.
//

import UIKit

// MARK: - Class

final class TabBarViewController: UITabBarController {
  // MARK: - Life circle

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .ypWhite
    setupTabBarView()
    setupTabBarViewController()
    setupBorder()
  }
}

// MARK: - Private methods to setup UI

private extension TabBarViewController {

  func setupTabBarView() {
    tabBar.barStyle = .default
    tabBar.tintColor = .ypBlue
    tabBar.backgroundColor = .ypWhite
  }

  func setupTabBarViewController() {

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

  func setupBorder() {
    let subview = UIView()
    subview.backgroundColor = .ypBackground
    subview.translatesAutoresizingMaskIntoConstraints = false

    tabBar.addSubview(subview)

    NSLayoutConstraint.activate([
      subview.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor),
      subview.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor),
      subview.topAnchor.constraint(equalTo: tabBar.topAnchor),
      subview.heightAnchor.constraint(equalToConstant: Resources.Dimensions.dividerHeight)
    ])
  }
}

// MARK: - UITabBarControllerDelegate

extension TabBarViewController: UITabBarControllerDelegate {
  func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    selectedViewController = viewController
  }
}
