//
//  Map.swift
//  iOSFinal
//
//  Created by CK on 2021/6/12.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct RoomState: Codable, Identifiable {
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
struct cook: Codable, Identifiable {
    @DocumentID var id: String?
    var dishes = ["青菜炒蛋","蕃茄沙拉"]
    var wash:Bool
    var cut :Bool
    var washTime : Int = 3
    var cookTime : Int = 5
    
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
