//
//  DummyView.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 10.10.2023.
//

import UIKit

final class EmptyView {

  func makeStack(for viewController: UIViewController, title: String, imageName: UIImage?) {

    guard let view = viewController.view else { return }

    lazy var stackView: UIStackView = {
      let stack = UIStackView()
      stack.translatesAutoresizingMaskIntoConstraints = false
      stack.axis = .vertical
      stack.spacing = 8.0
      stack.alignment = .center
      stack.distribution = .equalCentering
      [imageView, subtitleView].forEach { stack.addArrangedSubview($0) }
      return stack
    }()

    lazy var imageView: UIImageView = {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.image = imageName
      $0.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
      return $0
    }(UIImageView())


    lazy var subtitleView: UILabel = {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.text = title
      $0.textAlignment = .center
      $0.textColor = .ypBlack
      $0.font = Resources.Fonts.textNofification
      $0.frame = CGRect(x: 0, y: 0, width: view.bounds.width - 32, height: 18)
      return $0
    }(UILabel())

    view.addSubview(stackView)

    NSLayoutConstraint.activate([
      stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      imageView.widthAnchor.constraint(equalToConstant: 80),
      imageView.heightAnchor.constraint(equalToConstant: 80),
      subtitleView.widthAnchor.constraint(equalToConstant: view.bounds.width - 32),
      subtitleView.heightAnchor.constraint(equalToConstant: 18)
    ])
  }
}
