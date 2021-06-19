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
    let action:String
    var x : Int
    var y :Int
    var coin:Int
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
