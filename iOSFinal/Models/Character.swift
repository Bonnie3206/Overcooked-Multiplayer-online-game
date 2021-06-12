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
