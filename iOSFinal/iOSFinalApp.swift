//
//  iOSFinalApp.swift
//  iOSFinal
//** $0.省略參數名字
//** 單純存資料用struct /有func :class
//** 何時用class：可用enviroment 用struct:只能用State
//**產生就開始監聽1.onappear 2. init(){}
//  Created by CK on 2021/4/14.
//**NetworkApi修改網路接資料的地方
//**（）很像簡單的array
//1.""內有“” swift
//2.2個alert
//3.不能立即顯示圖片okk
//4.font book
//5.tag okk
//圖檔轉png


import SwiftUI

@main
struct iOSFinalApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            //TestView()
            StartView(playerSignInMail: "", playerSignInPassword: "")
            //CharacterSetView()
            
        }
    }
}
