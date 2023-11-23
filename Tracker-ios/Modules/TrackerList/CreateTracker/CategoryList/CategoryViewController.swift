//
//  CategoryViewController.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 19.11.2023.
//

import UIKit

// MARK: - Protocol

protocol CategoryViewControllerDelegate: AnyObject {
  func categoryViewController(_ viewController: CategoryViewController, didSelect category: TrackerCategory)
}

// MARK: - Class

final class CategoryViewController: UIViewController {
  // MARK: - Private UI properties
  private var titleLabel: UILabel = {
    let titleLabel = UILabel()
    titleLabel.text = Resources.Labels.category
    titleLabel.font = Resources.Fonts.titleUsual
    titleLabel.textAlignment = .center
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    return titleLabel
  }()

  private var emptyView = EmptyView()
  private let addButton: ActionButton = {
    let addButton = ActionButton()
    addButton.setTitle(Resources.Labels.addCategory, for: .normal)
    addButton.translatesAutoresizingMaskIntoConstraints = false
    return addButton
  }()

  private let tableView: UITableView = {
    let tableView = UITableView()
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.layer.cornerRadius = Resources.Dimensions.cornerRadius
    tableView.isScrollEnabled = true
    tableView.allowsSelection = true
    tableView.separatorColor = .ypGray
    return tableView
  }()

  // MARK: - Private properties

  private let cellID = "CategoryCell"
  private var viewModel = CategoryViewModel()
  private var selectedCategoryId: UUID?

  // MARK: - Public properties

  weak var delegate: CategoryViewControllerDelegate?

  // MARK: - Inits


  init(selectedCategoryId: UUID) {
    super.init(nibName: nil, bundle: nil)
    self.selectedCategoryId = selectedCategoryId
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Life circle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.hideKeyboardWhenTappedAround()
    view.backgroundColor = .ypWhite

    makeEmptyViewForCategories()
    configureUI()
    updateCategoryCollectionView()

    viewModel.onChange = updateCategoryCollectionView

    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(CategoryCell.self, forCellReuseIdentifier: cellID)
    addButton.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
  }
}

// MARK: - Private methods

private extension CategoryViewController {
  func updateCategoryCollectionView() {
    tableView.reloadData()
    tableView.isHidden = viewModel.categories.isEmpty
    emptyView.isHidden = !tableView.isHidden
  }

  func makeEmptyViewForCategories() {
    emptyView.translatesAutoresizingMaskIntoConstraints = false
    emptyView.configure(
      title: Resources.Labels.emptyCategory,
      iconImage: Resources.Images.emptyTrackers
    )
  }

  @objc func addButtonClicked() {
    let nextController = CreateCategoryViewController()
    nextController.delegate = self
    present(nextController, animated: true)
  }
}

// MARK: - CreateCategoryViewControllerDelegate

extension CategoryViewController: CreateCategoryViewControllerDelegate {
  func createCategoryViewController(
    _ viewController: CreateCategoryViewController,
    didFilledCategory category: TrackerCategory
  ) {
    dismiss(animated: true) { [weak self] in
      guard let self else { return }
      self.viewModel.addCategory(category)
    }
  }
}

// MARK: - UITableViewDelegate

extension CategoryViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
    selectedCategoryId = viewModel.categories[indexPath.row].id
    delegate?.categoryViewController(self, didSelect: viewModel.categories[indexPath.row])
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return viewModel.categories.isEmpty ? .zero : Resources.Dimensions.fieldHeight
  }
}

// MARK: - UITableViewDataSource

extension CategoryViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.categories.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? CategoryCell else {
      return UITableViewCell()
    }
    let currentCategory = viewModel.categories[indexPath.row]
    cell.configureCell(
      for: CategoryCellViewModel(
        name: currentCategory.name,
        isFirst: indexPath.row == 0,
        isLast: indexPath.row == viewModel.categories.count - 1,
        isSelected: currentCategory.id == selectedCategoryId
      )
    )
    return cell
  }
}

// MARK: - Private methods to configure UI section

private extension CategoryViewController {
  func configureUI() {
    view.addSubview(titleLabel)
    view.addSubview(emptyView)
    view.addSubview(tableView)
    view.addSubview(addButton)

    let safeArea = view.safeAreaLayoutGuide
    let vSpacing = Resources.Layouts.vSpacingElement

    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Resources.Layouts.vSpacingTitle),
      titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
      titleLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
      titleLabel.heightAnchor.constraint(equalToConstant: Resources.Dimensions.titleHeight),

      tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: vSpacing),
      tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -vSpacing),
      tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: vSpacing),
      tableView.bottomAnchor.constraint(lessThanOrEqualTo: addButton.topAnchor, constant: -vSpacing),

      emptyView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: vSpacing),
      emptyView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
      emptyView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
      emptyView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -vSpacing),

      addButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: vSpacing),
      addButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -vSpacing),
      //   addButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
      //   addButton.widthAnchor.constraint(equalToConstant: view.frame.width - 2 * Resources.Layouts.leadingButton),
      addButton.heightAnchor.constraint(equalToConstant: Resources.Dimensions.buttonHeight),
      addButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -vSpacing)
    ])
  }
}
