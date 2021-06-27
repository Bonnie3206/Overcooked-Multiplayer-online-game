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
        AVPlayer.bgQueuePlayer.volume = 0.5
        AVPlayer.bgQueuePlayer.play()
        
        return true
    }
}
extension RewardedAdController: GADFullScreenContentDelegate {

    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print(#function)
    }

    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print(#function)
    }

    func ad(_ ad: GADFullScreenPresentingAd,
            didFailToPresentFullScreenContentWithError error: Error) {
        print(#function, error)

    }

}
