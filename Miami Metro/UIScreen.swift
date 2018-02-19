//
//  UIScreen.swift
//  Miami Metro
//
//  Created by Sammy Yousif on 2/18/18.
//  Copyright © 2018 Sammy Yousif. All rights reserved.
//

import UIKit

extension UIScreen {
    static var insets: UIEdgeInsets {
        get {
            guard let window = UIApplication.shared.keyWindow else { return UIEdgeInsets.zero }
            if #available(iOS 11.0, *) {
                return window.safeAreaInsets
            }
            else {
                guard let rootController = window.rootViewController else { return UIEdgeInsets.zero }
                return UIEdgeInsets(top: rootController.topLayoutGuide.length, left: 0, bottom: 0, right: 0)
            }
        }
    }
}
