//
//  NewHabitViewController.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 14.10.2023.
//

import UIKit

final class NewHabitViewController: UIViewController {
  // MARK: - Private properties
  private var titleLabel = UILabel()
  private var stackView = UIStackView()

  private let vSpacing: CGFloat = 16
  private let hSpacing: CGFloat = 20
  private let buttonHeight: CGFloat = 60
  private var nameIsFulfilled = false
  private var categoryIsSelected = false
  private var scheduleIsFulfilled = false
  private var emojiIsSelected = true // dummy for now
  private var colorIsSelected = true // dummy for now
  private var formIsFulfilled = false

  // MARK: - Life circle

  override func viewDidLoad() {
    super.viewDidLoad()
    print("Run viewDidLoad()")
    view.backgroundColor = .ypWhite
    formIsFulfilled = nameIsFulfilled && categoryIsSelected && scheduleIsFulfilled && scheduleIsFulfilled
    && emojiIsSelected && colorIsSelected
    print("formIsFulfilled \(formIsFulfilled)")
    configureTitleLabel()
    configureStackView()
  }
}


// MARK: - Private methods for button's actions

private extension NewHabitViewController {
  @objc func cancelButtonClicked() {
    print("Run cancelButtonClicked()")
  }

  @objc func createButtonClicked() {
    print("Run createButtonClicked()")
  }
}

// MARK: - Private methods to configure UI elements

private extension NewHabitViewController {

  func configureTitleLabel() {
    print("Run setupTitleLabel()")
    view.addSubview(titleLabel)
    titleLabel.text = Resources.Labels.newHabit
    titleLabel.font = Resources.Fonts.titleUsual
    titleLabel.textAlignment = .center

    configureTitleLabelConstraints()
  }

  func configureStackView() {
    print("Run configureStackViewConstraints()")
    view.addSubview(stackView)
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.spacing = vSpacing
    addButtonsToStackView()
    configureStackViewConstraints()
  }

  func addButtonsToStackView() {
    let cancelButton = ActionButton()
    cancelButton.setTitle(Resources.Labels.cancel, for: .normal)
    cancelButton.setTitleColor(.ypBlack, for: .normal)
    cancelButton.backgroundColor = .ypWhite
    cancelButton.layer.borderColor = UIColor.ypRed.cgColor
    cancelButton.layer.borderWidth = 1
    cancelButton.addTarget(self, action: #selector(cancelButtonClicked), for: .touchUpInside)
    stackView.addArrangedSubview(cancelButton)

    let createButton = ActionButton()
    createButton.setTitle(Resources.Labels.create, for: .normal)
    createButton.setTitleColor(.ypLightGray, for: .disabled)
    createButton.backgroundColor = formIsFulfilled ? .ypBlack : .ypGray
    createButton.addTarget(self, action: #selector(createButtonClicked), for: .touchUpInside)
    createButton.isEnabled = formIsFulfilled ? true : false
    stackView.addArrangedSubview(createButton)
  }
}

// MARK: - Private methods to configure constraints

private extension NewHabitViewController {

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
    let stackHeight = buttonHeight

    NSLayoutConstraint.activate([
      stackView.centerXAnchor.constraint(equalTo: saveArea.centerXAnchor),
      stackView.centerYAnchor.constraint(equalTo: saveArea.centerYAnchor),
      stackView.widthAnchor.constraint(equalToConstant: stackWidth),
      stackView.heightAnchor.constraint(equalToConstant: stackHeight)
    ])
  }
}
