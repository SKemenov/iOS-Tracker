//
//  NewTrackerViewController.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 11.10.2023.
//

import UIKit

// MARK: - Protocol

protocol NewTrackerViewControllerDelegate: AnyObject {
  func newTrackerViewController(_ viewController: NewTrackerViewController, didFilledTracker tracker: String)
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
    print("NTVC Run viewDidLoad()")
    view.backgroundColor = .ypWhite

    configureTitleLabel()
    configureStackView()
  }
}

// MARK: - Private methods for button's actions

private extension NewTrackerViewController {
  @objc func newHabitButtonClicked() {
    print("NTVC Run newHabitButtonClicked()")
    let nextController = CreateTrackerViewController(isEvent: true)
    nextController.delegate = self
    present(nextController, animated: true)
  }

  @objc func newEventButtonClicked() {
    print("NTVC Run newEventButtonClicked()")
    let nextController = CreateTrackerViewController(isEvent: false)
    nextController.delegate = self
    present(nextController, animated: true)
  }
}

// MARK: - Private methods to configure UI elements

private extension NewTrackerViewController {

  func configureTitleLabel() {
    print("NTVC Run setupTitleLabel()")
    view.addSubview(titleLabel)
    titleLabel.text = Resources.Labels.newTracker
    titleLabel.font = Resources.Fonts.titleUsual
    titleLabel.textAlignment = .center
    // titleLabel.numberOfLines = 0
    // titleLabel.adjustsFontSizeToFitWidth = true

    configureTitleLabelConstraints()
  }

  func configureStackView() {
    print("NTVC Run configureStackViewConstraints()")
    view.addSubview(stackView)
    stackView.axis = .vertical
    stackView.distribution = .fillEqually
    stackView.spacing = Resources.Layouts.vSpacingButton
    addButtonsToStackView()
    configureStackViewConstraints()
  }

  func addButtonsToStackView() {
    let newHabitButton = ActionButton()
    newHabitButton.setTitle(Resources.Labels.habit, for: .normal)
    newHabitButton.addTarget(self, action: #selector(newHabitButtonClicked), for: .touchUpInside)
    stackView.addArrangedSubview(newHabitButton)

    let newEventButton = ActionButton()
    newEventButton.setTitle(Resources.Labels.event, for: .normal)
    newEventButton.addTarget(self, action: #selector(newEventButtonClicked), for: .touchUpInside)
    stackView.addArrangedSubview(newEventButton)
  }
}

// MARK: - Private methods to configure constraints

private extension NewTrackerViewController {

  func configureTitleLabelConstraints() {
    print("NTVC Run setupTitleLabelConstraints()")
    titleLabel.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Resources.Layouts.vSpacingTitle),
      titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
      titleLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
    ])
  }

  func configureStackViewConstraints() {
    print("NTVC Run configureStackViewConstraints()")
    stackView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      stackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
      stackView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
      stackView.widthAnchor.constraint(equalToConstant: stackWidth),
      stackView.heightAnchor.constraint(equalToConstant: stackHeight)
    ])
  }
}

// MARK: - CreateTrackerViewControllerDelegate

extension NewTrackerViewController: CreateTrackerViewControllerDelegate {
  func createTrackerViewController(_ viewController: CreateTrackerViewController, didFilledTracker tracker: String) {
    delegate?.newTrackerViewController(self, didFilledTracker: tracker)
  }
}
