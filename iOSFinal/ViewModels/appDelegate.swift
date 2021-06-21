//
//  appDelegate.swift
//  iOSFinal
//
//  Created by CK on 2021/4/14.
//

import SwiftUI
import Firebase
import GoogleMobileAds
import AVFoundation

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        AVPlayer.setupBgMusic()
        AVPlayer.bgQueuePlayer.volume = 0.2
        AVPlayer.bgQueuePlayer.play()
        
        return true
    }
}
