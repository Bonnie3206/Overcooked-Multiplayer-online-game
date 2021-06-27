//
//  EnterRoomView.swift
//  iOSFinal
//
//  Created by CK on 2021/6/16.
//

import SwiftUI

import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseStorageSwift//要有swift的,才有result
import Kingfisher
import FirebaseFirestoreSwift
import Firebase
/*不能直接text,要用 if let user = Auth.auth().currentUser {
 print(user.uid, user.email, user.displayName, user.photoURL)
 }*/

struct EnterRoomView: View {
    
    @State private var currentUser = Auth.auth().currentUser
    @State private var userPhotoURL = URL(string: "")
    @State private var userName = ""
    @State private var userCoins = 0
    
    @State private var goWaitingRoom = false
    @State private var goRoomBuilding = false
    @State private var goRoomSearching = false
    
    @State private var showRoomQuantity: Int = 0
    @State private var showRoomName = ""
    @State private var showRoomPassword = ""
    @State private var showRoomStart : Bool = false
    
    @State var roomName: String
    @State var creatRoomName: String
    @State var SearchRoomName: String
    
    @State var searchRoomPassword: String
    @State var crearhRoomPassword: String
    
    @State var turnURLString: String = ""
    @State var gameTime:Int = 10
    
    var body: some View {
        
        ZStack{
            Image("房間背景")
                .resizable()
                .scaledToFit()
                .scaleEffect(1.1)
            
            VStack{
                HStack{
                    VStack{
                        KFImage(userPhotoURL)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 180)
                            .cornerRadius(500)
                        ZStack{
                            Rectangle()
                                .foregroundColor(.white)
                                .opacity(0.99)
                                .cornerRadius(30)
                                .frame(width: 200, height: 100, alignment: .center)
                                .offset(x:0,y:0)
                            VStack{
                                HStack{
                                    Text("\(userName)")
                                        .font(.system(size: 30, weight: .regular, design: .monospaced))
                                }
                                HStack{
                                    Text("金幣:")
                                        .font(.system(size: 30, weight: .regular, design: .monospaced))
                                    Text("\(userCoins)")
                                        .font(.system(size: 30, weight: .regular, design: .monospaced))
                                }
                                
                            }
                            
                        }
                    }
                    ZStack{
                        Rectangle()
                            .foregroundColor(.white)
                            .opacity(0.95)
                            .cornerRadius(30)
                            .frame(width: 300, height: 250, alignment: .center)
                            .offset(x:0,y:0)
                        VStack{
                            
                            Text("創建房間")
                                .font(.system(size: 30, weight: .regular, design: .monospaced))
                                .offset(x: 0, y: -10)
                            HStack{
                                Text("輸入房間名稱")
                                    .font(.system(size: 20, weight: .regular, design: .monospaced))
                                TextField("房間名稱",text:$creatRoomName)
                            }
                            HStack{
                                Text("輸入房間密碼")
                                    .font(.system(size: 20, weight: .regular, design: .monospaced))
                                TextField("房間密碼",text:$crearhRoomPassword)
                            }
                            
                            Button(action:
                            {
                                createRoom(name:creatRoomName,password:crearhRoomPassword,start:true,player1: "\(userName)",player2: "",player3: "",quantity:1,preparedQuantity:0,URL_player1 :"\(turnURLString)",URL_player2 :"",URL_player3 :"")
                                createFood(room: creatRoomName, vegetable : 0,tomato : 0,cutVegetable : 0,cutTomato:0,cutVegetableForCook:0,cutTomatoForCook : 0,cookingVegetableNum : 0, cookingTomatoNum : 0,orderVegetableNum : 0,orderTomatoNum:0,coin : 0,tapTimes_washTomato:0, tapTimes_washVegetable:0, gameStart: 0)
                                roomName = creatRoomName
                                goWaitingRoom = true
                            }
                                , label: {
                                    Text("創建房間")
                                        .font(.system(size: 25, weight: .regular, design: .monospaced))
                                        .padding(7)
                                        .padding(.horizontal, 35)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(8)
                                        .offset(x: 0, y: 20)
                            })
                        }
                    }
                    ZStack{
                        Rectangle()
                            .foregroundColor(.white)
                            .opacity(0.8)
                            .cornerRadius(30)
                            .frame(width: 300, height: 250, alignment: .center)
                            .offset(x:0,y:0)
                        VStack{
                            Text("進入房間")
                                .font(.system(size: 30, weight: .regular, design: .monospaced))
                                .offset(x: 0, y: -10)
                            HStack{
                                Text("輸入房間名稱")
                                    .font(.system(size: 20, weight: .regular, design: .monospaced))
                                TextField("房間名稱",text:$SearchRoomName)
                            }
                            HStack{
                                Text("輸入房間密碼")
                                    .font(.system(size: 20, weight: .regular, design: .monospaced))
                                TextField("房間密碼",text:$searchRoomPassword)
                            }
                            
                            Button(action:
                            {
                                print("searchRoomName1:\(SearchRoomName)")
                                let db = Firestore.firestore()
                                db.collection("waitingRoom").whereField("name", isEqualTo: "\(SearchRoomName)").getDocuments { snapshot, error in
                                    guard let snapshot = snapshot else { return }
                                         if snapshot.documents.isEmpty  {
                                            
                                            print("找不到此房間，error")
                                            print("searchRoomName:\(roomName)")
                                            
                                         } else {//要先取得id才能找到該密碼
                                            
                                            db.collection("waitingRoom").whereField("password", isEqualTo: "\(searchRoomPassword)").getDocuments { snapshot, error in
                                                guard let snapshot = snapshot else { return }
                                                     if snapshot.documents.isEmpty  {
                                                        
                                                        print("密碼錯誤，error")
                                                        print("searchRoomPassword:\(searchRoomPassword)")
                                                        
                                                     } else {
                                                        
                                                        print("success")
                                                        roomName = SearchRoomName
                                                        //saveURLtoRoom(roomName:roomName,URLSting:String(userPhotoURL))
                                                        ModifyChararcterName(roomName:roomName,name:userName, URLSting: turnURLString)
                                                        goWaitingRoom = true
                                                     }
                                            }
                                         }
                                }
                            }, label: {
                                    Text("搜尋房間")
                                        .font(.system(size:24, weight: .regular, design: .monospaced))
                                        .padding(7)
                                        .padding(.horizontal, 38)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(8)
                                        .offset(x: 0, y: 20)
                            })
                        }
                    }
                }
            }
        }.onAppear(
            perform:{
                //取得角色資訊
                userPhotoURL = (currentUser?.photoURL)
                turnURLString = userPhotoURL!.absoluteString
                
                if let user = Auth.auth().currentUser {
                    
                    userName = user.displayName ?? "nil"
                }
                let db = Firestore.firestore()
                let queue = DispatchQueue(label: "com.appcoda.myqueue")
                
 //監聽玩家個別原始coin
                db.collection("UserData").document("\(userName)").addSnapshotListener { snapshot, error in
                    
                    guard let snapshot = snapshot else { return }
                    guard let player = try? snapshot.data(as: PlayerData.self) else { return }
                    
                    queue.sync{
                        userCoins = Int(player.coin)
                        
                    }
                }
                
            })
        EmptyView().sheet(isPresented: $goWaitingRoom, content:{WaitingRoomView(searchRoomName: "", creatRoomName: "", crearhRoomPassword: "", roomDocumentName: $roomName)})
        
        
        
    }
}

struct EnterRoomView_Previews: PreviewProvider {
    static var previews: some View {
        EnterRoomView(roomName: "", creatRoomName: "", SearchRoomName: "", searchRoomPassword: "", crearhRoomPassword: "")
            .previewLayout(.fixed(width: 844, height: 390))
            .previewDevice("iPhone 11")
    }
}
