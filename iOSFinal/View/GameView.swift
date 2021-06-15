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

struct GameView: View {
    
    @Binding var roomDocumentName:String
    //character
    @State private var currentUser = Auth.auth().currentUser
    @State private var userPhotoURL = URL(string: "")
    @State private var userName = ""
    //position
    @State private var myOffset:CGSize = .zero
    @State private var playerOffset2:CGSize = .zero
    @State private var playerOffset3:CGSize = .zero
    @State private var offset1:CGSize = .zero
    @State private var offset2:CGSize = .zero
    @State private var offset3:CGSize = .zero
    @State private var footStep :CGFloat = 15.0
    //photo
    @State private var URLString_Player1 : String = ""
    @State private var URLString_Player2 : String = ""
    @State private var URLString_Player3 : String = ""
    
    @State private var showPlayer1 : String = ""
    @State private var showPlayer2 : String = ""
    @State private var showPlayer3 : String = ""
    
    
    
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
                    .scaleEffect(0.25)
            }
            
            
            VStack{//自己
                HStack{
                    //自己
                    KFImage(URL(string: "\(URLString_Player1)"))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .offset(offset1)
                    KFImage(URL(string: "\(URLString_Player2)"))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .offset(offset2)
                    KFImage(URL(string: "\(URLString_Player3)"))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .offset(offset3)
                }
                
                Button(action: {
                    myOffset.height -= footStep
                    setLocation(location: Location(name: "\(userName)", x: myOffset.width, y: myOffset.height))
                }, label: {
                    Image(systemName: "chevron.up.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        
                }).offset(x:-300,y:90)
                
                
                
                HStack{
                    Button(action: {
                        myOffset.width -= footStep
                        setLocation(location: Location(name: "\(userName)", x: myOffset.width, y: myOffset.height))
                    }, label: {
                        Image(systemName: "chevron.left.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            
                    }).offset(x:-325,y:80)
                    Button(action: {
                        myOffset.width += footStep
                        setLocation(location: Location(name: "\(userName)", x: myOffset.width, y: myOffset.height))
                    }, label: {
                        Image(systemName: "chevron.right.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                    }).offset(x:-275,y:80)
                }
                Button(action: {
                    myOffset.height += footStep
                    setLocation(location: Location(name: "\(userName)", x: myOffset.width, y: myOffset.height))
                }, label: {
                    Image(systemName: "chevron.down.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                }).offset(x:-300,y:60)
            }//自己
            
            
        }.onAppear(perform:{
            //取得角色資訊
            userPhotoURL = (currentUser?.photoURL)
            if let user = Auth.auth().currentUser {
                userName = user.displayName ?? "nil"
            }
            //取得角色位置與照片
            let db = Firestore.firestore()
            let db2 = Firestore.firestore()
            
            db.collection("waitingRoom").document("\(roomDocumentName)").addSnapshotListener { snapshot, error in
                
                guard let snapshot = snapshot else { return }
                guard let room = try? snapshot.data(as: RoomState.self) else { return }
                
                showPlayer1 = String(room.player1)
                showPlayer2 = String(room.player2)
                showPlayer3 = String(room.player3)
               
                URLString_Player1 = String(room.URL_player1)
                URLString_Player2 = String(room.URL_player2)
                URLString_Player3 = String(room.URL_player3)
                //自己的位置
                db2.collection("location").document("\(showPlayer1)").addSnapshotListener { snapshot, error in
                    
                    guard let snapshot = snapshot else { return }
                    guard let location = try? snapshot.data(as: Location.self) else { return }
                    offset1 = CGSize(width: location.x, height: location.y)
                    
                }
                //player2的位置
                db.collection("location").document("\(showPlayer2)").addSnapshotListener { snapshot, error in
                    
                    guard let snapshot = snapshot else { return }
                    guard let location = try? snapshot.data(as: Location.self) else { return }
                    offset2 = CGSize(width: location.x, height: location.y)
                }
                //player3的位置
                db.collection("location").document("\(showPlayer3)").addSnapshotListener { snapshot, error in
                    
                    guard let snapshot = snapshot else { return }
                    guard let location = try? snapshot.data(as: Location.self) else { return }
                    offset3 = CGSize(width: location.x, height: location.y)
                    
                }
            }
            })
    }
}
/*
struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(roomDocumentName: "")
            .previewLayout(.fixed(width: 844, height: 390))
            .previewDevice("iPhone 11")
    }
}
*/
