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

  private let daysOfWeek = Calendar.current.weekdaySymbols.count
  private var schedule: [Bool]

  private lazy var formIsFulfilled = false {
    didSet {
      updateDoneButtonState()
    }
  }
  private lazy var isRtl = UIView.userInterfaceLayoutDirection(for: titleLabel.semanticContentAttribute) == .rightToLeft

  // MARK: - Public properties

  weak var delegate: ScheduleViewControllerDelegate?

  // MARK: - Inits

  init(with schedule: [Bool]) {
    self.schedule = schedule
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Life circle

  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    print(#function, daysOfWeek)
  }
}

// MARK: - Private methods

private extension ScheduleViewController {
  func configureUI() {
    view.backgroundColor = .ypWhite
    configureTitleSection()
    configureOptionsSection()
    configureDoneButtonSection()
  }

  func updateFormState() {
    formIsFulfilled = !schedule.filter { $0 == true }.isEmpty
  }

  func updateDoneButtonState() {
    doneButton.backgroundColor = formIsFulfilled ? .ypBlack : .ypGray
    doneButton.isEnabled = formIsFulfilled ? true : false
  }
}

// MARK: - Private methods for button's actions

private extension ScheduleViewController {
  @objc func doneButtonClicked() {
    delegate?.scheduleViewController(self, didSelectSchedule: schedule)
  }

  @objc func onSwitchChange(_ sender: UISwitch) {
    schedule[sender.tag] = sender.isOn
    updateFormState()
  }
}

// MARK: - Private methods to configure Title section

private extension ScheduleViewController {
  func configureTitleSection() {
    titleLabel.text = Resources.Labels.schedule
    titleLabel.font = Resources.Fonts.titleUsual
    titleLabel.textAlignment = .center
    titleLabel.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(titleLabel)

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
    configureOptionsView()
    view.addSubview(optionsView)
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

  func configureOptionsLabel(index: Int) {
    let label = UILabel()
    label.textColor = .ypBlack
    label.text = Resources.Labels.fullWeekDays[index]
    label.textAlignment = .natural
    label.frame = CGRect(
      x: isRtl ? -leadSpacing : leadSpacing,
      y: Resources.Dimensions.fieldHeight * CGFloat(index),
      width: optionsViewWidth,
      height: Resources.Dimensions.fieldHeight
    )
    optionsView.addSubview(label)
  }

  func configureOptionsSwitch(index: Int) {
    let daySwitch = UISwitch()
    daySwitch.isOn = schedule[index]
    daySwitch.tag = index
    daySwitch.thumbTintColor = .white
    daySwitch.onTintColor = .ypBlue
    daySwitch.tintColor = .ypLightGray
    daySwitch.addTarget(self, action: #selector(onSwitchChange(_:)), for: .touchUpInside)
    daySwitch.frame = CGRect(
      x: isRtl ? leadSpacing : optionsViewWidth - leadSpacing - switchWidth,
      y: Resources.Dimensions.fieldHeight * CGFloat(index) + switchHeight,
      width: switchWidth,
      height: switchHeight
    )
    optionsView.addSubview(daySwitch)
  }

  func configureOptionsSectionConstraints() {
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
    doneButton.setTitle(Resources.Labels.done, for: .normal)
    doneButton.setTitleColor(.ypLightGray, for: .disabled)
    doneButton.addTarget(self, action: #selector(doneButtonClicked), for: .touchUpInside)
    doneButton.translatesAutoresizingMaskIntoConstraints = false

    updateDoneButtonState()
    updateFormState()
    view.addSubview(doneButton)

    NSLayoutConstraint.activate([
      doneButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
      doneButton.widthAnchor.constraint(equalToConstant: buttonWidth),
      doneButton.heightAnchor.constraint(equalToConstant: Resources.Dimensions.buttonHeight),
      doneButton.bottomAnchor.constraint(
        equalTo: safeArea.bottomAnchor,
        constant: -Resources.Layouts.vSpacingButton
      )
    ])
  }
}
