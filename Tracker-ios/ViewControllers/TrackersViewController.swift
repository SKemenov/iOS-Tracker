//
//  TrackersViewController.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 07.10.2023.
//

import UIKit

// swift lint:disable file_length

// MARK: - Class

final class TrackersViewController: UIViewController {
  // MARK: - Private UI properties

  private let addButton = UIButton()
  private let datePicker = UIDatePicker()
  private var emptyView = EmptyView()

  private lazy var collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    collectionView.register(TrackerCell.self, forCellWithReuseIdentifier: cellID)
    collectionView.register(
      TrackerHeader.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: headerID
    )
    return collectionView
  }()

  private var searchBar: UISearchController = {
    $0.hidesNavigationBarDuringPresentation = false
    $0.searchBar.placeholder = Resources.Labels.searchBar
    $0.searchBar.setValue(Resources.Labels.cancel, forKey: "cancelButtonText")
    $0.searchBar.searchTextField.clearButtonMode = .never
    return $0
  }(UISearchController(searchResultsController: nil))

  private lazy var safeArea: UILayoutGuide = {
    view.safeAreaLayoutGuide
  }()

  // MARK: - Private properties

  private let cellID = "cell"
  private let headerID = "header"

  private let factory = TrackersCoreDataFactory.shared
  private let trackerCategoryStore = TrackerCategoryStore.shared
  private let trackerStore = TrackerStore()

  private var searchBarUserInput = ""

  private var visibleCategories: [TrackerCategory] = []
  private var weekday = 0

  private var currentDate = Date() {
    didSet {
      weekday = currentDate.weekday()
    }
  }
  private var isVisibleCategoriesEmpty: Bool {
    var isEmpty = true
    visibleCategories.forEach { category in
      if !category.items.isEmpty {
        isEmpty = false
      }
    }
    return isEmpty
  }

  private enum Search {
    case text
    case weekday
  }

  // MARK: - Public properties


  // MARK: - Inits

  init() {
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
    currentDate = Date() // + TimeInterval(Resources.shiftTimeZone)

    searchBar.searchBar.delegate = self
    trackerStore.delegate = self

    configureUI()
    visibleCategories = trackerCategoryStore.visibleCategories
    updateTrackerCollectionView()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateTrackerCollectionView()
  }
}

// MARK: - Private methods

private extension TrackersViewController {

  @objc func addButtonClicked() {
    let nextController = NewTrackerViewController()
    nextController.modalPresentationStyle = .popover
    nextController.delegate = self
    navigationController?.present(nextController, animated: true)
  }

  @objc func datePickerValueChanged(_ sender: UIDatePicker) {
    currentDate = sender.date
    searchInTrackers(.weekday)
    dismiss(animated: true)
  }

  func updateTrackerCollectionView() {
    collectionView.reloadData()
    collectionView.collectionViewLayout.invalidateLayout()
    collectionView.layoutSubviews()
    collectionView.isHidden = isVisibleCategoriesEmpty
    emptyView.isHidden = !collectionView.isHidden
  }

  func fetchTracker(from tracker: Tracker, for categoryIndex: Int) {
    factory.addToStoreNew(tracker: tracker, toCategory: categoryIndex)
    fetchVisibleCategoriesFromFactory()
  }

  func fetchVisibleCategoriesFromFactory() {
    clearVisibleCategories()
    visibleCategories = trackerCategoryStore.visibleCategories
    updateTrackerCollectionView()
  }

  func clearVisibleCategories() {
    visibleCategories = []
  }

  private func searchInTrackers(_ type: Search) {
    let currentCategories = trackerCategoryStore.visibleCategories
    var newCategories: [TrackerCategory] = []
    clearVisibleCategories()
    for eachCategory in currentCategories {
      var currentTrackers: [Tracker] = []
      let trackers = eachCategory.items.count
      for index in 0..<trackers {
        let tracker = eachCategory.items[index]
        switch type {
        case .text:
          let tracker = eachCategory.items[index]
          if tracker.title.lowercased().contains(searchBarUserInput.lowercased()) {
            currentTrackers.append(tracker)
          }
        case .weekday:
          let trackerHaveThisDay = tracker.schedule[weekday - 1]
          if trackerHaveThisDay {
            currentTrackers.append(tracker)
          }
        }
      }
      if !currentTrackers.isEmpty {
        newCategories.append(
          TrackerCategory(
            id: eachCategory.id,
            name: eachCategory.name,
            items: currentTrackers
          )
        )
      }
    }
    visibleCategories = newCategories
    if !visibleCategories.isEmpty {
      makeEmptyViewForSearchBar()
    }
    updateTrackerCollectionView()
  }

  func makeEmptyViewForTrackers() {
    emptyView.configure(
      title: Resources.Labels.emptyTracker,
      iconImage: Resources.Images.emptyTrackers
    )
  }

  func makeEmptyViewForSearchBar() {
    emptyView.configure(
      title: Resources.Labels.emptySearch,
      iconImage: Resources.Images.emptySearch
    )
  }
}

// MARK: - UISearchBarDelegate

extension TrackersViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    searchBarUserInput = searchText
    if searchBarUserInput.count > 2 {
      makeEmptyViewForSearchBar()
      searchInTrackers(.text)
    }
  }

  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.text = nil
    searchBar.endEditing(true)
    makeEmptyViewForTrackers()
    fetchVisibleCategoriesFromFactory()
  }
}

// MARK: - UICollectionViewDataSource

extension TrackersViewController: UICollectionViewDataSource {

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    visibleCategories.count  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return isVisibleCategoriesEmpty
    ? 0
    : visibleCategories[section].items.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? TrackerCell else {
      return UICollectionViewCell()
    }
    let currentTracker = visibleCategories[indexPath.section].items[indexPath.row]
    cell.delegate = self
    cell.configureCell(
      bgColor: Resources.colors[currentTracker.color],
      emoji: Resources.emojis[currentTracker.emoji],
      title: currentTracker.title,
      counter: factory.getRecordsCounter(with: currentTracker.id)
    )
    cell.makeItDone(factory.isTrackerDone(with: currentTracker.id, on: currentDate))
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    var id: String
    switch kind {
    case UICollectionView.elementKindSectionHeader:
      id = headerID
    default:
      id = ""
    }
    guard
      let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath)
        as? TrackerHeader else { return TrackerHeader() }
    view.titleLabel.text = visibleCategories.isEmpty ? "" : visibleCategories[indexPath.section].name
    return view
  }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    CGSize(
      width: (
        collectionView.bounds.width - Resources.Layouts.spacingElement - 2 * Resources.Layouts.leadingElement
      ) / Resources.Layouts.trackersPerLine,
      height: Resources.Dimensions.trackerHeight
    )
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    .zero
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    .zero
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    CGSize(width: collectionView.bounds.width, height: Resources.Dimensions.sectionHeight)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    UIEdgeInsets(
      top: .zero,
      left: Resources.Layouts.leadingElement,
      bottom: .zero,
      right: Resources.Layouts.leadingElement
    )
  }
}

// MARK: - TrackerCategoryStoreDelegate

extension TrackersViewController: TrackerCategoryStoreDelegate {
  func trackerCategoryStore(didUpdate update: TrackerCategoryStoreUpdate) {
    visibleCategories = trackerCategoryStore.visibleCategories
    if let indexPath = update.updatedSectionIndexes.first {
      collectionView.reloadItems(inSection: Int(indexPath))
    }
    collectionView.insertSections(update.insertedSectionIndexes)
    collectionView.deleteSections(update.deletedSectionIndexes)
  }
}

// MARK: - TrackerStoreDelegate

extension TrackersViewController: TrackerStoreDelegate {
  func trackerStore(didUpdate update: TrackerStoreUpdate) {
    visibleCategories = trackerCategoryStore.visibleCategories
    collectionView.performBatchUpdates {
      collectionView.reloadItems(at: update.updatedIndexes)
      collectionView.insertItems(at: update.insertedIndexes)
      collectionView.deleteItems(at: update.deletedIndexes)
    }
  }
}

// MARK: - NewTrackerViewControllerDelegate

extension TrackersViewController: NewTrackerViewControllerDelegate {
  func newTrackerViewController(_ viewController: NewTrackerViewController, didFilledTracker tracker: Tracker, for categoryIndex: Int) {
    dismiss(animated: true) {
      [weak self] in
      guard let self else { return }
      self.fetchTracker(from: tracker, for: categoryIndex)
    }
  }
}

// MARK: - TrackerCellDelegate

extension TrackersViewController: TrackerCellDelegate {
  func trackerCellDidTapDone(for cell: TrackerCell) {
    guard
      Calendar.current.compare(currentDate, to: Date(), toGranularity: .day) == .orderedAscending
        || Calendar.current.compare(currentDate, to: Date(), toGranularity: .day) == .orderedSame
    else { return }
    guard let indexPath = collectionView.indexPath(for: cell) else { return }
    let tracker = visibleCategories[indexPath.section].items[indexPath.row]
    guard tracker.schedule[weekday - 1] else { return }
    cell.makeItDone(factory.setTrackerDone(with: tracker.id, on: currentDate))
    cell.updateCounter(factory.getRecordsCounter(with: tracker.id))
  }
}

// MARK: - Private methods to configure UI & NavigationBar section

private extension TrackersViewController {

  func configureUI() {
    configureNavigationBarSection()
    configureEmptyViewSection()
    configureCollectionViewSection()
  }

  func configureNavigationBarSection() {
    configureNavigationBar()
    configureAddButton()
    view.addSubview(addButton)
    configureDatePicker()
    view.addSubview(datePicker)
  }

  func configureNavigationBar() {
    guard
      let navigatorBar = navigationController?.navigationBar,
      let topItem = navigatorBar.topItem
    else { return }

    let addButtonItem = UIBarButtonItem(customView: addButton)
    let dateSelectorButton = UIBarButtonItem(customView: datePicker)

    navigationItem.hidesSearchBarWhenScrolling = false
    navigatorBar.prefersLargeTitles = true

    topItem.title = Resources.Labels.trackers
    topItem.titleView?.tintColor = .ypBlack
    topItem.searchController = searchBar
    topItem.setRightBarButton(dateSelectorButton, animated: true)
    topItem.setLeftBarButton(addButtonItem, animated: true)
  }

  func configureAddButton() {
    addButton.tintColor = .ypBlack
    addButton.setImage(Resources.SfSymbols.addTracker, for: .normal)
    addButton.frame = CGRect(x: 0, y: 0, width: 42, height: 42)
    addButton.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
    addButton.translatesAutoresizingMaskIntoConstraints = false
  }

  func configureDatePicker() {
    datePicker.sizeThatFits(CGSize(width: 77, height: 64))
    datePicker.backgroundColor = .ypBackground
    datePicker.tintColor = .ypBlue
    datePicker.datePickerMode = .date
    datePicker.preferredDatePickerStyle = .compact
    datePicker.locale = Locale(identifier: "ru_RU")
    datePicker.setDate(currentDate, animated: true)
    datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
    datePicker.layer.cornerRadius = Resources.Dimensions.smallCornerRadius
    datePicker.layer.masksToBounds = true
    datePicker.translatesAutoresizingMaskIntoConstraints = false
  }
}

// MARK: - Private methods to configure Collection view section

private extension TrackersViewController {

  func configureCollectionViewSection() {
    configureCollectionView()
    view.addSubview(collectionView)
    configureCollectionViewConstraints()
  }

  func configureCollectionView() {
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.backgroundColor = .ypWhite
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.scrollIndicatorInsets = UIEdgeInsets(
      top: Resources.Layouts.indicatorInset,
      left: Resources.Layouts.indicatorInset,
      bottom: Resources.Layouts.indicatorInset,
      right: Resources.Layouts.indicatorInset
    )
  }

  func configureCollectionViewConstraints() {
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
      collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
      collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
    ])
  }
}

// MARK: - Private methods to configure EmptyView section

private extension TrackersViewController {
  func configureEmptyViewSection() {
    configureEmptyView()
    makeEmptyViewForTrackers()
    view.addSubview(emptyView)
    configureEmptyViewSectionConstraints()
  }

  func configureEmptyView() {
    emptyView.translatesAutoresizingMaskIntoConstraints = false
  }

  func configureEmptyViewSectionConstraints() {
    NSLayoutConstraint.activate([
      emptyView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: -Resources.Layouts.vSpacingLargeTitle * 2),
      emptyView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
      emptyView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
      emptyView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
    ])
  }
}

extension UICollectionView {
  func reloadItems(inSection section: Int) {
    reloadItems(at: (0..<numberOfItems(inSection: section)).map {
      IndexPath(item: $0, section: section)
    })
  }
}
