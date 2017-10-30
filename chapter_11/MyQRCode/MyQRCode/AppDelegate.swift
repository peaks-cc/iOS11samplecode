//
//  AppDelegate.swift
//  MyQRCode
//
//  Created by Kishikawa Katsumi on 2017/09/04.
//  Copyright © 2017 Kishikawa Katsumi. All rights reserved.
//

import UIKit
import Intents

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if case INPreferences.siriAuthorizationStatus() = INSiriAuthorizationStatus.notDetermined {
            INPreferences.requestSiriAuthorization { status in
                switch status {
                case .authorized:
                    print("authorized")
                case .denied, .restricted, .notDetermined:
                    print("not authorized")
                }
            }
        }

        return true
    }
}
