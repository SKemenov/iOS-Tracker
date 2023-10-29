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
  private let factory = TrackersFactory.shared

  private var searchBarUserInput = "" {
    didSet {
      print("TVC searchBarUserInput \(searchBarUserInput)")
    }
  }

  private var visibleCategories: [TrackerCategory] = []
  private enum Search {
    case text
    case weekday
  }

  // MARK: - Public properties

  var currentDate = Date()

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
    view.backgroundColor = .ypWhite

    // print("Current time is \(currentDate)")
    setupMockCategory()

    searchBar.searchBar.searchTextField.delegate = self
    searchBar.searchBar.delegate = self

    configureUI()
    updateTrackerCollectionView()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    // print("TVC Run viewWillAppear()")
    updateTrackerCollectionView()
  }
}

// MARK: - Private methods

private extension TrackersViewController {

  @objc func addButtonClicked() {
    print("TVC Run addButtonClicked()")
    let nextController = NewTrackerViewController()
    // nextController.providesPresentationContextTransitionStyle = true
    // nextController.definesPresentationContext = true
    nextController.modalPresentationStyle = .popover
    nextController.delegate = self
    navigationController?.present(nextController, animated: true)
  }

  @objc func datePickerValueChanged(_ sender: UIDatePicker) {
    currentDate = sender.date
    let weekday = currentDate.weekday()
    print("Selected date is \(currentDate), Current weekday is \(weekday)")
    searchInTrackers(.weekday)
    dismiss(animated: true)
  }

  func updateTrackerCollectionView() {
    collectionView.reloadData()
    collectionView.collectionViewLayout.invalidateLayout()
    collectionView.layoutSubviews()
    collectionView.isHidden = visibleCategories.isEmpty
    emptyView.isHidden = !collectionView.isHidden
  }

  func fetchTracker(from tracker: String, for categoryIndex: Int) {
    // print("TVC run fetchTracker() with tracker value \(tracker)")
    let tracker = addMockTracker()
    factory.addTracker(tracker, toCategory: categoryIndex)
    fetchVisibleCategoriesFromFactory()
    updateTrackerCollectionView()
  }

  func fetchVisibleCategoriesFromFactory() {
    clearVisibleCategories()
    for eachCategory in factory.categories where !eachCategory.items.isEmpty {
      visibleCategories.append(eachCategory)
    }
    updateTrackerCollectionView()
  }

  func clearVisibleCategories() {
    visibleCategories = []
  }

  private func searchInTrackers(_ type: Search) {
    let weekday = currentDate.weekday()
    let currentCategories = factory.categories
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

// MARK: - UITextFieldDelegate

extension TrackersViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    searchBarUserInput = textField.text ?? ""
    if searchBarUserInput.count > 2 {
      searchInTrackers(.text)
    }
    print("TVC now textField.text is \(String(describing: textField.text))")
    print("TVC searchBarUserInput set to \(searchBarUserInput)")
    return true
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    searchBarUserInput = textField.text ?? ""
    print("TVC textField.text \(String(describing: textField.text))")
    print("TVC searchBarUserInput set to \(searchBarUserInput)")
    return true
  }

  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    true
  }
}

// MARK: - UISearchBarDelegate

extension TrackersViewController: UISearchBarDelegate {
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    print("TVC run searchBarCancelButtonClicked()")
    searchBar.text = nil
    searchBar.endEditing(true)
    makeEmptyViewForTrackers()
    fetchVisibleCategoriesFromFactory()
  }
}


// MARK: - UICollectionViewDataSource

extension TrackersViewController: UICollectionViewDataSource {

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    print("TVC visibleCategories.count \(visibleCategories.count)")
    return visibleCategories.count
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return visibleCategories.isEmpty ? 0 : visibleCategories[section].items.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    print("TVC Run cellForItemAt()")
    guard
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? TrackerCell else {
      return UICollectionViewCell()
    }
    let currentTracker = visibleCategories[indexPath.section].items[indexPath.row]
    let counterSettings = factory.getCounter(with: currentTracker.id, on: currentDate)
    let totalCounter = counterSettings.0
    let isCompleted = counterSettings.1
    cell.delegate = self
    cell.configureCell(
      bgColor: Resources.colors[currentTracker.color],
      emoji: Resources.emojis[currentTracker.emoji],
      title: currentTracker.title,
      counter: totalCounter
    )
    cell.makeItDone(isCompleted)
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
      width: (collectionView.bounds.width - Resources.Layouts.spacingElement) / Resources.Layouts.trackersPerLine,
      height: Resources.Dimensions.trackerHeight
    )
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    CGSize(width: collectionView.bounds.width, height: Resources.Dimensions.sectionHeight)
  }
}

// MARK: - NewTrackerViewControllerDelegate

extension TrackersViewController: NewTrackerViewControllerDelegate {
  func newTrackerViewController(_ viewController: NewTrackerViewController, didFilledTracker tracker: String, for categoryIndex: Int) {
    dismiss(animated: true) {
      [weak self] in
      guard let self else { return }
      self.fetchTracker(from: tracker, for: categoryIndex)
    }  }
}

// MARK: - TrackerCellDelegate

extension TrackersViewController: TrackerCellDelegate {
  func trackerCellDidTapDone(for cell: TrackerCell) {
    print("TVC Run trackerCellDidTapDone()")
    guard currentDate < Date() else {
      print("TVC currentDate \(currentDate) more than \(Date()), abort")
      return
    }
    print("TVC currentDate \(currentDate) less than \(Date()), continue")
    print("TVC visibleCategories \(visibleCategories)")
    guard let indexPath = collectionView.indexPath(for: cell) else { return }
    print("TVC indexPath \(indexPath)")
    let currentCategory = visibleCategories[indexPath.section]
    print("TVC currentCategory \(currentCategory)")
    let tracker = visibleCategories[indexPath.section].items[indexPath.row]
    print("TVC tracker \(tracker)")
    let counter = factory.setTrackerDone(with: tracker.id, on: currentDate)
    cell.updateCounter(counter.0)
    cell.makeItDone(counter.1)
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
    datePicker.tintColor = .ypBlack
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
  }

  func configureCollectionViewConstraints() {
    let leading = Resources.Layouts.leadingElement
    NSLayoutConstraint.activate([
      // collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Resources.Layouts.vSpacingElement),
      collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
      collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
      collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: leading),
      collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -leading)
    ])
  }
}

// MARK: - Private methods to configure EmptyView section

private extension TrackersViewController {
  func configureEmptyViewSection() {
    // print("TVC Run configureEmptyViewSection()")
    configureEmptyView()
    makeEmptyViewForTrackers()
    view.addSubview(emptyView)
    configureEmptyViewSectionConstraints()
  }

  func configureEmptyView() {
    // print("TVC Run configureEmptyView()")
    emptyView.translatesAutoresizingMaskIntoConstraints = false
  }

  func configureEmptyViewSectionConstraints() {
    // print("TVC Run configureEmptyViewSectionConstraints()")
    NSLayoutConstraint.activate([
      emptyView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: -Resources.Layouts.vSpacingLargeTitle * 2),
      emptyView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
      emptyView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
      emptyView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
    ])
  }
}

// MARK: - Mock methods

private extension TrackersViewController {
  func setupMockCategory() {
    factory.addNew(category: TrackerCategory(id: UUID(), name: "Важное", items: []))
    factory.addNew(category: TrackerCategory(id: UUID(), name: "Нужное", items: []))
  }

  func addMockTracker() -> Tracker {
    // MARK: - Mock Properties
    let mockTrackers: [Tracker] = [
      Tracker(
        id: UUID(),
        title: "test test test all days test test",
        emoji: Int.random(in: 0...17),
        color: Int.random(in: 0...17),
        schedule: [true, true, true, true, true, true, true]
      ),
      Tracker(
        id: UUID(),
        title: "test test test weekdays test test",
        emoji: Int.random(in: 0...17),
        color: Int.random(in: 0...17),
        schedule: [true, true, true, true, true, false, false]
      ),
      Tracker(
        id: UUID(),
        title: "test test test weekend test test",
        emoji: Int.random(in: 0...17),
        color: Int.random(in: 0...17),
        schedule: [false, false, false, false, false, true, true]
      ),
      Tracker(
        id: UUID(),
        title: "test test some days test test test",
        emoji: Int.random(in: 0...17),
        color: Int.random(in: 0...17),
        schedule: [true, false, true, false, true, false, true]
      ),
      Tracker(
        id: UUID(),
        title: "test test a few days test test test",
        emoji: Int.random(in: 0...17),
        color: Int.random(in: 0...17),
        schedule: [false, false, true, false, false, true, false]
      )
    ]

    return mockTrackers[Int.random(in: 0..<mockTrackers.count)]
    // print("TVC trackers \(factory)")
  }
}
