//
//  UIColor+Extensions.swift
//  Tracker-ios
//
//  Created by Sergey Kemenov on 08.10.2023.
//

import UIKit

#if swift(>=5.9)
// don't need to use UIColor's extension

#elseif swift(>=5.8)
// use this UIColor's extension:

extension UIColor {
  static var ypBackground: UIColor { UIColor(named: "ypBackground") ?? UIColor.darkGray }
  static var ypBlack: UIColor { UIColor(named: "ypBlack") ?? UIColor.black }
  static var ypBlue: UIColor { UIColor(named: "ypBlue") ?? UIColor.blue }
  static var ypGray: UIColor { UIColor(named: "ypGray") ?? UIColor.gray }
  static var ypRed: UIColor { UIColor(named: "ypRed") ?? UIColor.red }
  static var ypLightGray: UIColor { UIColor(named: "ypLightGray") ?? UIColor.lightGray }
  static var ypWhite: UIColor { UIColor(named: "ypWhite") ?? UIColor.white }
  static var ypWhiteAlpha: UIColor { UIColor(named: "ypWhiteAlpha") ?? UIColor.lightGray }
  static var ypDataPicker: UIColor { UIColor(named: "ypDataPicker") ?? UIColor.lightGray }
  static var ypSelection01: UIColor { UIColor(named: "ypSelection01") ?? UIColor.blue }
  static var ypSelection02: UIColor { UIColor(named: "ypSelection02") ?? UIColor.blue }
  static var ypSelection03: UIColor { UIColor(named: "ypSelection03") ?? UIColor.blue }
  static var ypSelection04: UIColor { UIColor(named: "ypSelection04") ?? UIColor.blue }
  static var ypSelection05: UIColor { UIColor(named: "ypSelection05") ?? UIColor.blue }
  static var ypSelection06: UIColor { UIColor(named: "ypSelection06") ?? UIColor.blue }
  static var ypSelection07: UIColor { UIColor(named: "ypSelection07") ?? UIColor.blue }
  static var ypSelection08: UIColor { UIColor(named: "ypSelection08") ?? UIColor.blue }
  static var ypSelection09: UIColor { UIColor(named: "ypSelection09") ?? UIColor.blue }
  static var ypSelection10: UIColor { UIColor(named: "ypSelection10") ?? UIColor.green }
  static var ypSelection11: UIColor { UIColor(named: "ypSelection11") ?? UIColor.green }
  static var ypSelection12: UIColor { UIColor(named: "ypSelection12") ?? UIColor.green }
  static var ypSelection13: UIColor { UIColor(named: "ypSelection13") ?? UIColor.green }
  static var ypSelection14: UIColor { UIColor(named: "ypSelection14") ?? UIColor.green }
  static var ypSelection15: UIColor { UIColor(named: "ypSelection15") ?? UIColor.green }
  static var ypSelection16: UIColor { UIColor(named: "ypSelection16") ?? UIColor.green }
  static var ypSelection17: UIColor { UIColor(named: "ypSelection17") ?? UIColor.green }
  static var ypSelection18: UIColor { UIColor(named: "ypSelection18") ?? UIColor.green }
}
#endif
