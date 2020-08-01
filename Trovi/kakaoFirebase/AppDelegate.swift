//
//  AppDelegate.swift
//  kakaoFirebase
//
//  Created by swuad_39 on 06/01/2020.
//  Copyright © 2020 Digital Media Dept. All rights reserved.
//

import UIKit
import Firebase
import NMapsMap
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    var locationMgr:CLLocationManager!
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        NMFAuthManager.shared().clientId = "3ea4vfz7p1" //클라이언트 아이디로 채워야함
        GMSServices.provideAPIKey("AIzaSyApEyI8-ylW0bDihxdHGt774fMS7r1hMgo")
        GMSPlacesClient.provideAPIKey("AIzaSyApEyI8-ylW0bDihxdHGt774fMS7r1hMgo")
        locationMgr = CLLocationManager()
        locationMgr.requestWhenInUseAuthorization()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


    
}

extension UIApplication {
    var statusBarView : UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}
