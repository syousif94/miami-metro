//
//  AppDelegate.swift
//  Miami Metro
//
//  Created by Sammy Yousif on 2/9/18.
//  Copyright © 2018 Sammy Yousif. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow.init(frame: UIScreen.main.bounds)
        
        let _ = MapData()
        
        let mapViewController = MapViewController()
        
        window?.rootViewController = mapViewController
        
        window?.makeKeyAndVisible()
        
        return true
    }
}

