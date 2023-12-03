//
//  CreateTrackerViewController.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 14.10.2023.
//

import UIKit

// swiftlint:disable file_length
// MARK: - Protocol

protocol CreateTrackerViewControllerDelegate: AnyObject {
  func createTrackerViewController(
    _ viewController: CreateTrackerViewController,
    didFilledTracker tracker: Tracker,
    for categoryId: UUID
  )
}

// MARK: - Class

final class CreateTrackerViewController: UIViewController {
  // MARK: - Private  UI properties
  private var titleLabel = UILabel()

  private var mainScrollView = UIScrollView()
  private var contentView = UIStackView()

  private var textFieldStackView = UIStackView()
  private var textField = TextField()
  private var textFieldWarning = UILabel()

  private var optionsView = UIView()
  private var categoryButton = OptionButton()
  private var scheduleButton = OptionButton()

  private lazy var emojiCollectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    collectionView.register(EmojiCell.self, forCellWithReuseIdentifier: emojiCellID)
    collectionView.register(
      OptionCellHeader.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: headerID
    )
    return collectionView
  }()

  private lazy var colorCollectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    collectionView.register(ColorCell.self, forCellWithReuseIdentifier: colorCellID)
    collectionView.register(
      OptionCellHeader.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: headerID
    )
    return collectionView
  }()

  private var buttonsStackView = UIStackView()
  private var cancelButton = ActionButton()
  private var createButton = ActionButton()
  private lazy var isRtl = UIView.userInterfaceLayoutDirection(for: titleLabel.semanticContentAttribute) == .rightToLeft

  // MARK: - Private layout properties

  private lazy var safeArea: UILayoutGuide = {
    view.safeAreaLayoutGuide
  }()

  private lazy var buttonsStackViewWidth: CGFloat = {
    view.frame.width - 2 * Resources.Layouts.leadingButton
  }()

  private lazy var optionsViewWidth: CGFloat = {
    view.frame.width - 2 * leadSpacing
  }()

  private lazy var optionsViewHeight: CGFloat = {
    isHabit ? Resources.Dimensions.fieldHeight * 2 : Resources.Dimensions.fieldHeight
  }()

  private lazy var leadSpacing: CGFloat = {
    Resources.Layouts.leadingElement
  }()

  private lazy var scrollViewHeight: CGFloat = {
    let collectionViewsHeight = (Resources.Dimensions.optionViewHeight + Resources.Dimensions.optionHeader) * 2
    let buttonsHeight = Resources.Dimensions.buttonHeight
    let spacingHeight = Resources.Layouts.vSpacingSection * 5
    let textFieldHeight = Resources.Dimensions.fieldHeight
    return textFieldHeight + optionsViewHeight + collectionViewsHeight + buttonsHeight + spacingHeight
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

  private var emojiIsSelected = false {
    didSet {
      updateFormState()
    }
  }

  private var colorIsSelected = false {
    didSet {
      updateFormState()
    }
  }

  private var formIsFulfilled = false {
    didSet {
      if formIsFulfilled {
        updateCreateButtonState()
      }
    }
  }

  // MARK: - Private global properties
  private let emojiCellID = "emojiCellId"
  private let colorCellID = "colorCellId"
  private let headerID = "header"

  private let factory = TrackersCoreDataFactory.shared
  private var isHabit: Bool
  private var schedule = [Bool](repeating: false, count: 7)
  private var userInput = "" {
    didSet {
      trackerNameIsFulfilled = true
    }
  }
  private var selectedCategoryId = UUID() {
    didSet {
      categoryIsSelected = true
    }
  }
  private var emojiIndex = 0 {
    didSet {
      emojiIsSelected = true
    }
  }
  private var colorIndex = 0 {
    didSet {
      colorIsSelected = true
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
    self.hideKeyboardWhenTappedAround()
    if !isHabit {
      schedule = schedule.map { $0 || true }
      scheduleIsFulfilled = true
    }
    configureUI()
    textField.delegate = self
    textField.becomeFirstResponder()
  }
}

// MARK: - Private methods

private extension CreateTrackerViewController {
  func configureUI() {
    view.backgroundColor = .ypWhite
    configureTitleSection()
    configureMainScrollViewSection()
    configureTextFieldSection()
    configureOptionsSection()
    configureEmojiSection()
    configureColorSection()
    configureButtonsSection()
  }

  func updateFormState() {
    formIsFulfilled = trackerNameIsFulfilled && categoryIsSelected && scheduleIsFulfilled && scheduleIsFulfilled
    && emojiIsSelected && colorIsSelected
  }

  func updateCreateButtonState() {
    createButton.backgroundColor = formIsFulfilled ? .ypBlack : .ypGray
    createButton.isEnabled = formIsFulfilled
  }

  func fetchSchedule(from schedule: [Bool]) {
    self.schedule = schedule
    let everyDays = [true, true, true, true, true, true, true]
    let weekDays = [true, true, true, true, true, false, false]
    let weekEnds = [false, false, false, false, false, true, true]
    switch schedule {
    case everyDays:
      scheduleButton.configure(value: Resources.Labels.everyDays)
    case weekDays:
      scheduleButton.configure(value: Resources.Labels.weekDays)
    case weekEnds:
      scheduleButton.configure(value: Resources.Labels.weekEnds)
    default:
      var finalSchedule: [String] = []
      for index in 0..<schedule.count where schedule[index] {
        finalSchedule.append(Resources.Labels.shortWeekDays[index])
        // finalSchedule.append(Calendar.current.shortWeekdaySymbols[index])
      }
      let finalScheduleJoined = finalSchedule.joined(separator: ", ")
      scheduleButton.configure(value: finalScheduleJoined)
    }
    scheduleIsFulfilled = true
  }
}

// MARK: - UITextFieldDelegate

extension CreateTrackerViewController: UITextFieldDelegate {
  func textField(
    _ textField: UITextField,
    shouldChangeCharactersIn range: NSRange,
    replacementString string: String
  ) -> Bool {
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
    userInput = textField.text ?? ""
    return true
  }
}

// MARK: - Private methods for button's actions

private extension CreateTrackerViewController {
  @objc func cancelButtonClicked() {
    dismiss(animated: true)
  }

  @objc func createButtonClicked() {
    let newTracker = Tracker(
      id: UUID(),
      title: userInput,
      emoji: emojiIndex,
      color: colorIndex,
      isPinned: false,
      schedule: schedule
    )
    delegate?.createTrackerViewController(self, didFilledTracker: newTracker, for: selectedCategoryId)
  }

  @objc func categoryButtonClicked() {
    let nextController = CategoryViewController(selectedCategoryId: selectedCategoryId)
    nextController.delegate = self
    present(nextController, animated: true)
  }

  @objc func scheduleButtonClicked() {
    let nextController = ScheduleViewController(with: schedule)
    nextController.delegate = self
    present(nextController, animated: true)
  }
}

// MARK: - ScheduleViewControllerDelegate

extension CreateTrackerViewController: ScheduleViewControllerDelegate {
  func scheduleViewController(_ viewController: ScheduleViewController, didSelectSchedule schedule: [Bool]) {
    dismiss(animated: true) { [weak self] in
      guard let self else { return }
      self.fetchSchedule(from: schedule)
    }
  }
}

// MARK: - CategoryViewControllerDelegate

extension CreateTrackerViewController: CategoryViewControllerDelegate {
  func categoryViewController(_ viewController: CategoryViewController, didSelect category: TrackerCategory) {
    dismiss(animated: true) {
      [weak self] in
      guard let self else { return }
      self.selectedCategoryId = category.id
      self.categoryButton.configure(value: category.name)
    }
  }
}

// MARK: - UICollectionViewDataSource

extension CreateTrackerViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch collectionView.tag {
    case 0:
      return Resources.emojis.count
    case 1:
      return Resources.colors.count
    default:
      return .zero
    }
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch collectionView.tag {
    case 0:
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: emojiCellID, for: indexPath)
        as? EmojiCell else { return UICollectionViewCell() }
      cell.backgroundColor = .ypWhite
      cell.layer.cornerRadius = Resources.Dimensions.cornerRadius
      cell.layer.masksToBounds = true
      cell.configureCell(emoji: Resources.emojis[indexPath.row])
      return cell
    case 1:
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: colorCellID, for: indexPath)
        as? ColorCell else { return UICollectionViewCell() }
      cell.layer.cornerRadius = Resources.Dimensions.smallCornerRadius
      cell.layer.masksToBounds = true
      cell.configureCell(bgColor: Resources.colors[indexPath.row])
      return cell
    default:
      return UICollectionViewCell()
    }
  }

  func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    var id: String
    switch kind {
    case UICollectionView.elementKindSectionHeader:
      id = headerID
    default:
      id = ""
    }
    guard
      let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath)
        as? OptionCellHeader else { return OptionCellHeader() }
    switch collectionView.tag {
    case 0:
      view.configure(header: Resources.Labels.emoji)
    case 1:
      view.configure(header: Resources.Labels.color)
    default:
      break
    }
    return view
  }
}

// MARK: - UICollectionViewDelegate

extension CreateTrackerViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    switch collectionView.tag {
    case 0:
      emojiIndex = indexPath.row
      collectionView.cellForItem(at: indexPath)?.backgroundColor = .ypLightGray
    case 1:
      colorIndex = indexPath.row
      collectionView.cellForItem(at: indexPath)?.backgroundColor = Resources.colors[colorIndex].withAlphaComponent(0.3)
    default:
      break
    }
  }

  func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    collectionView.cellForItem(at: indexPath)?.backgroundColor = .ypWhite
  }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CreateTrackerViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    CGSize(
      width: Resources.Dimensions.optionCell,
      height: Resources.Dimensions.optionCell
    )
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumInteritemSpacingForSectionAt section: Int
  ) -> CGFloat {
    let cellsPerLine = Resources.Layouts.optionCellPerLine
    let totalCellsWidth = cellsPerLine * Resources.Dimensions.optionCell
    return (collectionView.frame.width - 2 * leadSpacing - totalCellsWidth) / (cellsPerLine - 1) - 1
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    switch collectionView.tag {
    case 1:
      return 5
    default:
      return .zero
    }
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForHeaderInSection section: Int
  ) -> CGSize {
    CGSize(width: collectionView.bounds.width, height: Resources.Dimensions.optionHeader)
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    UIEdgeInsets(
      top: leadSpacing,
      left: leadSpacing,
      bottom: leadSpacing,
      right: leadSpacing
    )
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
    titleLabel.text = isHabit ? Resources.Labels.newHabit : Resources.Labels.newEvent
    titleLabel.font = Resources.Fonts.titleUsual
    titleLabel.textAlignment = .center
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    //    titleLabel.frame = CGRect(
    //      x: 0,
    //      y: 0,
    //      width: view.frame.width,
    //      height: Resources.Dimensions.titleHeight + Resources.Layouts.vSpacingTitle
    //    )
  }

  func configureTitleSectionConstraints() {
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Resources.Layouts.vSpacingTitle),
      titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
      titleLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
    ])
  }
}

// MARK: - Private methods to configure mainScrollView (and contentView) section

private extension CreateTrackerViewController {
  func configureMainScrollViewSection() {
    configureMainScrollView()
    configureContentView()
    view.addSubview(mainScrollView)
    mainScrollView.addSubview(contentView)
    configureMainScrollViewConstraints()
  }

  func configureMainScrollView() {
    mainScrollView.translatesAutoresizingMaskIntoConstraints = false
    mainScrollView.contentSize = CGSize(
      width: view.frame.width,
      height: scrollViewHeight
    )
  }

  func configureContentView() {
    contentView.translatesAutoresizingMaskIntoConstraints = false
    contentView.axis = .vertical
    contentView.spacing = Resources.Layouts.vSpacingElement
  }

  func configureMainScrollViewConstraints() {
    NSLayoutConstraint.activate([
      mainScrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
      mainScrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
      mainScrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
      mainScrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
    ])
  }

  func configureContentViewConstraints() {
    NSLayoutConstraint.activate([
      contentView.topAnchor.constraint(equalTo: mainScrollView.topAnchor),
      contentView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
      contentView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor),
      contentView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor)
    ])
  }
}


// MARK: - Private methods to configure TextField section

private extension CreateTrackerViewController {
  func configureTextFieldSection() {
    configureTextFieldStackView()
    contentView.addArrangedSubview(textFieldStackView)
    configureTextField()
    configureTextFieldWarning()
    textFieldStackView.addArrangedSubview(textField)
    textFieldStackView.addArrangedSubview(textFieldWarning)
    configureTextFieldConstraints()
    configureTextFieldWarningConstraints()
    configureTextFieldStackViewConstraints()
  }

  func configureTextFieldStackView() {
    textFieldStackView.axis = .vertical
    textFieldStackView.distribution = .fillProportionally
    textFieldStackView.spacing = .zero
    textFieldStackView.translatesAutoresizingMaskIntoConstraints = false
  }

  func configureTextField() {
    textField.backgroundColor = .ypBackground
    textField.layer.cornerRadius = Resources.Dimensions.cornerRadius
    textField.layer.masksToBounds = true
    textField.placeholder = Resources.Labels.textFieldPlaceholder
    textField.clearButtonMode = .whileEditing
    textField.textColor = .ypBlack
    textField.textAlignment = isRtl ? .right : .natural
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.frame = CGRect(
      x: 0,
      y: 0,
      width: optionsViewWidth,
      height: Resources.Dimensions.fieldHeight
    )
  }

  func configureTextFieldWarning() {
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
    NSLayoutConstraint.activate([
      textField.topAnchor.constraint(equalTo: textFieldStackView.topAnchor),
      textField.leadingAnchor.constraint(equalTo: textFieldStackView.leadingAnchor),
      textField.trailingAnchor.constraint(equalTo: textFieldStackView.trailingAnchor),
      textField.heightAnchor.constraint(equalToConstant: Resources.Dimensions.fieldHeight)
    ])
  }

  func configureTextFieldWarningConstraints() {
    NSLayoutConstraint.activate([
      textFieldWarning.topAnchor.constraint(equalTo: textField.bottomAnchor),
      textFieldWarning.leadingAnchor.constraint(equalTo: textFieldStackView.leadingAnchor),
      textFieldWarning.trailingAnchor.constraint(equalTo: textFieldStackView.trailingAnchor),
      textFieldWarning.heightAnchor.constraint(equalToConstant: Resources.Dimensions.fieldHeight / 2)
    ])
  }

  func configureTextFieldStackViewConstraints() {
    NSLayoutConstraint.activate([
      textFieldStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadSpacing),
      textFieldStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -leadSpacing),
      textFieldStackView.topAnchor.constraint(
        equalTo: contentView.topAnchor,
        constant: Resources.Layouts.vSpacingElement
      )
    ])
  }
}

// MARK: - Private methods to configure Options section

private extension CreateTrackerViewController {
  func configureOptionsSection() {
    configureOptionsView()
    contentView.addArrangedSubview(optionsView)
    configureOptionsSectionConstraints()
    configureCategorySubview()
    optionsView.addSubview(categoryButton)
    if isHabit {
      let borderView = BorderView()
      borderView.configure(for: optionsView, width: optionsViewWidth - leadSpacing * 2, repeat: 1)
      configureScheduleSubview()
      optionsView.addSubview(scheduleButton)
    }
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

  func configureCategorySubview() {
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
    NSLayoutConstraint.activate([
      optionsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadSpacing),
      optionsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -leadSpacing),
      optionsView.heightAnchor.constraint(equalToConstant: optionsViewHeight)
    ])
  }
}

// MARK: - Private methods to configure Emoji section

private extension CreateTrackerViewController {
  func configureEmojiSection() {
    emojiCollectionView.dataSource = self
    emojiCollectionView.delegate = self
    emojiCollectionView.tag = 0
    emojiCollectionView.isScrollEnabled = false
    emojiCollectionView.translatesAutoresizingMaskIntoConstraints = false

    contentView.addArrangedSubview(emojiCollectionView)

    NSLayoutConstraint.activate([
      emojiCollectionView.heightAnchor.constraint(equalToConstant: Resources.Dimensions.optionViewHeight),
      emojiCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      emojiCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
  }
}

// MARK: - Private methods to configure color section

private extension CreateTrackerViewController {
  func configureColorSection() {
    colorCollectionView.dataSource = self
    colorCollectionView.delegate = self
    colorCollectionView.tag = 1
    colorCollectionView.isScrollEnabled = false
    colorCollectionView.translatesAutoresizingMaskIntoConstraints = false

    contentView.addArrangedSubview(colorCollectionView)

    NSLayoutConstraint.activate([
      colorCollectionView.heightAnchor.constraint(equalToConstant: Resources.Dimensions.optionViewHeight),
      colorCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      colorCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
  }
}

// MARK: - Private methods to configure Buttons section

private extension CreateTrackerViewController {
  func configureButtonsSection() {
    configureButtonsStackView()
    contentView.addArrangedSubview(buttonsStackView)
    configureCancelButton()
    configureCreateButton()
    updateCreateButtonState()
    buttonsStackView.addArrangedSubview(cancelButton)
    buttonsStackView.addArrangedSubview(createButton)
    configureButtonsSectionConstraints()
  }

  func configureButtonsStackView() {
    buttonsStackView.axis = .horizontal
    buttonsStackView.backgroundColor = .ypWhite
    buttonsStackView.distribution = .fillEqually
    buttonsStackView.spacing = Resources.Layouts.hSpacingButton
    buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
  }

  func configureCancelButton() {
    cancelButton.setTitle(Resources.Labels.cancel, for: .normal)
    cancelButton.setTitleColor(.ypRed, for: .normal)
    cancelButton.backgroundColor = .ypWhite
    cancelButton.layer.borderColor = UIColor.ypRed.cgColor
    cancelButton.layer.borderWidth = 1
    cancelButton.addTarget(self, action: #selector(cancelButtonClicked), for: .touchUpInside)
  }

  func configureCreateButton() {
    createButton.setTitle(Resources.Labels.create, for: .normal)
    createButton.setTitleColor(.ypLightGray, for: .disabled)
    createButton.addTarget(self, action: #selector(createButtonClicked), for: .touchUpInside)
  }

  func configureButtonsSectionConstraints() {
    NSLayoutConstraint.activate([
      buttonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      buttonsStackView.widthAnchor.constraint(equalToConstant: buttonsStackViewWidth),
      buttonsStackView.heightAnchor.constraint(equalToConstant: Resources.Dimensions.buttonHeight),
      buttonsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ])
  }
}
