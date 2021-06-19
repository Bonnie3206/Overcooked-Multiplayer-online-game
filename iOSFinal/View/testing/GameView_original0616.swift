//
//  GameView_original0616.swift
//  iOSFinal
//
//  Created by CK on 2021/6/17.
//
//
//  GameView.swift
//  iOSFinal
//
//  Created by CK on 2021/6/9.
//
/*
import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseStorageSwift//要有swift的,才有result
import Kingfisher
import FirebaseFirestoreSwift
import Firebase
import AppTrackingTransparency

struct GameView_original0616: View {
    
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
    
    @State private var arrowKeyPosition_x : CGFloat = -350.0//間距25
    @State private var arrowKeyPosition_y : CGFloat = 80.0//間距30
    //食材數量
    @State private var cutVegetable : Int = 0
    @State private var cutTomato : Int = 0
    @State private var vegetable : Int = 0
    @State private var tomato : Int = 0
    @State private var cutVegetableForCook : Int = 0
    @State private var cutTomatoForCook : Int = 0
    
    var body: some View {
        ZStack{
            Image("大背景")
                .resizable()
                .scaledToFit()
                .scaleEffect(1.4)
                .offset(x:0,y:20)
            Group{//桌
                
                Image("桌子橫x8")
                    .resizable()
                    .scaledToFit()
                    .offset(x:0,y:30)
                    .scaleEffect(0.65)
                Image("桌子橫x2")//切菜桌
                    .resizable()
                    .scaledToFit()
                    .position(x: 1750, y: -700)
                    .scaleEffect(0.175)
                Image("桌子橫x2")//切菜桌
                    .resizable()
                    .scaledToFit()
                    .position(x: 500, y: -700)
                    .scaleEffect(0.175)
                
                Image("桌子橫x2")//切菜桌
                    .resizable()
                    .scaledToFit()
                    .position(x: -750, y: -700)
                    .scaleEffect(0.175)
                
            }
            Group{//切菜桌
                Image("未洗的菜去背")//切菜桌
                    .resizable()
                    .scaledToFit()
                    .position(x: -770, y: -600)
                    .scaleEffect(0.20)
                    .overlay(
                        Text("\(vegetable)")
                            .padding(.horizontal, 10)
                            .background(Color(.systemGray6))
                            .cornerRadius(15)
                            .offset(x:-240,y:-130)
                    )

                Image("洗好的菜去背")//切菜桌
                    .resizable()
                    .scaledToFit()
                    .position(x: -420, y: -600)
                    .scaleEffect(0.20)
                    .overlay(
                        Text("\(cutVegetable)")
                            .padding(.horizontal, 10)
                            .background(Color(.systemGray6))
                            .cornerRadius(15)
                            .offset(x:-170,y:-130)
                    )
                Image("番茄去背")//切菜桌
                    .resizable()
                    .scaledToFit()
                    .position(x: 330, y: -600)
                    .scaleEffect(0.20).overlay(
                        Text("\(tomato)")
                            .padding(.horizontal, 10)
                            .background(Color(.systemGray6))
                            .cornerRadius(15)
                            .offset(x:-18,y:-130)
                    )
                Image("番茄切片去背")//切菜桌
                    .resizable()
                    .scaledToFit()
                    .position(x: 680, y: -600)
                    .scaleEffect(0.20)
                    .overlay(
                        Text("\(cutTomato)")
                            .padding(.horizontal, 10)
                            .background(Color(.systemGray6))
                            .cornerRadius(15)
                            .offset(x:48,y:-130)
                    )
                
                
            }
            Group{//中間桌以下
                Image("番茄切片去背")
                    .resizable()
                    .scaledToFit()
                    .position(x: 610, y: 280)
                    .scaleEffect(0.20)
                    .overlay(
                        Text("\(cutTomatoForCook)")
                            .padding(.horizontal, 10)
                            .background(Color(.systemGray6))
                            .cornerRadius(15)
                            .offset(x:35,y:60)
                    )
                Image("洗好的菜去背")
                    .resizable()
                    .scaledToFit()
                    .position(x: -450, y: 280)
                    .scaleEffect(0.20)
                    .overlay(
                        Text("\(cutVegetableForCook)")
                            .padding(.horizontal, 10)
                            .background(Color(.systemGray6))
                            .cornerRadius(15)
                            .offset(x:-175,y:60)
                    )
                
                Image("煮飯去背")
                    .resizable()
                    .scaledToFit()
                    .position(x: 550, y: 850)
                    .scaleEffect(0.25)
            }
            Group{
                Button(action: {
                    myOffset.height -= footStep
                    setLocation(location: Location(name: "\(userName)", x: myOffset.width, y: myOffset.height))
                }, label: {
                    Image(systemName: "chevron.up.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        
                }).position(x: 50, y: 250)
                //左
                Button(action: {
                    myOffset.width -= footStep
                    setLocation(location: Location(name: "\(userName)", x: myOffset.width, y: myOffset.height))
                }, label: {
                    Image(systemName: "chevron.left.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        
                }).position(x: 0, y: 300)
                //上
                Button(action: {
                    myOffset.width += footStep
                    setLocation(location: Location(name: "\(userName)", x: myOffset.width, y: myOffset.height))
                }, label: {
                    Image(systemName: "chevron.right.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                }).position(x: 100, y: 300)
                //下
                Button(action: {
                    myOffset.height += footStep
                    setLocation(location: Location(name: "\(userName)", x: myOffset.width, y: myOffset.height))
                }, label: {
                    Image(systemName: "chevron.down.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                }).position(x: 50, y: 350)
                
                
                Button(action: {
                    
                }, label: {
                    Text("拿取/放下")
                }).position(x: 1000, y: -350)
                Button(action: {
                    
                }, label: {
                    Text("做菜")
                }).position(x: 1000, y: -350)
                Button(action: {
                    
                }, label: {
                    Text("料理")
                }).position(x: 1000, y: -350)
                
            }
            VStack{//人物位置
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
            }//自己
            
            
        }.onAppear(perform:{
            let queue = DispatchQueue(label: "com.appcoda.myqueue")
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
                queue.sync{
                    URLString_Player1 = String(room.URL_player1)
                    URLString_Player2 = String(room.URL_player2)
                    URLString_Player3 = String(room.URL_player3)
                }
                
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

struct GameViewv_original0616_Previews: PreviewProvider {
    static var previews: some View {
        GameView(roomDocumentName: .constant("Room2"))
            .previewLayout(.fixed(width: 844, height: 390))
            .previewDevice("iPhone 11")
            .environment(\.horizontalSizeClass, .regular)
            
    }
    
}
 */
