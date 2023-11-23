//
//  UserDefaults+Extension.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 23.11.2023.
//

import Foundation

extension UserDefaults {
  private enum UserDefaultsKeys: String {
    case hasOnboarded
  }

  var hasOnboarded: Bool {
    get {
      bool(forKey: UserDefaultsKeys.hasOnboarded.rawValue)
    }
    set {
      setValue(newValue, forKey: UserDefaultsKeys.hasOnboarded.rawValue)
    }
  }
}
