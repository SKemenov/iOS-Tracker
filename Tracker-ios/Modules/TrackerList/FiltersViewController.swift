//
//  FiltersViewController.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 27.11.2023.
//

import UIKit

// MARK: - Protocol

protocol FiltersViewControllerDelegate: AnyObject {
  func filtersViewController(_ viewController: FiltersViewController, didSelect index: Int)
}

// MARK: - Class

final class FiltersViewController: UIViewController {
  // MARK: - Private UI properties
  private var titleLabel: UILabel = {
    let titleLabel = UILabel()
    titleLabel.text = Resources.Labels.filters
    titleLabel.font = Resources.Fonts.titleUsual
    titleLabel.textAlignment = .center
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    return titleLabel
  }()

  private let tableView: UITableView = {
    let tableView = UITableView()
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.layer.cornerRadius = Resources.Dimensions.cornerRadius
    tableView.isScrollEnabled = false
    tableView.allowsSelection = true
    tableView.separatorColor = .ypGray
    return tableView
  }()

  // MARK: - Private properties

  private let cellID = "FilterCell"
  private var selectedFilterIndex: Int?

  // MARK: - Public properties

  weak var delegate: FiltersViewControllerDelegate?

  // MARK: - Inits

  init(selectedFilterIndex: Int) {
    super.init(nibName: nil, bundle: nil)
    self.selectedFilterIndex = selectedFilterIndex
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Life circle

  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    configureTableView()
  }
}

// MARK: - UITableViewDelegate

extension FiltersViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
    selectedFilterIndex = indexPath.row
    delegate?.filtersViewController(self, didSelect: indexPath.row)
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return Resources.Labels.filtersList.isEmpty ? .zero : Resources.Dimensions.fieldHeight
  }
}

// MARK: - UITableViewDataSource

extension FiltersViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    Resources.Labels.filtersList.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? CategoryCell else {
      return UITableViewCell()
    }
    cell.configureCell(
      for: CategoryCellViewModel(
        name: Resources.Labels.filtersList[indexPath.row],
        isFirst: indexPath.row == 0,
        isLast: indexPath.row == Resources.Labels.filtersList.count - 1,
        isSelected: indexPath.row == selectedFilterIndex
      )
    )
    return cell
  }
}

// MARK: - Private methods to configure tableView & UI section

private extension FiltersViewController {
  func configureTableView() {
    tableView.reloadData()
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(CategoryCell.self, forCellReuseIdentifier: cellID)
  }

  func configureUI() {
    view.backgroundColor = .ypWhite
    view.addSubview(titleLabel)
    view.addSubview(tableView)

    let safeArea = view.safeAreaLayoutGuide
    let vSpacing = Resources.Layouts.vSpacingElement
    let height = Resources.Dimensions.fieldHeight * CGFloat(Resources.Labels.filtersList.count)

    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Resources.Layouts.vSpacingTitle),
      titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
      titleLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
      titleLabel.heightAnchor.constraint(equalToConstant: Resources.Dimensions.titleHeight),

      tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: vSpacing),
      tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -vSpacing),
      tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: vSpacing),
      tableView.heightAnchor.constraint(equalToConstant: height)
    ])
  }
}
