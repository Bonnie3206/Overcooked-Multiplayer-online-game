//
//  Map.swift
//  iOSFinal
//
//  Created by CK on 2021/6/12.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct RoomState: Codable, Identifiable {//紀錄firebase上waiting room得值
    @DocumentID var id: String?
    let name : String
    var password: String
    var start: Bool
    var player1:String
    var player2:String
    var player3:String
    var quantity: Int
    var preparedQuantity:Int
    
    var URL_player1 :String
    var URL_player2:String
    var URL_player3 :String
 
    
}
struct Map1: Codable, Identifiable {
    @DocumentID var id: String?
    var quantity: Int
    var preparedQuantity:Int
}
struct Food: Codable, Identifiable {
    @DocumentID var id: String?
    let room : String
    
    var vegetable : Int
    var tomato : Int
    
    var cutVegetable : Int
    var cutTomato : Int
    
    var cutVegetableForCook : Int
    var cutTomatoForCook : Int
    
    var cookingVegetableNum : Int
    var cookingTomatoNum : Int
    
    var orderVegetableNum : Int
    var orderTomatoNum : Int 
    
    var coin : Int = 0
    
}
//人物到的櫃子會亮
//一次完成指定的那個單 失敗時才會消失 扣分
struct deskFunction: Codable, Identifiable {
    @DocumentID var id: String?
    
    var wash:Bool
    var cut :Bool
    var putOn:Bool
    
}
class FrameData: ObservableObject {
    //第一次的位置
    var characterFrame = [CGRect.zero]
    var foodFrame = [CGRect](repeating: CGRect.zero, count:7)
    //之後一直變化
    var nowCharacterFrameX = [CGFloat.zero]
    var nowCharacterFrameY = [CGFloat.zero]
    //food不動,不變
    var foodFrameX = [CGFloat](repeating: CGFloat.zero, count:7)
    var foodFrameY = [CGFloat](repeating: CGFloat.zero, count:7)
 
}
class GameTimer: ObservableObject {
    
    private var frequency = 1.0
    private var timer: Timer?
    private var startDate: Date?
    @Published var secondsElapsed = 0
    func getDate() -> Date {////////////
            startDate = Date()
            return startDate!
        }
    
    func start() {
        secondsElapsed = 0
        startDate = Date()
        timer = Timer.scheduledTimer(withTimeInterval: frequency, repeats: true)
    { timer in
            if let startDate = self.startDate {
                self.secondsElapsed = Int(timer.fireDate.timeIntervalSince1970 -
    startDate.timeIntervalSince1970)
            }
        }
        //if timer > 50 ???????????????
    }
    func stop() {
        timer?.invalidate()
        timer = nil
    }

}
