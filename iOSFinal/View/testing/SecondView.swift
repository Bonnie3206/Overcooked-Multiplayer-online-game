//
//  SecondView.swift
//  iOSFinal
//
//  Created by CK on 2021/6/9.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct SecondView: View {
    
    @State private var offset: CGSize = .zero
    
    var body: some View {
        
        VStack {
            Image("testBear")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .offset(offset)
            
            
        }
        .onAppear(perform: {
            let db = Firestore.firestore()
            
            db.collection("location").document("Bonny").addSnapshotListener { snapshot, error in
                
                guard let snapshot = snapshot else { return }
                guard let location = try? snapshot.data(as: Location.self) else { return }
                offset = CGSize(width: location.x, height: location.y)
                
            }
        })
    }
}

struct SecondView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SecondView()
            SecondView()
        }
    }
}
