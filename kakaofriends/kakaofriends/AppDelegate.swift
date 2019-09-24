//
//  AppDelegate.swift
//  kakaofriends
//
//  Created by 유태건 on 22/09/2019.
//  Copyright © 2019 pyimagesearch. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // create the user interface window and make it visible
        window = UIWindow()
        window?.makeKeyAndVisible()
        
        // create the view controller and root view controller
        let vc = ViewController()
        window?.rootViewController = vc
        
        // return true upon success
        return true
    }

}

