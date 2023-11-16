//
//  NewTrackerViewController.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 11.10.2023.
//

import UIKit

// MARK: - Protocol

protocol NewTrackerViewControllerDelegate: AnyObject {
  func newTrackerViewController(_ viewController: NewTrackerViewController, didFilledTracker tracker: Tracker, for categoryIndex: Int)
}

// MARK: - Class

final class NewTrackerViewController: UIViewController {
  // MARK: - Private properties
  private var titleLabel = UILabel()
  private var stackView = UIStackView()

  private lazy var safeArea: UILayoutGuide = {
    view.safeAreaLayoutGuide
  }()

  private lazy var stackWidth: CGFloat = {
    view.frame.width - 2 * Resources.Layouts.leadingButton
  }()

  private lazy var stackHeight: CGFloat = {
    2 * Resources.Dimensions.buttonHeight + Resources.Layouts.vSpacingButton
  }()

  // MARK: - Public properties

  weak var delegate: NewTrackerViewControllerDelegate?

  // MARK: - Life circle

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .ypWhite

    configureTitleLabelSection()
    configureStackViewSection()
  }
}

// MARK: - CreateTrackerViewControllerDelegate

extension NewTrackerViewController: CreateTrackerViewControllerDelegate {
  func createTrackerViewController(_ viewController: CreateTrackerViewController, didFilledTracker tracker: Tracker, for categoryIndex: Int) {
    delegate?.newTrackerViewController(self, didFilledTracker: tracker, for: categoryIndex)
  }
}

// MARK: - Private methods for button's actions

private extension NewTrackerViewController {
  @objc func newHabitButtonClicked() {
    let nextController = CreateTrackerViewController(isHabit: true)
    nextController.delegate = self
    nextController.isModalInPresentation = true
    present(nextController, animated: true)
  }

  @objc func newEventButtonClicked() {
    let nextController = CreateTrackerViewController(isHabit: false)
    nextController.delegate = self
    nextController.isModalInPresentation = true
    present(nextController, animated: true)
  }
}

// MARK: - Private methods to configure Title section

private extension NewTrackerViewController {
  func configureTitleLabelSection() {
    configureTitleLabel()
    view.addSubview(titleLabel)
    configureTitleLabelConstraints()
  }

  func configureTitleLabel() {
    titleLabel.text = Resources.Labels.newTracker
    titleLabel.font = Resources.Fonts.titleUsual
    titleLabel.textAlignment = .center
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
  }

  func configureTitleLabelConstraints() {
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Resources.Layouts.vSpacingTitle),
      titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
      titleLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
    ])
  }
}

// MARK: - Private methods to configure Stack section

private extension NewTrackerViewController {

  func configureStackViewSection() {
    configureStackView()
    view.addSubview(stackView)
    addHabitButtonToStackView()
    addEventButtonToStackView()
    configureStackViewConstraints()
  }

  func configureStackView() {
    stackView.axis = .vertical
    stackView.distribution = .fillEqually
    stackView.spacing = Resources.Layouts.vSpacingButton
    stackView.translatesAutoresizingMaskIntoConstraints = false
  }

  func addHabitButtonToStackView() {
    let newHabitButton = ActionButton()
    newHabitButton.setTitle(Resources.Labels.habit, for: .normal)
    newHabitButton.addTarget(self, action: #selector(newHabitButtonClicked), for: .touchUpInside)
    stackView.addArrangedSubview(newHabitButton)
  }

  func addEventButtonToStackView() {
    let newEventButton = ActionButton()
    newEventButton.setTitle(Resources.Labels.event, for: .normal)
    newEventButton.addTarget(self, action: #selector(newEventButtonClicked), for: .touchUpInside)
    stackView.addArrangedSubview(newEventButton)
  }

  func configureStackViewConstraints() {
    NSLayoutConstraint.activate([
      stackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
      stackView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
      stackView.widthAnchor.constraint(equalToConstant: stackWidth),
      stackView.heightAnchor.constraint(equalToConstant: stackHeight)
    ])
  }
}
