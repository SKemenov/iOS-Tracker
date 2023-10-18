//
//  DummyView.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 10.10.2023.
//

import UIKit

final class EmptyView {

  func makeStack(for viewController: UIViewController, title: String, image: UIImage?) {

    guard let view = viewController.view else { return }

    lazy var viewWidth: CGFloat = {
      view.frame.width - 2 * Resources.Layouts.leadingElement
    }()

    lazy var stackView: UIStackView = {
      let stack = UIStackView()
      stack.translatesAutoresizingMaskIntoConstraints = false
      stack.axis = .vertical
      stack.spacing = Resources.Layouts.spacingElement
      stack.alignment = .center
      stack.distribution = .equalCentering
      [imageView, subtitleView].forEach { stack.addArrangedSubview($0) }
      return stack
    }()

    lazy var imageView: UIImageView = {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.image = image
      $0.frame = CGRect(x: 0, y: 0, width: Resources.Dimensions.bigIcon, height: Resources.Dimensions.bigIcon)
      return $0
    }(UIImageView())


    lazy var subtitleView: UILabel = {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.text = title
      $0.textAlignment = .center
      $0.textColor = .ypBlack
      $0.font = Resources.Fonts.textNotification
      $0.frame = CGRect(x: 0, y: 0, width: viewWidth, height: Resources.Dimensions.notificationHeight)
      return $0
    }(UILabel())

    view.addSubview(stackView)

    NSLayoutConstraint.activate([
      stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      imageView.widthAnchor.constraint(equalToConstant: Resources.Dimensions.bigIcon),
      imageView.heightAnchor.constraint(equalToConstant: Resources.Dimensions.bigIcon),
      subtitleView.widthAnchor.constraint(equalToConstant: viewWidth),
      subtitleView.heightAnchor.constraint(equalToConstant: Resources.Dimensions.notificationHeight)
    ])
  }
}
