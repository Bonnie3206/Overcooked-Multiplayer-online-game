//
//  Test0609View.swift
//  iOSFinal
//
//  Created by CK on 2021/6/9.
//

//
//  ContentView.swift
//  FirebaseSwiftUIDemo
//
//  Created by SHIH-YING PAN on 2021/5/4.
//

import SwiftUI
import FirebaseStorage
import FirebaseStorageSwift
import FirebaseFirestore
import FirebaseFirestoreSwift



struct Test0609View: View {
    
    func setLocation(location: Location) {//更新狀態
        let db = Firestore.firestore()
            
        do {
            try db.collection("location").document(location.name).setData(from: location)
        } catch {
            print(error)
        }
    }
    
    @State private var offset: CGSize = .zero
    
    var body: some View {
        
        VStack {
            Image("testBear")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .offset(offset)
            
            Button(action: {
                
                offset.width += 5
                setLocation(location: Location(name: "Bonny", x: offset.width, y: offset.height))
                
            }, label: {
                Image(systemName: "chevron.right.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
            })
            
            Button(action: {
                
                offset.height -= 5
                setLocation(location: Location(name: "Bonny", x: offset.width, y: offset.height))

            }, label: {
                Image(systemName: "chevron.up.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Test0609View()
    }
}
