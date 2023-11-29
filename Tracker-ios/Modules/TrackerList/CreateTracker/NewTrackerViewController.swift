//
//  NewTrackerViewController.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 11.10.2023.
//

import UIKit

// MARK: - Protocol

protocol NewTrackerViewControllerDelegate: AnyObject {
  func newTrackerViewController(
    _ viewController: NewTrackerViewController,
    didFilledTracker tracker: Tracker,
    for categoryId: UUID
  )
}

// MARK: - Class

final class NewTrackerViewController: UIViewController {
  // MARK: - Private properties
  private var titleLabel = UILabel()
  private var stackView = UIStackView()
  private var newHabitButton = ActionButton()
  private var newEventButton = ActionButton()

  // MARK: - Public properties

  weak var delegate: NewTrackerViewControllerDelegate?

  // MARK: - Life circle

  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
}

// MARK: - CreateTrackerViewControllerDelegate

extension NewTrackerViewController: CreateTrackerViewControllerDelegate {
  func createTrackerViewController(
    _ viewController: CreateTrackerViewController,
    didFilledTracker tracker: Tracker,
    for categoryId: UUID
  ) {
    delegate?.newTrackerViewController(self, didFilledTracker: tracker, for: categoryId)
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
  func configureUI() {
    configureUISettings()
    view.backgroundColor = .ypWhite
    view.addSubview(titleLabel)
    view.addSubview(stackView)
    stackView.addArrangedSubview(newHabitButton)
    stackView.addArrangedSubview(newEventButton)

    let safeArea = view.safeAreaLayoutGuide

    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Resources.Layouts.vSpacingTitle),
      titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
      titleLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),

      stackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
      stackView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
      stackView.widthAnchor.constraint(equalToConstant: view.frame.width - 2 * Resources.Layouts.leadingButton),
      stackView.heightAnchor.constraint(
        equalToConstant: 2 * Resources.Dimensions.buttonHeight + Resources.Layouts.vSpacingButton
      )
    ])
  }

  func configureUISettings() {
    titleLabel.text = Resources.Labels.newTracker
    titleLabel.font = Resources.Fonts.titleUsual
    titleLabel.textAlignment = .center
    titleLabel.translatesAutoresizingMaskIntoConstraints = false

    stackView.axis = .vertical
    stackView.distribution = .fillEqually
    stackView.spacing = Resources.Layouts.vSpacingButton
    stackView.translatesAutoresizingMaskIntoConstraints = false

    newHabitButton.setTitle(Resources.Labels.habit, for: .normal)
    newHabitButton.addTarget(self, action: #selector(newHabitButtonClicked), for: .touchUpInside)

    newEventButton.setTitle(Resources.Labels.event, for: .normal)
    newEventButton.addTarget(self, action: #selector(newEventButtonClicked), for: .touchUpInside)
  }
}
