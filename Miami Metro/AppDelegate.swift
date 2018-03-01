//
//  AppDelegate.swift
//  Miami Metro
//
//  Created by Sammy Yousif on 2/9/18.
//  Copyright © 2018 Sammy Yousif. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow.init(frame: UIScreen.main.bounds)
        
        FirebaseApp.configure()
        
        let _ = MapData()
        
        let mapViewController = MapViewController()
        
        window?.rootViewController = mapViewController
        
        if #available(iOS 11.0, *),
            let insets = window?.safeAreaInsets {
            UIScreen.insets =  insets
        }
        
        window?.makeKeyAndVisible()
        
        return true
    }
}

