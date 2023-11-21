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

  private lazy var safeArea: UILayoutGuide = {
    view.safeAreaLayoutGuide
  }()

  private lazy var tableViewWidth: CGFloat = {
    view.frame.width - 2 * Resources.Layouts.leadingElement
  }()

  private lazy var collectionViewHeight: CGFloat = {
    return Resources.Dimensions.fieldHeight * CGFloat(allCategories.count)
  }()

  private lazy var vSpacing: CGFloat = {
    Resources.Layouts.vSpacingElement
  }()


  // MARK: - Private properties

  private let cellID = "CategoryCell"
  private let factory = TrackersCoreDataFactory.shared

  private var allCategories: [TrackerCategory] = []
  private var selectedCategoryId: UUID?
  private var isAllCategoriesEmpty: Bool {
    allCategories.isEmpty
  }

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
    configureConstraints()
    addButton.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
    fetchAllCategoriesFromFactory()
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(CategoryCell.self, forCellReuseIdentifier: cellID)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateCategoryCollectionView()
  }
}


// MARK: - Private methods

private extension CategoryViewController {
  func updateCategoryCollectionView() {
    tableView.reloadData()
    tableView.isHidden = isAllCategoriesEmpty
    emptyView.isHidden = !tableView.isHidden
  }

  func fetchAllCategoriesFromFactory() {
    allCategories = []
    allCategories = factory.allCategories
    updateCategoryCollectionView()
  }

  func makeEmptyViewForCategories() {
    emptyView.translatesAutoresizingMaskIntoConstraints = false
    emptyView.configure(
      title: Resources.Labels.emptyCategory,
      iconImage: Resources.Images.emptyTrackers
    )
  }

  @objc func addButtonClicked() {
    factory.addToStoreNew(category: TrackerCategory(id: UUID(), name: "1", items: []))
    fetchAllCategoriesFromFactory()
  }
}

// MARK: - UITableViewDelegate

extension CategoryViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
    selectedCategoryId = allCategories[indexPath.row].id
    tableView.reloadData()
    delegate?.categoryViewController(self, didSelect: allCategories[indexPath.row])
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return isAllCategoriesEmpty ? .zero : Resources.Dimensions.fieldHeight
  }
}

// MARK: - UITableViewDataSource

extension CategoryViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    allCategories.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? CategoryCell else {
      return UITableViewCell()
    }
    let currentCategory = allCategories[indexPath.row]
    let isLastCell = indexPath.row == allCategories.count - 1

    cell.configureCell(
      for: CategoryCellViewModel(
        name: currentCategory.name,
        isFirst: indexPath.row == 0,
        isLast: isLastCell,
        isSelected: currentCategory.id == selectedCategoryId
      )
    )

    if isLastCell {
      cell.separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0)
    } else {
      cell.separatorInset = UIEdgeInsets(
        top: .zero,
        left: Resources.Layouts.leadingButton,
        bottom: .zero,
        right: Resources.Layouts.leadingButton
      )
    }
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
  }

  func configureConstraints() {
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

      addButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
      addButton.widthAnchor.constraint(equalToConstant: view.frame.width - 2 * Resources.Layouts.leadingButton),
      addButton.heightAnchor.constraint(equalToConstant: Resources.Dimensions.buttonHeight),
      addButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -vSpacing)
    ])
  }
}
