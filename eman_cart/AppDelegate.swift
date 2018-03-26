//
//  AppDelegate.swift
//  eman_cart
//
//  Created by Peter Schmiedt on 13/03/2018.
//  Copyright © 2018 Peter Schmiedt. All rights reserved.
//

import UIKit
import ReachabilitySwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let reachability = Reachability()!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setupAppearance()
        
        return true
    }
    
    //MARL: Reachability on Background
    func applicationDidBecomeActive(_ application: UIApplication) {
        try? reachability.startNotifier()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        reachability.stopNotifier()
    }
    
    //MARK: TINT
    fileprivate func setupAppearance() {
        UIView.appearance().tintColor = UIColor(red:0.91, green:0.30, blue:0.24, alpha:1.0)
    }

}

