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
}
struct Map: Codable, Identifiable {
    @DocumentID var id: String?
    var quantity: Int
}
