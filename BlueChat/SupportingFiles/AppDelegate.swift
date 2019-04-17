//
//  AppDelegate.swift
//  BlueChat
//
//  Created by Josip Rezic on 10/04/2019.
//  Copyright © 2019 Josip Rezic. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    //
    // MARK: - Variables
    //
    
    var window: UIWindow?

    //
    // MARK: - Delegate methods
    //
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureKeyboardManager()
        configureApplicationWindow()
        return true
    }
    
    //
    // MARK: - Methods
    //
    
    private final func configureKeyboardManager() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    private final func configureApplicationWindow() {
        let navigationController = UINavigationController(rootViewController: WelcomeViewController())
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
    }
}

