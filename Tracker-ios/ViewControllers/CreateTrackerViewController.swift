//
//  CreateTrackerViewController.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 14.10.2023.
//

import UIKit

// swift lint:disable file_length
// MARK: - Protocol

protocol CreateTrackerViewControllerDelegate: AnyObject {
  func createTrackerViewController(_ viewController: CreateTrackerViewController, didFilledTracker tracker: Tracker, for categoryIndex: Int)
}

// MARK: - Class

final class CreateTrackerViewController: UIViewController {
  // MARK: - Private  UI properties
  private var titleLabel = UILabel()

  private var textFieldStackView = UIStackView()
  private var textField = TextField()
  private var textFieldWarning = UILabel()

  private var optionsView = UIView()
  private var categoryButton = OptionButton()
  private var scheduleButton = OptionButton()

  private var buttonsStackView = UIStackView()
  private var cancelButton = ActionButton()
  private var createButton = ActionButton()

  // MARK: - Private layout properties

  private lazy var safeArea: UILayoutGuide = {
    view.safeAreaLayoutGuide
  }()

  private lazy var buttonsStackViewWidth: CGFloat = {
    view.frame.width - 2 * Resources.Layouts.leadingButton
  }()

  private lazy var optionsViewWidth: CGFloat = {
    view.frame.width - 2 * Resources.Layouts.leadingElement
  }()

  private lazy var optionsViewHeight: CGFloat = {
    return isHabit ? Resources.Dimensions.fieldHeight * 2 : Resources.Dimensions.fieldHeight
  }()

  private lazy var leadSpacing: CGFloat = {
    Resources.Layouts.leadingElement
  }()

  // MARK: - Private state properties

  private var trackerNameIsFulfilled = false {
    didSet {
      updateFormState()
    }
  }

  private var categoryIsSelected = false {
    didSet {
      updateFormState()
    }
  }

  private var scheduleIsFulfilled = false {
    didSet {
      updateFormState()
    }
  }

  private var emojiIsSelected = true // dummy for now, add didSet after implementation emojis
  private var colorIsSelected = true // dummy for now, add didSet after implementation colours

  private var formIsFulfilled = false {
    didSet {
      if formIsFulfilled {
        updateCreateButtonState()
      }
    }
  }

  // MARK: - Private global properties

  private let factory = TrackersFactory.shared
  private var selectedCategoryIndex = 0
  private var isHabit: Bool
  private var schedule = [Bool](repeating: false, count: 7)
  private var userInput = "" {
    didSet {
      print("CTVC userInput \(userInput)")
      trackerNameIsFulfilled = true
    }
  }

  // MARK: - Public properties

  weak var delegate: CreateTrackerViewControllerDelegate?

  // MARK: - Inits

  init(isHabit: Bool) {
    self.isHabit = isHabit
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Life circle

  override func viewDidLoad() {
    super.viewDidLoad()
    print("CTVC Run viewDidLoad()")
    print("CTVC isHabit \(isHabit)")
    if !isHabit {
      schedule = schedule.map { $0 || true }
      scheduleIsFulfilled = true
    }
    print("CTVC schedule for event \(schedule)")
    print("CTVC scheduleIsFulfilled \(scheduleIsFulfilled)")

    view.backgroundColor = .ypWhite
    configureUI()
    textField.delegate = self
    textField.becomeFirstResponder()
  }
}

// MARK: - Private methods

private extension CreateTrackerViewController {
  func configureUI() {
    configureTitleSection()
    configureTextFieldSection()
    configureOptionsSection()
    // configureEmojiSection() // Sprint 15
    // configureColorsSection() // Sprint 15
    configureButtonsSection()
  }

  func updateFormState() {
    formIsFulfilled = trackerNameIsFulfilled && categoryIsSelected && scheduleIsFulfilled && scheduleIsFulfilled
    && emojiIsSelected && colorIsSelected
    print("CTVC formIsFulfilled \(formIsFulfilled)")
  }

  func updateCreateButtonState() {
    createButton.backgroundColor = formIsFulfilled ? .ypBlack : .ypGray
    createButton.isEnabled = formIsFulfilled ? true : false
  }

  func fetchSchedule(from schedule: [Bool]) {
    self.schedule = schedule
    let days = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
    let weekFull = [true, true, true, true, true, true, true]
    let weekDays = [true, true, true, true, true, false, false]
    let weekEnd = [false, false, false, false, false, true, true]
    var finalSchedule: [String] = []
    switch schedule {
    case weekFull:
      scheduleButton.configure(value: "Каждый день")
    case weekDays:
      scheduleButton.configure(value: "Будни")
    case weekEnd:
      scheduleButton.configure(value: "Выходные")
    default:
      for index in 0..<schedule.count where schedule[index] {
        finalSchedule.append(days[index])
      }
      let finalScheduleJoined = finalSchedule.joined(separator: ", ")
      scheduleButton.configure(value: finalScheduleJoined)
    }
    scheduleIsFulfilled = true
  }
}

// MARK: - Private methods for button's actions

private extension CreateTrackerViewController {
  @objc func cancelButtonClicked() {
    print("CTVC Run cancelButtonClicked()")
    dismiss(animated: true)
  }

  @objc func createButtonClicked() {
    print("CTVC Run createButtonClicked()")
    let newTracker = Tracker(
      id: UUID(),
      title: userInput,
      emoji: Int.random(in: 0...17), // dummy for now
      color: Int.random(in: 0...17), // dummy for now
      schedule: schedule
    )
    delegate?.createTrackerViewController(self, didFilledTracker: newTracker, for: selectedCategoryIndex)
  }

  @objc func categoryButtonClicked() { // TODO: Make VC to select category and return it here by selectedCategoryIndex
    print("CTVC Run categoryButtonClicked()")
    selectedCategoryIndex = Int.random(in: 0..<factory.categories.count) // dummy for categoryIndex
    let selectedCategory = factory.categories[selectedCategoryIndex]
    categoryButton.configure(value: selectedCategory.name)
    categoryIsSelected = true
  }

  @objc func scheduleButtonClicked() {
    print("CTVC Run scheduleButtonClicked()")
    let nextController = ScheduleViewController(with: schedule)
    nextController.delegate = self
    present(nextController, animated: true)
  }
}

// MARK: - Private methods to configure Title section

private extension CreateTrackerViewController {
  func configureTitleSection() {
    configureTitleLabel()
    view.addSubview(titleLabel)
    configureTitleSectionConstraints()
  }

  func configureTitleLabel() {
    print("CTVC Run configureTitleSection()")
    titleLabel.text = isHabit ? Resources.Labels.newHabit : Resources.Labels.newEvent
    titleLabel.font = Resources.Fonts.titleUsual
    titleLabel.textAlignment = .center
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.frame = CGRect(
      x: 0,
      y: 0,
      width: view.frame.width,
      height: Resources.Dimensions.titleHeight + Resources.Layouts.vSpacingTitle
    )
  }

  func configureTitleSectionConstraints() {
    print("CTVC Run configureTitleSectionConstraints()")
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Resources.Layouts.vSpacingTitle),
      titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
      titleLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
    ])
  }
}

// MARK: - Private methods to configure TextField section

private extension CreateTrackerViewController {
  func configureTextFieldSection() {
    print("CTVC Run configureTextFieldSection()")
    configureTextFieldStackView()
    view.addSubview(textFieldStackView)
    configureTextField()
    configureTextFieldWarning()
    textFieldStackView.addArrangedSubview(textField)
    textFieldStackView.addArrangedSubview(textFieldWarning)
    configureTextFieldConstraints()
    configureTextFieldWarningConstraints()
    configureTextFieldStackViewConstraints()
  }

  func configureTextFieldStackView() {
    print("CTVC Run configureTextFieldStackView()")
    textFieldStackView.axis = .vertical
    textFieldStackView.distribution = .fillProportionally
    textFieldStackView.spacing = .zero
    textFieldStackView.translatesAutoresizingMaskIntoConstraints = false
  }

  func configureTextField() {
    print("CTVC Run configureTextField()")
    textField.backgroundColor = .ypBackground
    textField.layer.cornerRadius = Resources.Dimensions.cornerRadius
    textField.layer.masksToBounds = true
    textField.placeholder = Resources.Labels.textFieldPlaceholder
    textField.clearButtonMode = .whileEditing
    textField.textColor = .ypBlack
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.frame = CGRect(
      x: 0,
      y: 0,
      width: optionsViewWidth,
      height: Resources.Dimensions.fieldHeight
    )
  }

  func configureTextFieldWarning() {
    print("CTVC Run configureTextFieldWarning()")
    textFieldWarning.translatesAutoresizingMaskIntoConstraints = false
    textFieldWarning.text = Resources.Labels.textFieldRestriction
    textFieldWarning.font = Resources.Fonts.textField
    textFieldWarning.textAlignment = .center
    textFieldWarning.textColor = .ypRed
    textFieldWarning.isHidden = true
    textFieldWarning.frame = CGRect(
      x: 0,
      y: Resources.Dimensions.fieldHeight,
      width: optionsViewWidth,
      height: Resources.Dimensions.fieldHeight / 2
    )
  }

  func configureTextFieldConstraints() {
    print("CTVC Run configureTextFieldConstraints()")
    NSLayoutConstraint.activate([
      textField.topAnchor.constraint(equalTo: textFieldStackView.topAnchor),
      textField.leadingAnchor.constraint(equalTo: textFieldStackView.leadingAnchor),
      textField.trailingAnchor.constraint(equalTo: textFieldStackView.trailingAnchor),
      textField.heightAnchor.constraint(equalToConstant: Resources.Dimensions.fieldHeight)
    ])
  }

  func configureTextFieldWarningConstraints() {
    print("CTVC Run configureTextFieldWarningConstraints()")
    NSLayoutConstraint.activate([
      textFieldWarning.topAnchor.constraint(equalTo: textField.bottomAnchor),
      textFieldWarning.leadingAnchor.constraint(equalTo: textFieldStackView.leadingAnchor),
      textFieldWarning.trailingAnchor.constraint(equalTo: textFieldStackView.trailingAnchor),
      textFieldWarning.heightAnchor.constraint(equalToConstant: Resources.Dimensions.fieldHeight / 2)
    ])
  }

  func configureTextFieldStackViewConstraints() {
    print("CTVC Run configureTextFieldStackViewConstraints()")
    NSLayoutConstraint.activate([
      textFieldStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: leadSpacing),
      textFieldStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -leadSpacing),
      textFieldStackView.topAnchor.constraint(
        equalTo: titleLabel.bottomAnchor,
        constant: Resources.Layouts.vSpacingElement
      )
    ])
  }
}

// MARK: - Private methods to configure Options section

private extension CreateTrackerViewController {
  func configureOptionsSection() {
    print("CTVC Run configureOptionsSection()")
    configureOptionsView()
    view.addSubview(optionsView)
    configureOptionsSectionConstraints()
    configureCategorySubview()
    optionsView.addSubview(categoryButton)
    if isHabit {
      let borderView = BorderView()
      borderView.configure(for: optionsView, width: optionsViewWidth - Resources.Layouts.leadingElement * 2, repeat: 1)
      configureScheduleSubview()
      optionsView.addSubview(scheduleButton)
    }
  }

  func configureOptionsView() {
    print("CTVC Run configureOptionsView()")
    optionsView.backgroundColor = .ypBackground
    optionsView.layer.cornerRadius = Resources.Dimensions.cornerRadius
    optionsView.layer.masksToBounds = true
    optionsView.translatesAutoresizingMaskIntoConstraints = false
    optionsView.frame = CGRect(
      x: 0,
      y: 0,
      width: optionsViewWidth,
      height: optionsViewHeight
    )
  }

  func configureCategorySubview() {
    print("CTVC Run configureCategorySubview()")
    categoryButton.configure(title: Resources.Labels.category)
    categoryButton.addTarget(self, action: #selector(categoryButtonClicked), for: .touchUpInside)
    categoryButton.frame = CGRect(
      x: 0,
      y: 0,
      width: optionsViewWidth,
      height: Resources.Dimensions.fieldHeight
    )
  }

  func configureScheduleSubview() {
    print("CTVC Run configureScheduleSubview()")
    scheduleButton.configure(title: Resources.Labels.schedule)
    scheduleButton.addTarget(self, action: #selector(scheduleButtonClicked), for: .touchUpInside)
    scheduleButton.frame = CGRect(
      x: 0,
      y: Resources.Dimensions.fieldHeight,
      width: optionsViewWidth,
      height: Resources.Dimensions.fieldHeight
    )
  }

  func configureOptionsSectionConstraints() {
    print("CTVC Run configureOptionsSectionConstraints()")
    NSLayoutConstraint.activate([
      optionsView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: leadSpacing),
      optionsView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -leadSpacing),
      optionsView.heightAnchor.constraint(equalToConstant: optionsViewHeight),
      optionsView.topAnchor.constraint(
        equalTo: textFieldStackView.bottomAnchor,
        constant: Resources.Layouts.vSpacingElement
      )
    ])
  }
}

// MARK: - Private methods to configure Buttons section

private extension CreateTrackerViewController {
  func configureButtonsSection() {
    print("CTVC Run configureButtonsSection()")
    configureButtonsStackView()
    view.addSubview(buttonsStackView)
    configureCancelButton()
    configureCreateButton()
    updateCreateButtonState()
    buttonsStackView.addArrangedSubview(cancelButton)
    buttonsStackView.addArrangedSubview(createButton)
    configureButtonsSectionConstraints()
  }

  func configureButtonsStackView() {
    print("CTVC Run configureButtonsStackView()")
    buttonsStackView.axis = .horizontal
    buttonsStackView.backgroundColor = .ypWhite
    buttonsStackView.distribution = .fillEqually
    buttonsStackView.spacing = Resources.Layouts.hSpacingButton
    buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
  }

  func configureCancelButton() {
    print("CTVC Run configureCancelButton()")
    cancelButton.setTitle(Resources.Labels.cancel, for: .normal)
    cancelButton.setTitleColor(.ypRed, for: .normal)
    cancelButton.backgroundColor = .ypWhite
    cancelButton.layer.borderColor = UIColor.ypRed.cgColor
    cancelButton.layer.borderWidth = 1
    cancelButton.addTarget(self, action: #selector(cancelButtonClicked), for: .touchUpInside)
  }

  func configureCreateButton() {
    print("CTVC Run configureCreateButton()")
    createButton.setTitle(Resources.Labels.create, for: .normal)
    createButton.setTitleColor(.ypLightGray, for: .disabled)
    createButton.addTarget(self, action: #selector(createButtonClicked), for: .touchUpInside)
  }

  func configureButtonsSectionConstraints() {
    print("CTVC Run configureButtonsSectionConstraints()")
    NSLayoutConstraint.activate([
      buttonsStackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
      buttonsStackView.widthAnchor.constraint(equalToConstant: buttonsStackViewWidth),
      buttonsStackView.heightAnchor.constraint(equalToConstant: Resources.Dimensions.buttonHeight),
      buttonsStackView.bottomAnchor.constraint(
        equalTo: safeArea.bottomAnchor,
        constant: -Resources.Layouts.vSpacingButton
      )
    ])
  }
}

// MARK: - UITextFieldDelegate

extension CreateTrackerViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    userInput = textField.text ?? ""
    let currentCharacterCount = textField.text?.count ?? 0
    if range.length + range.location > currentCharacterCount {
      return false
    }
    let newLength = currentCharacterCount + string.count - range.length
    if newLength >= Resources.textFieldLimit {
      textFieldWarning.isHidden = false
    } else {
      textFieldWarning.isHidden = true
    }
    return newLength <= Resources.textFieldLimit
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    userInput = textField.text ?? ""
    return true
  }

  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    true
  }
}

// MARK: - ScheduleViewControllerDelegate

extension CreateTrackerViewController: ScheduleViewControllerDelegate {
  func scheduleViewController(_ viewController: ScheduleViewController, didSelectSchedule schedule: [Bool]) {
    dismiss(animated: true) {
      [weak self] in
      guard let self else { return }
      self.fetchSchedule(from: schedule)
    }
  }
}
