//
//  AppDelegate.swift
//  rakutencard-Man
//
//  Created by Yoshio on 2018/08/30.
//  Copyright © 2018年 tukuyo. All rights reserved.
//

import UIKit
import ARKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if !ARFaceTrackingConfiguration.isSupported {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "unsupportedMesseage")
        }
        return true
    }

}

