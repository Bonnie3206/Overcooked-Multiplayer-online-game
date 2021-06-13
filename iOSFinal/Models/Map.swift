//
//  Map.swift
//  iOSFinal
//
//  Created by CK on 2021/6/12.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct WaitingRoom: Codable, Identifiable {
    @DocumentID var id: String?
    let name : String
    var password: String
    var start: Bool
    var player1:String
    var player2:String
    var player3:String
    var quantity: Int
    var preparedQuantity:Int
    
}
struct Map: Codable, Identifiable {
    @DocumentID var id: String?
    var quantity: Int
    var preparedQuantity:Int
}

