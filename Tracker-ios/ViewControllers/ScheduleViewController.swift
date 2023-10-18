//
//  ScheduleViewController.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 17.10.2023.
//

import UIKit

// MARK: - Protocol

protocol ScheduleViewControllerDelegate: AnyObject {
  func scheduleViewController(_ viewController: ScheduleViewController, didSelectSchedule schedule: [Bool])
}

// MARK: - Class

final class ScheduleViewController: UIViewController {
  // MARK: - Private properties
  private var titleLabel = UILabel()
  private var optionsView = UIView()
  private var doneButton = ActionButton()

  private lazy var safeArea: UILayoutGuide = {
    view.safeAreaLayoutGuide
  }()

  private lazy var buttonWidth: CGFloat = {
    view.frame.width - 2 * Resources.Layouts.leadingButton
  }()

  private lazy var optionsViewWidth: CGFloat = {
    view.frame.width - 2 * Resources.Layouts.leadingElement
  }()

  private lazy var optionsViewHeight: CGFloat = {
    return Resources.Dimensions.fieldHeight * CGFloat(daysOfWeek)
  }()

  private lazy var leadSpacing: CGFloat = {
    Resources.Layouts.leadingElement
  }()

  private lazy var switchWidth: CGFloat = {
    switchHeight * 2
  }()

  private lazy var switchHeight: CGFloat = {
    return Resources.Dimensions.fieldHeight / 3
  }()

  private let daysOfWeek = 7
  private let weekDays = [
    "Понедельник",
    "Вторник",
    "Среда",
    "Четверг",
    "Пятница",
    "Суббота",
    "Воскресенье"
  ]
  private var schedule = [Bool](repeating: false, count: 7)

  private lazy var formIsFulfilled = false {
    didSet {
      updateDoneButtonState()
    }
  }

  // MARK: - Public properties

  weak var delegate: ScheduleViewControllerDelegate?

  // MARK: - Life circle

  override func viewDidLoad() {
    super.viewDidLoad()
    // print("SVC Run viewDidLoad()")
    print("schedule \(schedule)")
    view.backgroundColor = .ypWhite
    configureUI()
  }
}

// MARK: - Private methods

private extension ScheduleViewController {
  func configureUI() {
    configureTitleSection()
    configureOptionsSection()
    configureDoneButtonSection()
  }

  func updateFormState() {
    // print("SVC Run updateFormState()")
    let trues = schedule.filter { $0 == true }.count
    formIsFulfilled = trues > 0 ? true : false
    print("trues \(trues), formIsFulfilled \(formIsFulfilled)")
  }

  func updateDoneButtonState() {
    // print("SVC Run updateDoneButtonState()")
    doneButton.backgroundColor = formIsFulfilled ? .ypBlack : .ypGray
    doneButton.isEnabled = formIsFulfilled ? true : false
  }
}

// MARK: - Private methods for button's actions

private extension ScheduleViewController {
  @objc func doneButtonClicked() {
    // print("SVC Run doneButtonClicked()")
    print("schedule \(schedule)")
    delegate?.scheduleViewController(self, didSelectSchedule: schedule)
  }

  @objc func onSwitchChange(_ sender: UISwitch) {
    // print("SVC Run onSwitchChange()")
    schedule[sender.tag] = sender.isOn
    updateFormState()
    print(" switch tapped \(sender.tag), schedule[\(sender.tag)] \(schedule[sender.tag])")
  }
}

// MARK: - Private methods to configure Title section

private extension ScheduleViewController {
  func configureTitleSection() {
    // print("SVC Run configureTitleSection()")
    titleLabel.text = Resources.Labels.schedule
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
    // print("SVC Run configureTitleSectionConstraints()")
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Resources.Layouts.vSpacingTitle),
      titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
      titleLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
    ])
  }
}

// MARK: - Private methods to configure Options section

private extension ScheduleViewController {
  func configureOptionsSection() {
    // print("SVC Run configureOptionsSection()")
    configureOptionsView()
    configureOptionsSectionConstraints()
    for day in 0..<daysOfWeek {
      configureOptionsLabel(index: day)
      configureOptionsSwitch(index: day)
    }
    let borderView = BorderView()
    borderView.configure(
      for: optionsView,
      width: optionsViewWidth - Resources.Layouts.leadingElement * 2,
      repeat: daysOfWeek - 1
    )
  }

  func configureOptionsView() {
    // print("SVC Run configureOptionsView()")
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

  func configureOptionsLabel(index: Int) {
    // print("SVC Run configureOptionsLabel()")
    let label = UILabel()
    label.frame = CGRect(
      x: leadSpacing,
      y: Resources.Dimensions.fieldHeight * CGFloat(index),
      width: optionsViewWidth,
      height: Resources.Dimensions.fieldHeight
    )
    label.textColor = .ypBlack
    label.text = weekDays[index]
    label.textAlignment = .natural
    optionsView.addSubview(label)
  }

  func configureOptionsSwitch(index: Int) {
    // print("SVC Run configureOptionsSwitch()")
    let daySwitch = UISwitch()
    daySwitch.frame = CGRect(
      x: optionsViewWidth - leadSpacing - switchWidth,
      y: Resources.Dimensions.fieldHeight * CGFloat(index) + switchHeight,
      width: switchWidth,
      height: switchHeight
    )
    daySwitch.isOn = false
    daySwitch.tag = index
    daySwitch.thumbTintColor = .ypWhite
    daySwitch.onTintColor = .ypBlue
    daySwitch.addTarget(self, action: #selector(onSwitchChange(_:)), for: .touchUpInside)
    optionsView.addSubview(daySwitch)
  }

  func configureOptionsSectionConstraints() {
    // print("SVC Run configureOptionsSectionConstraints()")
    optionsView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      optionsView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Resources.Layouts.vSpacingElement),
      optionsView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: leadSpacing),
      optionsView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -leadSpacing),
      optionsView.heightAnchor.constraint(equalToConstant: optionsViewHeight)
    ])
  }
}

// MARK: - Private methods to configure Button section

private extension ScheduleViewController {
  func configureDoneButtonSection() {
    // print("SVC Run configureDoneButtonSection()")
    configureDoneButton()
    configureDoneButtonConstraints()
  }

  func configureDoneButton() {
    // print("SVC Run configureDoneButton()")
    doneButton.setTitle(Resources.Labels.done, for: .normal)
    doneButton.setTitleColor(.ypLightGray, for: .disabled)
    doneButton.addTarget(self, action: #selector(doneButtonClicked), for: .touchUpInside)
    updateDoneButtonState()
    view.addSubview(doneButton)
  }

  func configureDoneButtonConstraints() {
    // print("SVC Run configureDoneButtonConstraints()")
    doneButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      doneButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
      doneButton.bottomAnchor.constraint(
        equalTo: safeArea.bottomAnchor,
        constant: -Resources.Layouts.vSpacingButton
      ),
      doneButton.widthAnchor.constraint(equalToConstant: buttonWidth),
      doneButton.heightAnchor.constraint(equalToConstant: Resources.Dimensions.buttonHeight)
    ])
  }
}
