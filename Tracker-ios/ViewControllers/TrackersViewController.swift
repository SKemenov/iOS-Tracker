//
//  ViewController.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 07.10.2023.
//

import UIKit

// MARK: - Class

final class TrackersViewController: UIViewController {
  // MARK: - Private properties

  private let cellId = "cell"
  private let factory = TrackersFactory.shared

  private let addButton = UIButton()
  private let datePicker = UIDatePicker()
  private var emptyView = EmptyView()

  private lazy var safeArea: UILayoutGuide = {
    view.safeAreaLayoutGuide
  }()

  private lazy var collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.register(TrackerCell.self, forCellWithReuseIdentifier: cellId)
    return collectionView
  }()

  private var searchBar: UISearchController = {
    $0.hidesNavigationBarDuringPresentation = false
    $0.searchBar.placeholder = Resources.Labels.searchBar
    $0.searchBar.setValue(Resources.Labels.cancel, forKey: "cancelButtonText")
    return $0
  }(UISearchController(searchResultsController: nil))

  private var searchBarUserInput = "" {
    didSet {
      print("TVC searchBarUserInput \(searchBarUserInput)")
    }
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

    setupMockCategory()
    print("TVC categories \(factory.categories)")
    print("TVC categories[0] \(factory.categories[0])")

    searchBar.searchBar.searchTextField.delegate = self

    setupNavigationBar()
    setupAddButton()
    setupDatePicker()
    configureEmptyViewSection()
    setupCollectionView()
    updateTrackerCollectionView()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    print("TVC Run viewWillAppear()")
    updateTrackerCollectionView()
  }
}


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
    let selectedDate = Resources.dateFormatter.string(from: sender.date)
    print("Selected date is \(selectedDate)")
    dismiss(animated: true)
  }

  func updateTrackerCollectionView() {
    emptyView.isHidden = !factory.trackers.isEmpty
    collectionView.isHidden = factory.trackers.isEmpty
    collectionView.reloadData()
    print("TVC trackers.count \(factory.trackers.count), trackers.isEmpty \(factory.trackers.isEmpty)")
    print("emptyView.isHidden \(emptyView.isHidden)")
  }

  func fetchTracker(from tracker: String) {
    // print("TVC run fetchTracker() with tracker value \(tracker)")
    addMockTracker()
    updateTrackerCollectionView()
  }

  func setupNavigationBar() {
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

  func setupAddButton() {
    addButton.tintColor = .ypBlack
    addButton.setImage(Resources.SfSymbols.addTracker, for: .normal)
    addButton.frame = CGRect(x: 0, y: 0, width: 42, height: 42)
    addButton.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
    addButton.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(addButton)
  }

  func setupDatePicker() {
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
    view.addSubview(datePicker)
  }

  func setupCollectionView() {
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.backgroundColor = .ypWhite
    view.addSubview(collectionView)

    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Resources.Layouts.vSpacingElement),
      collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
      collectionView.leadingAnchor.constraint(
        equalTo: safeArea.leadingAnchor,
        constant: Resources.Layouts.leadingElement
      ),
      collectionView.trailingAnchor.constraint(
        equalTo: safeArea.trailingAnchor,
        constant: -Resources.Layouts.leadingElement
      )
    ])
  }
}

// MARK: - Private methods to configure EmptyView section

private extension TrackersViewController {
  func configureEmptyViewSection() {
    print("TVC Run configureEmptyViewSection()")
    emptyView.translatesAutoresizingMaskIntoConstraints = false
    emptyView.iconImageView.image = Resources.Images.dummyTrackers
    emptyView.primaryLabel.text = "Что будем отслеживать?"
    view.addSubview(emptyView)
    configureEmptyViewSectionConstraints()
  }

  func configureEmptyViewSectionConstraints() {
    print("TVC Run configureEmptyViewSectionConstraints()")
    emptyView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      emptyView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: -Resources.Layouts.vSpacingLargeTitle * 2),
      emptyView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
      emptyView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
      emptyView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
    ])
  }
}

// MARK: - UITextFieldDelegate

extension TrackersViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    searchBarUserInput = textField.text ?? ""
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

// MARK: - UICollectionViewDataSource

extension TrackersViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    print("TVC trackers.count \(factory.trackers.count)")
    return factory.trackers.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? TrackerCell else {
      return UICollectionViewCell()
    }
    cell.titleView.backgroundColor = Resources.colors[factory.trackers[indexPath.row].color]
    cell.counterView.backgroundColor = Resources.colors[factory.trackers[indexPath.row].color]
    cell.titleLabel.text = factory.trackers[indexPath.row].title
    cell.emojiLabel.text = Resources.emojis[factory.trackers[indexPath.row].emoji]
    cell.counterLabel.text = "\(indexPath.row) дня(дней)"
    return cell
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
}

// MARK: - NewTrackerViewControllerDelegate

extension TrackersViewController: NewTrackerViewControllerDelegate {
  func newTrackerViewController(_ viewController: NewTrackerViewController, didFilledTracker tracker: String) {
    dismiss(animated: true) {
      [weak self] in
      guard let self else { return }
      self.fetchTracker(from: tracker)
    }  }
}

// MARK: - Mock methods

private extension TrackersViewController {
  func setupMockCategory() {
    factory.categories.append(TrackerCategory(id: UUID(), name: "Важное"))
  }

  func addMockTracker() {
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

    factory.trackers.append(mockTrackers[Int.random(in: 0..<mockTrackers.count)])
    print("TVC trackers \(factory)")
  }
}
