//
//  OnboardingViewController.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 18.11.2023.
//

import UIKit

// MARK: - Class

class OnboardingViewController: UIPageViewController {
  // MARK: - Private properties
  private let blueViewController = UIViewController()
  private let redViewController = UIViewController()

  private lazy var pages: [UIViewController] = [blueViewController, redViewController]

  private lazy var pageControl: UIPageControl = {
    let pageControl = UIPageControl()
    pageControl.numberOfPages = pages.count
    pageControl.currentPage = 0
    pageControl.currentPageIndicatorTintColor = .black
    pageControl.pageIndicatorTintColor = .ypGray

    pageControl.translatesAutoresizingMaskIntoConstraints = false
    return pageControl
  }()

  // MARK: - Inits

    override init(
      transitionStyle style: UIPageViewController.TransitionStyle,
      navigationOrientation: UIPageViewController.NavigationOrientation,
      options: [UIPageViewController.OptionsKey: Any]? = nil
    ) {
      super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }

    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    configUI()

    dataSource = self
    delegate = self

    if let first = pages.first {
      setViewControllers([first], direction: .forward, animated: true, completion: nil)
    }

    view.addSubview(pageControl)

    NSLayoutConstraint.activate([
      pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      pageControl.bottomAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.bottomAnchor,
        constant: -Resources.Layouts.vSpacingOnboardingPageCtl
      )
    ])
  }

  @objc private func buttonClicked() {
    guard let window = UIApplication.shared.windows.first else { preconditionFailure("Invalid Configuration") }
    let viewController = TabBarViewController()
    UserDefaults.standard.hasOnboarded = true
    window.rootViewController = viewController
  }
}

// MARK: - UIPageViewControllerDataSource

extension OnboardingViewController: UIPageViewControllerDataSource {
  // MARK: - hard borders

  func pageViewController(
    _ pageViewController: UIPageViewController,
    viewControllerBefore viewController: UIViewController
  ) -> UIViewController? {
    if let index = pages.firstIndex(of: viewController), index > 0 {
      return pages[index - 1]
    }
    return nil
  }

  func pageViewController(
    _ pageViewController: UIPageViewController,
    viewControllerAfter viewController: UIViewController
  ) -> UIViewController? {
    if let index = pages.firstIndex(of: viewController), index < pages.count - 1 {
      return pages[index + 1]
    }
    return nil
  }
}

// MARK: - UIPageViewControllerDelegate

extension OnboardingViewController: UIPageViewControllerDelegate {
  func pageViewController(
    _ pageViewController: UIPageViewController,
    didFinishAnimating finished: Bool,
    previousViewControllers: [UIViewController],
    transitionCompleted completed: Bool
  ) {
    if
      let currentViewController = pageViewController.viewControllers?.first,
      let currentIndex = pages.firstIndex(of: currentViewController) {
      pageControl.currentPage = currentIndex
    }
  }
}

// MARK: - Private methods to config UI

private extension OnboardingViewController {
  func configUI() {
    blueViewController.view.backgroundColor = .ypBlue
    addImage(bgImage: Resources.Images.onboardingPage1, to: blueViewController.view)
    add(title: Resources.Labels.onboardingPage1, to: blueViewController.view)
    addButton(to: blueViewController.view)

    redViewController.view.backgroundColor = .ypRed
    addImage(bgImage: Resources.Images.onboardingPage2, to: redViewController.view)
    add(title: Resources.Labels.onboardingPage2, to: redViewController.view)
    addButton(to: redViewController.view)
  }

  func addImage(bgImage: UIImage?, to mainView: UIView) {
    let image = UIImageView()
    image.image = bgImage
    image.translatesAutoresizingMaskIntoConstraints = false
    mainView.addSubview(image)
    NSLayoutConstraint.activate([
      image.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
      image.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
      image.topAnchor.constraint(equalTo: mainView.topAnchor),
      image.bottomAnchor.constraint(equalTo: mainView.bottomAnchor)
    ])
  }
  func add(title: String, to mainView: UIView) {
    let label = UILabel()
    label.numberOfLines = 2
    label.textAlignment = .center
    label.textColor = .black
    label.text = title
    label.font = Resources.Fonts.emoji
    label.translatesAutoresizingMaskIntoConstraints = false
    mainView.addSubview(label)
    NSLayoutConstraint.activate([
      label.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: Resources.Layouts.leadingButton),
      label.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -Resources.Layouts.leadingButton),
      label.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
      label.centerYAnchor.constraint(equalTo: mainView.centerYAnchor, constant: Resources.Dimensions.buttonHeight)
    ])
  }

  func addButton(to mainView: UIView) {
    let button = ActionButton()
    button.setTitle(Resources.Labels.onboardingButton, for: .normal)
    button.backgroundColor = .black
    button.setTitleColor(.white, for: .normal)
    button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    mainView.addSubview(button)
    NSLayoutConstraint.activate([
      button.heightAnchor.constraint(equalToConstant: Resources.Dimensions.buttonHeight),
      button.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: Resources.Layouts.leadingButton),
      button.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -Resources.Layouts.leadingButton),
      button.bottomAnchor.constraint(
        equalTo: mainView.bottomAnchor,
        constant: -Resources.Layouts.vSpacingOnboardingButton
      )
    ])
  }
}
