//
//  GameView.swift
//  iOSFinal
//
//  Created by CK on 2021/6/9.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseStorageSwift//要有swift的,才有result
import Kingfisher
import FirebaseFirestoreSwift
import Firebase
import AppTrackingTransparency

func setLocation(){
    let db = Firestore.firestore()
    
    let location = Location(name:"Bonny",x:0,y:0)
    do{
        try
            db.collection("location").document(location.name)
            .setData(from:location)
    }catch{
        print(error)
    }
}
struct GameView: View {
    
    @State private var offset:CGSize = .zero
    
    var body: some View {
        ZStack{
            Image("大背景")
                .resizable()
                .scaledToFit()
                .scaleEffect(1.4)
                .offset(x:0,y:20)
            VStack{
                Image("桌子橫x8")
                    .resizable()
                    .scaledToFit()
                    .offset(x:0,y:0)
                    .scaleEffect(0.65)
                Image("桌子橫x2")
                    .resizable()
                    .scaledToFit()
                    .offset(x:0,y:0)
                    .scaleEffect(0.35)
            }
            
            
            VStack{
                Image("testBear")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .offset(offset)
                Image(systemName: "chevron.up.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .offset(x:-300,y:90)
                    .onLongPressGesture {
                        offset.height -= 5
                    }
                
                HStack{
                    Image(systemName: "chevron.left.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .offset(x:-325,y:80)
                        .onLongPressGesture {
                            offset.width -= 5
                        }
                    
                    Image(systemName: "chevron.right.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .offset(x:-275,y:80)
                        .onLongPressGesture {
                            offset.width += 5
                        }
                }
                Image(systemName: "chevron.down.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .offset(x:-300,y:60)
                    .onLongPressGesture {
                        offset.height += 5
                    }
            }
            
        }.onAppear(perform:{
            let db = Firestore.firestore()
            db.collection("location").document("Bonny")
                .addSnapshotListener{ snapshot,error in
                    guard let snapshot = snapshot else{return}
                    guard let location = try? snapshot.data(as:
                         Location.self)
                    else{return}
                }
            })
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
            .previewLayout(.fixed(width: 844, height: 390))
            .previewDevice("iPhone 11")
    }
}

