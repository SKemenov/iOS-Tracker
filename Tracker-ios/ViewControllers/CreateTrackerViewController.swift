//
//  CreateTrackerViewController.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 14.10.2023.
//

import UIKit

// MARK: - Protocol
protocol CreateTrackerViewControllerDelegate: AnyObject {
  func createTrackerViewController(_ viewController: CreateTrackerViewController, didFilledTracker tracker: String)
}

final class CreateTrackerViewController: UIViewController {
  // MARK: - Private properties
  private var titleLabel = UILabel()
  private var textField = TextField()

  private var optionsView = UIView()
  private var categoryButton = OptionButton()
  private var scheduleButton = OptionButton()

  private var buttonsStackView = UIStackView()
  private var cancelButton = ActionButton()
  private var createButton = ActionButton()

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
    return isEvent ? Resources.Dimensions.fieldHeight * 2 : Resources.Dimensions.fieldHeight
  }()

  private lazy var leadSpacing: CGFloat = {
    Resources.Layouts.leadingElement
  }()

  private var isEvent = true

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

  private lazy var formIsFulfilled = false {
    didSet {
      if formIsFulfilled {
        updateCreateButtonState()
      }
    }
  }

  // MARK: - Public properties

  weak var delegate: CreateTrackerViewControllerDelegate?

  // MARK: - Inits

  init(isEvent: Bool) {
    super.init(nibName: nil, bundle: nil)
    self.isEvent = isEvent
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Life circle

  override func viewDidLoad() {
    super.viewDidLoad()
    print("CTVC Run viewDidLoad()")
    print("CTVC isEvent \(isEvent)")
    scheduleIsFulfilled = !isEvent
    print("CTVC scheduleIsFulfilled \(scheduleIsFulfilled)")

    trackerNameIsFulfilled = true
    print("CTVC trackerNameIsFulfilled \(trackerNameIsFulfilled)")

    view.backgroundColor = .ypWhite
    textField.delegate = self
    configureUI()
  }
}

// MARK: - Private methods

private extension CreateTrackerViewController {
  func configureUI() {
    configureTitleSection()
    configureTextFieldSection()
    configureOptionsSection()
    // configureEmojiSection()
    // configureColorsSection()
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
    delegate?.createTrackerViewController(self, didFilledTracker: "done")
  }

  @objc func categoryButtonClicked() {
    print("CTVC Run categoryButtonClicked()")
    categoryButton.configure(value: "Важное")
    categoryIsSelected = true
  }

  @objc func scheduleButtonClicked() {
    print("CTVC Run scheduleButtonClicked()")
    let nextController = ScheduleViewController()
    nextController.delegate = self
    present(nextController, animated: true)
  }
}

// MARK: - Private methods to configure Title section

private extension CreateTrackerViewController {
  func configureTitleSection() {
    print("CTVC Run configureTitleSection()")
    titleLabel.text = isEvent ? Resources.Labels.newHabit : Resources.Labels.newEvent
    titleLabel.font = Resources.Fonts.titleUsual
    titleLabel.textAlignment = .center
    titleLabel.frame = CGRect(
      x: 0,
      y: 0,
      width: view.frame.width,
      height: Resources.Dimensions.titleHeight + Resources.Layouts.vSpacingTitle
    )
    view.addSubview(titleLabel)
    configureTitleSectionConstraints()
  }

  func configureTitleSectionConstraints() {
    print("CTVC Run configureTitleSectionConstraints()")
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
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
    textField.frame = CGRect(
      x: 0,
      y: 0,
      width: optionsViewWidth,
      height: Resources.Dimensions.fieldHeight
    )
    textField.backgroundColor = .ypBackground
    textField.layer.cornerRadius = Resources.Dimensions.cornerRadius
    textField.layer.masksToBounds = true
    textField.placeholder = Resources.Labels.textFieldPlaceholder
    textField.clearButtonMode = .whileEditing
    textField.textColor = .ypBlack
    view.addSubview(textField)
    configureTextFieldSectionConstraints()
  }

  func configureTextFieldSectionConstraints() {
    print("CTVC Run configureTextFieldSectionConstraints()")
    textField.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Resources.Layouts.vSpacingElement),
      textField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: leadSpacing),
      textField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -leadSpacing),
      textField.heightAnchor.constraint(equalToConstant: Resources.Dimensions.fieldHeight)
    ])
  }
}

// MARK: - Private methods to configure Options section

private extension CreateTrackerViewController {
  func configureOptionsSection() {
    print("CTVC Run configureOptionsSection()")
    configureOptionsView()
    configureOptionsSectionConstraints()
    configureCategorySubview()
    if isEvent {
      let borderView = BorderView()
      borderView.configure(for: optionsView, width: optionsViewWidth - Resources.Layouts.leadingElement * 2, repeat: 1)
      configureScheduleSubview()
    }
  }

  func configureOptionsView() {
    print("CTVC Run configureOptionsView()")
    optionsView.frame = CGRect(
      x: 0,
      y: 0,
      width: optionsViewWidth,
      height: optionsViewHeight
    )
    optionsView.backgroundColor = .ypBackground
    optionsView.layer.cornerRadius = Resources.Dimensions.cornerRadius
    optionsView.layer.masksToBounds = true
    view.addSubview(optionsView)
  }

  func configureCategorySubview() {
    print("CTVC Run configureCategorySubview()")
    categoryButton.frame = CGRect(
      x: 0,
      y: 0,
      width: optionsViewWidth,
      height: Resources.Dimensions.fieldHeight
    )
    categoryButton.configure(title: Resources.Labels.category)
    categoryButton.addTarget(self, action: #selector(categoryButtonClicked), for: .touchUpInside)
    optionsView.addSubview(categoryButton)
  }

  func configureScheduleSubview() {
    print("CTVC Run configureScheduleSubview()")
    scheduleButton.frame = CGRect(
      x: 0,
      y: Resources.Dimensions.fieldHeight,
      width: optionsViewWidth,
      height: Resources.Dimensions.fieldHeight
    )
    scheduleButton.configure(title: Resources.Labels.schedule)
    scheduleButton.addTarget(self, action: #selector(scheduleButtonClicked), for: .touchUpInside)
    optionsView.addSubview(scheduleButton)
  }

  func configureOptionsSectionConstraints() {
    print("CTVC Run configureOptionsSectionConstraints()")
    optionsView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      optionsView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: Resources.Layouts.vSpacingElement),
      optionsView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: leadSpacing),
      optionsView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -leadSpacing),
      optionsView.heightAnchor.constraint(equalToConstant: optionsViewHeight)
    ])
  }
}

// MARK: - Private methods to configure Buttons section

private extension CreateTrackerViewController {
  func configureButtonsSection() {
    print("CTVC Run configureButtonsSection()")
    configureButtonsStackView()
    configureCancelButton()
    configureCreateButton()
    configureButtonsSectionConstraints()
  }

  func configureButtonsStackView() {
    print("CTVC Run configureButtonsStackView()")
    buttonsStackView.axis = .horizontal
    buttonsStackView.backgroundColor = .ypWhite
    buttonsStackView.distribution = .fillEqually
    buttonsStackView.spacing = Resources.Layouts.hSpacingButton
    view.addSubview(buttonsStackView)
  }

  func configureCancelButton() {
    print("CTVC Run configureCancelButton()")
    cancelButton.setTitle(Resources.Labels.cancel, for: .normal)
    cancelButton.setTitleColor(.ypRed, for: .normal)
    cancelButton.backgroundColor = .ypWhite
    cancelButton.layer.borderColor = UIColor.ypRed.cgColor
    cancelButton.layer.borderWidth = 1
    cancelButton.addTarget(self, action: #selector(cancelButtonClicked), for: .touchUpInside)
    buttonsStackView.addArrangedSubview(cancelButton)
  }

  func configureCreateButton() {
    print("CTVC Run configureCreateButton()")
    createButton.setTitle(Resources.Labels.create, for: .normal)
    createButton.setTitleColor(.ypLightGray, for: .disabled)
    createButton.addTarget(self, action: #selector(createButtonClicked), for: .touchUpInside)
    updateCreateButtonState()
    buttonsStackView.addArrangedSubview(createButton)
  }

  func configureButtonsSectionConstraints() {
    print("CTVC Run configureButtonsSectionConstraints()")
    buttonsStackView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      buttonsStackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
      buttonsStackView.bottomAnchor.constraint(
        equalTo: safeArea.bottomAnchor,
        constant: -Resources.Layouts.vSpacingButton
      ),
      buttonsStackView.widthAnchor.constraint(equalToConstant: buttonsStackViewWidth),
      buttonsStackView.heightAnchor.constraint(equalToConstant: Resources.Dimensions.buttonHeight)
    ])
  }
}

// MARK: - UITextFieldDelegate

extension CreateTrackerViewController: UITextFieldDelegate {
  //
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
