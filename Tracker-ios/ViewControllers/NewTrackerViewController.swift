//
//  NewTrackerViewController.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 11.10.2023.
//

import UIKit

final class NewTrackerViewController: UIViewController {
  // MARK: - Private properties
  private var titleLabel = UILabel()
  private var stackView = UIStackView()

  private let vSpacing: CGFloat = 16
  private let hSpacing: CGFloat = 20
  private let buttonHeight: CGFloat = 60

  // MARK: - Life

  override func viewDidLoad() {
    super.viewDidLoad()
    print("Run (viewDidLoad)")
    view.backgroundColor = .ypLightGray

    configureTitleLabel()
    configureStackView()
  }
}

private extension NewTrackerViewController {
  @objc func newHabitButtonClicked() {
    print("Run newHabitButtonClicked()")
  }

  @objc func newEventButtonClicked() {
    print("Run newEventButtonClicked()")
  }

  func configureTitleLabel() {
    print("Run setupTitleLabel()")
    view.addSubview(titleLabel)
    titleLabel.text = Resources.Labels.newTracker
    titleLabel.font = Resources.Fonts.titleUsual
    titleLabel.textAlignment = .center
    // titleLabel.numberOfLines = 0
    // titleLabel.adjustsFontSizeToFitWidth = true

    configureTitleLabelConstraints()
  }

  func configureStackView() {
    print("Run configureStackViewConstraints()")
    view.addSubview(stackView)
    stackView.axis = .vertical
    stackView.distribution = .fillEqually
    stackView.spacing = vSpacing
    addButtonsToStackView()
    configureStackViewConstraints()
  }

  func addButtonsToStackView() {
    let newHabitButton = ActionBlackButton()
    newHabitButton.setTitle(Resources.Labels.habit, for: .normal)
    newHabitButton.addTarget(self, action: #selector(newHabitButtonClicked), for: .touchUpInside)
    stackView.addArrangedSubview(newHabitButton)

    let newEventButton = ActionBlackButton()
    newEventButton.setTitle(Resources.Labels.event, for: .normal)
    newEventButton.addTarget(self, action: #selector(newEventButtonClicked), for: .touchUpInside)
    stackView.addArrangedSubview(newEventButton)
  }

  func configureTitleLabelConstraints() {
    print("Run setupTitleLabelConstraints()")
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    let saveArea = view.safeAreaLayoutGuide
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: saveArea.topAnchor, constant: vSpacing),
      titleLabel.leadingAnchor.constraint(equalTo: saveArea.leadingAnchor, constant: hSpacing),
      titleLabel.trailingAnchor.constraint(equalTo: saveArea.trailingAnchor, constant: -hSpacing)
    ])
  }

  func configureStackViewConstraints() {
    print("Run configureStackViewConstraints()")
    stackView.translatesAutoresizingMaskIntoConstraints = false
    let saveArea = view.safeAreaLayoutGuide
    let stackWidth = view.frame.width - 2 * hSpacing
    let stackHeight = 2 * buttonHeight + vSpacing

    NSLayoutConstraint.activate([
      stackView.centerXAnchor.constraint(equalTo: saveArea.centerXAnchor),
      stackView.centerYAnchor.constraint(equalTo: saveArea.centerYAnchor),
      stackView.widthAnchor.constraint(equalToConstant: stackWidth),
      stackView.heightAnchor.constraint(equalToConstant: stackHeight)
    ])
  }
}
