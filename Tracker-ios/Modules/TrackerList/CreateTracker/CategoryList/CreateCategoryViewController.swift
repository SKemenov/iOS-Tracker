//
//  CreateCategoryViewController.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 21.11.2023.
//

import UIKit

// MARK: - Protocol

protocol CreateCategoryViewControllerDelegate: AnyObject {
  func createCategoryViewController(_ viewController: CreateCategoryViewController, name: String, id: UUID?)
}

// MARK: - Class

final class CreateCategoryViewController: UIViewController {
  // MARK: - Private  UI properties
  private var titleLabel: UILabel = {
    let titleLabel = UILabel()
    titleLabel.font = Resources.Fonts.titleUsual
    titleLabel.textAlignment = .center
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    return titleLabel
  }()

  private var textField: TextField = {
    let textField = TextField()
    textField.backgroundColor = .ypBackground
    textField.layer.cornerRadius = Resources.Dimensions.cornerRadius
    textField.layer.masksToBounds = true
    textField.placeholder = Resources.Labels.categoryNamePlaceholder
    textField.clearButtonMode = .whileEditing
    textField.textColor = .ypBlack
    textField.translatesAutoresizingMaskIntoConstraints = false
    return textField
  }()

  private let doneButton: ActionButton = {
    let addButton = ActionButton()
    addButton.setTitle(Resources.Labels.done, for: .normal)
    addButton.setTitleColor(.ypLightGray, for: .disabled)
    addButton.isEnabled = false
    addButton.translatesAutoresizingMaskIntoConstraints = false
    return addButton
  }()

  // MARK: - Private properties

  private let analyticsService = AnalyticsService()
  private let cellID = "CategoryCell"
  //  private var categoryName = "" {
  //    didSet {
  //      formIsFulfilled = !categoryName.isEmpty
  //    }
  //  }

  //  private var formIsFulfilled = false {
  //    didSet {
  //      if formIsFulfilled {
  //        updateAddButtonState()
  //      }
  //    }
  //  }
  private var category: TrackerCategory?
  private var categoryName: String {
    didSet {
      updateAddButtonState()
    }
  }

  private var isEdit = false
  private var categoryNameIsFilled: Bool {
    !categoryName.isEmpty
  }

  // MARK: - Public properties

  weak var delegate: CreateCategoryViewControllerDelegate?

  // MARK: - Inits

  init(category: TrackerCategory?) {
    isEdit = category != nil
    self.category = category
    self.categoryName = category?.name ?? ""
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Life circle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.hideKeyboardWhenTappedAround()
    view.backgroundColor = .ypWhite

    configureUI()

    doneButton.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
    updateAddButtonState()

    textField.delegate = self
    textField.becomeFirstResponder()
  }
}

// MARK: - Private methods

private extension CreateCategoryViewController {
  @objc func addButtonClicked() {
    analyticsService.report(event: "click", params: ["screen": "category", "item": "create"])
    if let category {
    delegate?.createCategoryViewController(self, name: categoryName, id: category.id)
      print(#function, "update")
    } else {
      delegate?.createCategoryViewController(self, name: categoryName, id: nil)
      print(#function, "create")
    }
  }

  func updateAddButtonState() {
    doneButton.backgroundColor = categoryNameIsFilled ? .ypBlack : .ypGray
    doneButton.isEnabled = categoryNameIsFilled
  }
}

// MARK: - UITextFieldDelegate

extension CreateCategoryViewController: UITextFieldDelegate {
  func textField(
    _ textField: UITextField,
    shouldChangeCharactersIn range: NSRange,
    replacementString string: String
  ) -> Bool {
    categoryName = textField.text ?? ""
    return true
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    categoryName = textField.text ?? ""
    return true
  }

  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    categoryName = textField.text ?? ""
    return true
  }
}

// MARK: - Private methods to configure UI section

private extension CreateCategoryViewController {
  func configureUI() {
    if isEdit {
      titleLabel.text = Resources.Labels.editCategory
      textField.text = categoryName
    } else {
    titleLabel.text = Resources.Labels.newCategory
    }

    view.addSubview(titleLabel)
    view.addSubview(textField)
    view.addSubview(doneButton)

    let safeArea = view.safeAreaLayoutGuide
    let vSpacing = Resources.Layouts.vSpacingElement

    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Resources.Layouts.vSpacingTitle),
      titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
      titleLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
      titleLabel.heightAnchor.constraint(equalToConstant: Resources.Dimensions.titleHeight),

      textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: vSpacing),
      textField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: vSpacing),
      textField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -vSpacing),
      textField.heightAnchor.constraint(equalToConstant: Resources.Dimensions.fieldHeight),

      doneButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: vSpacing),
      doneButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -vSpacing),
      doneButton.heightAnchor.constraint(equalToConstant: Resources.Dimensions.buttonHeight),
      doneButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -vSpacing)
    ])
  }
}
