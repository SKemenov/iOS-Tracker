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
    return Resources.Dimensions.fieldHeight * CGFloat(viewModel.categories.count)
  }()

  private lazy var vSpacing: CGFloat = {
    Resources.Layouts.vSpacingElement
  }()


  // MARK: - Private properties

  private let cellID = "CategoryCell"
  // private let factory = TrackersCoreDataFactory.shared
  private var viewModel = CategoryViewModel()

  // private var allCategories: [TrackerCategory] = []
  private var selectedCategoryId: UUID?
  //  private var isAllCategoriesEmpty: Bool {
  //    viewModel.categories.isEmpty
  //  }

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

    // fetchAllCategoriesFromFactory()

    viewModel.onChange = updateCategoryCollectionView

    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(CategoryCell.self, forCellReuseIdentifier: cellID)
    addButton.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
  }

  //  override func viewWillAppear(_ animated: Bool) {
  //    print(#fileID, #function)
  //    super.viewWillAppear(animated)
  //    // fetchAllCategoriesFromFactory()
  //  }
}


// MARK: - Private methods

private extension CategoryViewController {
  func updateCategoryCollectionView() {
    print(#fileID, #function)
    tableView.reloadData()
    tableView.isHidden = viewModel.categories.isEmpty
    emptyView.isHidden = !tableView.isHidden
  }

  //  func fetchAllCategoriesFromFactory() {
  //    print(#fileID, #function)
  //    allCategories = []
  //    allCategories = factory.allCategories
  //    updateCategoryCollectionView()
  //  }

  func makeEmptyViewForCategories() {
    emptyView.translatesAutoresizingMaskIntoConstraints = false
    emptyView.configure(
      title: Resources.Labels.emptyCategory,
      iconImage: Resources.Images.emptyTrackers
    )
  }

  @objc func addButtonClicked() {
    print(#fileID, #function)
    let nextController = CreateCategoryViewController()
    nextController.delegate = self
    present(nextController, animated: true)
    // tableView.reloadData()
    // fetchAllCategoriesFromFactory()
  }
}

// MARK: - CreateCategoryViewControllerDelegate

extension CategoryViewController: CreateCategoryViewControllerDelegate {
  func createCategoryViewController(_ viewController: CreateCategoryViewController, didFilledCategory category: TrackerCategory) {
    dismiss(animated: true) { [weak self] in
      guard let self else { return }
      self.viewModel.addCategory(category)
      // self.updateCategoryCollectionView()
    }
  }
}

// MARK: - UITableViewDelegate

extension CategoryViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
    selectedCategoryId = viewModel.categories[indexPath.row].id
    // tableView.reloadData()
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
    //    let isLastCell = indexPath.row == viewModel.categories.count - 1

    cell.configureCell(
      for: CategoryCellViewModel(
        name: currentCategory.name,
        isFirst: indexPath.row == 0,
        isLast: indexPath.row == viewModel.categories.count - 1,
        isSelected: currentCategory.id == selectedCategoryId
      )
    )

    //    if isLastCell {
    //      cell.separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0)
    //    } else {
    //      cell.separatorInset = UIEdgeInsets(
    //        top: .zero,
    //        left: Resources.Layouts.leadingButton,
    //        bottom: .zero,
    //        right: Resources.Layouts.leadingButton
    //      )
    //    }
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
