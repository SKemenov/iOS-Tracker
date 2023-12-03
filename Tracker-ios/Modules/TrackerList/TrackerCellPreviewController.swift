//
//  TrackerCellPreviewController.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 02.12.2023.
//

import UIKit

// MARK: - class

final class TrackerCellPreviewController: UIViewController {

  //  private lazy var mainView = TrackerCellMainView(
  //    frame: CGRect(
  //      origin: CGPoint(x: 0, y: 0),
  //      size: CGSize(
  //        width: view.frame.width,
  //        height: Resources.Dimensions.contentHeight
  //      )
  //    ),
  //    tracker: viewModel
  //  )

  // MARK: - Public properties

  private var viewModel: Tracker
  //  {
  //    didSet {
  //      mainView.viewModel = viewModel
  //    }
  //  }

  // MARK: - Inits
  init(with viewModel: Tracker) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    configureUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Configure TrackerCellPreviewController UI Section

  private func configureUI() {
    var mainView = TrackerCellMainView(
      frame: CGRect(
        origin: CGPoint(x: 0, y: 0),
        size: CGSize(
          width: view.frame.width,
          height: Resources.Dimensions.contentHeight
        )
      ),
      tracker: viewModel
    )

    view.addSubview(mainView)

    NSLayoutConstraint.activate([
      mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      mainView.topAnchor.constraint(equalTo: view.topAnchor),
      mainView.heightAnchor.constraint(equalToConstant: Resources.Dimensions.contentHeight)
    ])
  }
}
