//
//  Character.swift
//  iOSFinal
//
//  Created by CK on 2021/6/12.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Location: Codable, Identifiable {
    @DocumentID var id: String?
    let name: String
    var x: CGFloat
    var y: CGFloat
}

struct PlayerData: Codable, Identifiable {
    @DocumentID var id: String?
    let name: String
    let URLString :URL
    var coin:Int
    var bestCoin_map1 :Int
}
struct Cooking: Codable, Identifiable {
    @DocumentID var id: String?
    
    var vegetableNum : Int = 0
    var tomatoNum :Int = 0
    var finishedOrder :Int = 0
}
struct Order: Codable, Identifiable {
    @DocumentID var id: String?
    
    var vegetableNum : Int = 0
    var tomatoNum :Int = 0
    var finishedOrder :Int = 0
}
