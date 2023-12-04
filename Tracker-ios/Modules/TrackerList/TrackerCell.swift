//
//  TrackerCell.swift
//  Tracker-ios
//  Refactored `TrackerCell`
//  Created by Sergey Kemenov on 08.10.2023.
//

import UIKit

// MARK: - Protocol
protocol TrackerCellDelegate: AnyObject {
  func trackerCellDidTapDone(for cell: TrackerCell)
}

// MARK: - Class

final class TrackerCell: UICollectionViewCell {
  // MARK: - Private properties
  private let counterLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 1
    label.textAlignment = .natural
    label.textColor = .ypBlack
    label.font = Resources.Fonts.textNotification
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let counterButton: UIButton = {
    let view = UIButton()
    view.layer.cornerRadius = Resources.Dimensions.cornerRadius
    view.layer.masksToBounds = true
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  private let counterImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = Resources.SfSymbols.addCounter
    imageView.tintColor = .ypWhite
    imageView.contentMode = .scaleAspectFill
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()

  lazy var mainView = TrackerCellMainView(
    frame: CGRect(
      origin: CGPoint(x: 0, y: 0),
      size: CGSize(
        width: contentView.frame.width,
        height: Resources.Dimensions.contentHeight
      )
    ),
    tracker: viewModel
  )

  // MARK: - Public properties

  weak var delegate: TrackerCellDelegate?

  var viewModel: Tracker? {
    didSet {
      mainView.viewModel = viewModel
      guard let colorIndex = viewModel?.color else { return }
      counterButton.backgroundColor = Resources.colors[colorIndex]
    }
  }

  var isPinned = false {
    didSet {
      mainView.isPinned = isPinned
    }
  }

  var counter = 0 {
    didSet {
      counterLabel.text = String.localizedStringWithFormat(
        NSLocalizedString("numberOfDays", comment: "Counter of total tracker's completed days"),
        counter
      )
    }
  }

  // MARK: - Inits

  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
    counterButton.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Private methods

private extension TrackerCell {
  @objc func didTapDoneButton() {
    delegate?.trackerCellDidTapDone(for: self)
  }
}

// MARK: - Public methods

extension TrackerCell {
  func makeItDone(_ isCompleted: Bool) {
    counterImageView.image = isCompleted ? Resources.SfSymbols.doneMark : Resources.SfSymbols.addCounter
    counterButton.alpha = isCompleted ? 0.7 : 1
  }

  func updateCounter(_ counter: Int) {
    counterLabel.text = String.localizedStringWithFormat(
      NSLocalizedString("numberOfDays", comment: "Counter of total tracker's completed days"),
      counter
    )
  }
}

// MARK: - Configure TrackerCell UI Section

private extension TrackerCell {
  func configureUI() {

    contentView.addSubview(mainView)
    contentView.addSubview(counterButton)
    contentView.addSubview(counterLabel)
    contentView.addSubview(counterImageView)

    let spacing = Resources.Layouts.leadingTracker

    NSLayoutConstraint.activate([
      mainView.leadingAnchor.constraint(equalTo: leadingAnchor),
      mainView.trailingAnchor.constraint(equalTo: trailingAnchor),
      mainView.topAnchor.constraint(equalTo: topAnchor),
      mainView.heightAnchor.constraint(equalToConstant: Resources.Dimensions.contentHeight),

      counterButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Resources.Layouts.leadingElement),
      counterButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -spacing),
      counterButton.widthAnchor.constraint(equalToConstant: Resources.Dimensions.cornerRadius * 2),
      counterButton.heightAnchor.constraint(equalToConstant: Resources.Dimensions.cornerRadius * 2),

      counterLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: spacing),
      counterLabel.trailingAnchor.constraint(equalTo: counterButton.leadingAnchor, constant: -spacing),
      counterLabel.centerYAnchor.constraint(equalTo: counterButton.centerYAnchor),

      counterImageView.centerXAnchor.constraint(equalTo: counterButton.centerXAnchor),
      counterImageView.centerYAnchor.constraint(equalTo: counterButton.centerYAnchor),
      counterImageView.widthAnchor.constraint(equalToConstant: spacing),
      counterImageView.heightAnchor.constraint(equalToConstant: spacing)
    ])
  }
}
