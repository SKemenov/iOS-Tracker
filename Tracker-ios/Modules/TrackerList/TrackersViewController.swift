//
//  TrackersViewController.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 07.10.2023.
//

import UIKit

// MARK: - Class

// swiftlint:disable file_length
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

  private var filtersButton = ActionButton()

  private lazy var safeArea: UILayoutGuide = {
    view.safeAreaLayoutGuide
  }()

  // MARK: - Private properties

  private let cellID = "cell"
  private let headerID = "header"

  private let factory = TrackersCoreDataFactory.shared
  private let analyticsService = AnalyticsService()
  private var searchBarUserInput = ""

  private var visibleCategories: [TrackerCategory] = []
  private var selectedFilterIndex = 0 {
    didSet {
      factory.selectedFilterIndex = selectedFilterIndex
    }
  }

  private var selectedDate: Date {
    factory.selectedDate
  }

  private var isVisibleCategoriesEmpty: Bool {
    return visibleCategories.filter { !$0.items.isEmpty }.isEmpty
  }

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
    // selectedDate = Date() // + TimeInterval(Resources.shiftTimeZone)

    searchBar.searchBar.delegate = self

    configureUI()
    fetchVisibleCategoriesFromFactory()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateTrackerCollectionView()
    analyticsService.report(event: "open", params: ["screen": "Main"])
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    analyticsService.report(event: "close", params: ["screen": "Main"])
  }
}

// MARK: - Private methods

private extension TrackersViewController {

  @objc func addButtonClicked() {
    analyticsService.report(event: "click", params: ["screen": "Main", "item": "add_track"])
    let nextController = NewTrackerViewController()
    nextController.modalPresentationStyle = .popover
    nextController.delegate = self
    navigationController?.present(nextController, animated: true)
  }

  @objc func datePickerValueChanged(_ sender: UIDatePicker) {
    analyticsService.report(event: "click", params: ["screen": "Main", "item": "date"])
    factory.selectedDate = sender.date
    fetchVisibleCategoriesFromFactory()
    dismiss(animated: true)
  }

  @objc func filtersButtonClicked() {
    analyticsService.report(event: "click", params: ["screen": "Main", "item": "filter"])
    let nextController = FiltersViewController(selectedFilterIndex: selectedFilterIndex)
    nextController.modalPresentationStyle = .popover
    nextController.delegate = self
    navigationController?.present(nextController, animated: true)
  }

  func updateTrackerCollectionView() {
    collectionView.reloadData()
    collectionView.collectionViewLayout.invalidateLayout()
    collectionView.layoutSubviews()
    collectionView.isHidden = isVisibleCategoriesEmpty
    filtersButton.isHidden = isVisibleCategoriesEmpty
    emptyView.isHidden = !isVisibleCategoriesEmpty
  }

  func fetchTracker(from tracker: Tracker, for categoryId: UUID) {
    factory.addNewOrUpdate(tracker: tracker, toCategory: categoryId)
    setWeekDayForTracker(with: tracker.schedule)
    fetchVisibleCategoriesFromFactory()
  }

  func updateTracker(from tracker: Tracker, for categoryId: UUID) {
    factory.update(tracker: tracker, toCategory: categoryId)
    fetchVisibleCategoriesFromFactory()
  }

  func useSelectedFilter(for index: Int) {
    selectedFilterIndex = index
    if selectedFilterIndex == 1 {
      factory.selectedDate = Date()
      datePicker.setDate(selectedDate, animated: true)
      selectedFilterIndex = 0
    }
    fetchVisibleCategoriesFromFactory()
    filtersButton.setTitleColor(selectedFilterIndex == 0 ? .ypWhite : .ypRed, for: .normal)
  }

  func setWeekDayForTracker(with schedule: [Bool]) {
    factory.setWeekDayForTracker(with: schedule)
    datePicker.setDate(selectedDate, animated: true)
  }

  func fetchVisibleCategoriesFromFactory() {
    //    clearVisibleCategories()
    visibleCategories = []
    visibleCategories = factory.visibleCategoriesForWeekDay
    updateTrackerCollectionView()
  }

  //  func clearVisibleCategories() {
  //  }

  private func searchInTrackers() {
    var newCategories: [TrackerCategory] = []
    factory.visibleCategoriesForSearch.forEach { newCategories.append(
      TrackerCategory(id: $0.id, name: $0.name, items: $0.items.filter {
        $0.title.lowercased().contains(searchBarUserInput.lowercased())
      }))
    }
    visibleCategories = newCategories.filter { !$0.items.isEmpty }
    updateTrackerCollectionView()
  }

  func makeEmptyViewForTrackers() {
    emptyView.configure(title: Resources.Labels.emptyTracker, iconImage: Resources.Images.emptyTrackers)
  }

  func makeEmptyViewForSearchBar() {
    emptyView.configure(title: Resources.Labels.emptySearch, iconImage: Resources.Images.emptySearch)
  }
}

// MARK: - UISearchBarDelegate

extension TrackersViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    searchBarUserInput = searchText
    if searchBarUserInput.count > 2 {
      makeEmptyViewForSearchBar()
      searchInTrackers()
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
    visibleCategories.count
  }

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
    cell.viewModel = currentTracker
    cell.counter = factory.countRecords(for: currentTracker.id)
    cell.makeItDone(factory.isTrackerDone(with: currentTracker.id, on: selectedDate))
    return cell
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
        as? TrackerHeader else { return TrackerHeader() }
    view.titleLabel.text = visibleCategories.isEmpty ? "" : visibleCategories[indexPath.section].name
    return view
  }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    CGSize(
      width: (
        collectionView.bounds.width - Resources.Layouts.spacingElement - 2 * Resources.Layouts.leadingElement
      ) / Resources.Layouts.trackersPerLine,
      height: Resources.Dimensions.trackerHeight
    )
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumInteritemSpacingForSectionAt section: Int
  ) -> CGFloat {
    .zero
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    .zero
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForHeaderInSection section: Int
  ) -> CGSize {
    CGSize(width: collectionView.bounds.width, height: Resources.Dimensions.sectionHeight)
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    UIEdgeInsets(
      top: .zero,
      left: Resources.Layouts.leadingElement,
      bottom: .zero,
      right: Resources.Layouts.leadingElement
    )
  }
}

// MARK: - UICollectionViewDelegate

extension TrackersViewController: UICollectionViewDelegate {
  func collectionView(
    _ collectionView: UICollectionView,
    contextMenuConfigurationForItemsAt indexPaths: [IndexPath],
    point: CGPoint
  ) -> UIContextMenuConfiguration? {
    guard !indexPaths.isEmpty else { return nil }

    let indexPath = indexPaths[0]
    let currentTracker = visibleCategories[indexPath.section].items[indexPath.row]
    let isPinned = currentTracker.isPinned
    // swiftlint:disable:next trailing_closure
    return UIContextMenuConfiguration(actionProvider: { _ in
      return UIMenu(children: [
        UIAction(
          title: Resources.Labels.contextMenuList[isPinned ? 3 : 0],
          image: isPinned ? Resources.SfSymbols.unpinTracker : Resources.SfSymbols.pinTracker
        ) { [weak self] _ in
          self?.pinCell(indexPath: indexPath)
        },
        UIAction(
          title: Resources.Labels.contextMenuList[1],
          image: Resources.SfSymbols.editTracker
        ) { [weak self] _ in
          self?.editCell(indexPath: indexPath)
        },
        UIAction(
          title: Resources.Labels.contextMenuList[2],
          image: Resources.SfSymbols.deleteTracker,
          attributes: .destructive
        ) { [weak self] _ in
          self?.deleteCell(indexPath: indexPath)
        }
      ])
    })
  }

  func collectionView(
    _ collectionView: UICollectionView,
    contextMenuConfiguration configuration: UIContextMenuConfiguration,
    highlightPreviewForItemAt indexPath: IndexPath
  ) -> UITargetedPreview? {
    guard let cell = collectionView.cellForItem(at: indexPath) as? TrackerCell else { return nil }
    return UITargetedPreview(view: cell.mainView)
  }
}

// MARK: - EditTrackerViewControllerDelegate

extension TrackersViewController: EditTrackerViewControllerDelegate {
  func editTrackerViewController(
    _ viewController: EditTrackerViewController,
    didChangedTracker tracker: Tracker,
    with categoryId: UUID
  ) {
    dismiss(animated: true) {
      [weak self] in
      guard let self else { return }
      self.updateTracker(from: tracker, for: categoryId)
    }
  }
}

// MARK: - NewTrackerViewControllerDelegate

extension TrackersViewController: NewTrackerViewControllerDelegate {
  func newTrackerViewController(
    _ viewController: NewTrackerViewController,
    didFilledTracker tracker: Tracker,
    for categoryId: UUID
  ) {
    dismiss(animated: true) {
      [weak self] in
      guard let self else { return }
      self.fetchTracker(from: tracker, for: categoryId)
    }
  }
}

// MARK: - TrackerCellDelegate

extension TrackersViewController: TrackerCellDelegate {
  func trackerCellDidTapDone(for cell: TrackerCell) {
    guard selectedDate.sameDay(Date()) || selectedDate.beforeDay(Date()) else { return }
    guard let indexPath = collectionView.indexPath(for: cell) else { return }
    let tracker = visibleCategories[indexPath.section].items[indexPath.row]
    cell.makeItDone(factory.setTrackerDone(with: tracker.id, on: selectedDate))
    cell.updateCounter(factory.countRecords(for: tracker.id))
  }
}

// MARK: - FiltersViewControllerDelegate

extension TrackersViewController: FiltersViewControllerDelegate {
  func filtersViewController(_ viewController: FiltersViewController, didSelect index: Int) {
    dismiss(animated: true) {
      [weak self] in
      guard let self else { return }
      self.useSelectedFilter(for: index)
    }
  }
}

// MARK: - Private methods to configure UI & NavigationBar section

private extension TrackersViewController {
  func pinCell(indexPath: IndexPath) {
    analyticsService.report(event: "click", params: ["screen": "Main", "item": "pin"])
    factory.setPinFor(tracker: visibleCategories[indexPath.section].items[indexPath.row])
    fetchVisibleCategoriesFromFactory()
    print(#function)
  }

  func editCell(indexPath: IndexPath) {
    analyticsService.report(event: "click", params: ["screen": "Main", "item": "edit"])
    let tracker = visibleCategories[indexPath.section].items[indexPath.row]
    let counter = factory.countRecords(for: tracker.id)
    if let category = factory.fetchCategoryByTracker(id: tracker.id) {
      let trackerToEdit = TrackerFulfilment(tracker: tracker, counter: counter, category: category)
      let nextController = EditTrackerViewController(trackerToEdit: trackerToEdit)
      nextController.delegate = self
      nextController.isModalInPresentation = true
      present(nextController, animated: true)
      print(#function)
    }
  }

  func deleteCell(indexPath: IndexPath) {
    analyticsService.report(event: "click", params: ["screen": "Main", "item": "delete"])
    factory.delete(tracker: visibleCategories[indexPath.section].items[indexPath.row])
    fetchVisibleCategoriesFromFactory()
    print(#function)
  }

  func configureUI() {
    view.backgroundColor = .ypWhite
    configureNavigationBarSection()
    configureEmptyViewSection()
    configureCollectionViewSection()
    configureFiltersButtonSection()
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
    datePicker.backgroundColor = .ypDataPicker
    datePicker.tintColor = .ypBlue
    datePicker.datePickerMode = .date
    datePicker.preferredDatePickerStyle = .compact
    datePicker.setDate(selectedDate, animated: true)
    datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
    datePicker.layer.cornerRadius = Resources.Dimensions.smallCornerRadius
    datePicker.layer.masksToBounds = true
    datePicker.translatesAutoresizingMaskIntoConstraints = false
  }
}

// MARK: - Private methods to configure Collection view section

private extension TrackersViewController {

  func configureCollectionViewSection() {
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.backgroundColor = .ypWhite
    collectionView.alwaysBounceVertical = true
    collectionView.allowsMultipleSelection = false
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.scrollIndicatorInsets = UIEdgeInsets(
      top: Resources.Layouts.indicatorInset,
      left: Resources.Layouts.indicatorInset,
      bottom: Resources.Layouts.indicatorInset,
      right: Resources.Layouts.indicatorInset
    )

    view.addSubview(collectionView)

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
    emptyView.translatesAutoresizingMaskIntoConstraints = false
    makeEmptyViewForTrackers()
    view.addSubview(emptyView)

    NSLayoutConstraint.activate([
      emptyView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: -Resources.Layouts.vSpacingLargeTitle * 2),
      emptyView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
      emptyView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
      emptyView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
    ])
  }
}

// MARK: - Private methods to configure Filters section

private extension TrackersViewController {
  func configureFiltersButtonSection() {
    filtersButton.translatesAutoresizingMaskIntoConstraints = false
    filtersButton.setTitle(Resources.Labels.filters, for: .normal)
    filtersButton.setTitleColor(.white, for: .normal)
    filtersButton.backgroundColor = .ypBlue
    filtersButton.titleLabel?.font = Resources.Fonts.textField
    filtersButton.addTarget(self, action: #selector(filtersButtonClicked), for: .touchUpInside)

    view.addSubview(filtersButton)

    NSLayoutConstraint.activate([
      filtersButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      filtersButton.widthAnchor.constraint(equalToConstant: Resources.Dimensions.filterWidth),
      filtersButton.heightAnchor.constraint(equalToConstant: Resources.Dimensions.filterHeight),
      filtersButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -Resources.Layouts.vSpacingButton)
    ])
  }
}
