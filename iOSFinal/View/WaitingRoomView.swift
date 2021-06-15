//
//  WaitingRoomView.swift
//  iOSFinal
//
//  Created by CK on 2021/6/7.
//
import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseStorageSwift//要有swift的,才有result
import Kingfisher
import FirebaseFirestoreSwift
import Firebase

struct WaitingRoomView: View {
    @State private var currentUser = Auth.auth().currentUser
    @State private var userPhotoURL = URL(string: "")
    @State private var userName = ""
    
    @State private var goWaitingRoom = false
    @State private var goRoomBuilding = false
    @State private var goRoomSearching = false
    
    @State private var showRoomQuantity: Int = 0
    @State private var showPreparedQuantity: Int = 0
    @State private var showRoomName = ""
    @State private var showRoomPassword = ""
    @State private var showRoomStart : Bool = false
    
    @State private var showPlayer1 : String = ""
    @State private var showPlayer2 : String = ""
    @State private var showPlayer3 : String = ""
    
    @State private var URLString_Player1 : String = ""
    @State private var URLString_Player2 : String = ""
    @State private var URLString_Player3 : String = ""
    
    @State var searchRoomName: String
    @State var creatRoomName: String
    @State var crearhRoomPassword: String
    
    @State var GamePrepared: Bool = false
    @State var GamePreparedText: String = "未準備"
    
    @Binding var roomDocumentName:String
    
    @State var goGameView = false
    @State var showEnterGameError = false
        
    
    var body: some View {
        
        
        VStack{
            Text("\(roomDocumentName)")
                .font(.largeTitle)
            HStack{
                Text("人數:\(showRoomQuantity)")
                Text("已準備人數:\(showPreparedQuantity)")
            }
            HStack{
                VStack{
                    
                    KFImage(URL(string: "\(URLString_Player1)"))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 180)
                    /*
                    Image("\(photo1)")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 180)
 */
                    HStack{
                        Text("\(showPlayer1)")
                            .font(.largeTitle)
                    }
                }
                VStack{
                    KFImage(URL(string: "\(URLString_Player2)"))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 180)
                    /*
                    Image("\(photo1)")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 180)
 */
                    
                    HStack{
                        Text("\(showPlayer2)")
                            .font(.largeTitle)
                    }
                }
                VStack{
                    KFImage(URL(string: "\(URLString_Player3)"))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 180)
                    /*
                    Image("\(photo1)")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 180)
 */
                    HStack{
                        Text("\(showPlayer3)")
                            .font(.largeTitle)
                    }
                }
                
            }
            HStack{
                
                Button(action: {
                    GamePrepared.toggle()
                    if GamePrepared == true{
                        addPreparedQuantity(room:roomDocumentName)
                        GamePreparedText = "已準備"
                    }else{
                        minusPreparedQuantity(room:roomDocumentName)
                        GamePreparedText = "未準備"
                    }
                    
                }, label: {
                    Text("\(GamePreparedText)")
                })
                Button(action: {
                    if showPreparedQuantity >= 0{
                        goGameView = true
                        createCharacterPositon(name:userName,x:0,y:0)
                    }else{
                        showEnterGameError = true
                    }
                    
                }, label: {
                    Text("進入遊戲")
                }).alert(isPresented: $showEnterGameError) { () -> Alert in
                    
                    Alert(title: Text("遊戲進入失敗"), message: Text("人數不足三人"), dismissButton: .default(Text("確定"), action: {
                        
                    }))
                }

            }
        }
        .onAppear(
            perform:{
               
                //取得角色資訊
                userPhotoURL = (currentUser?.photoURL)
                if let user = Auth.auth().currentUser {
                    userName = user.displayName ?? "nil"
                }
                //
                let db = Firestore.firestore()
                let db2 = Firestore.firestore()
                //let db3 = Firestore.firestore()
                //監聽room性質
                
                db.collection("waitingRoom").document("\(roomDocumentName)").addSnapshotListener { snapshot, error in
                    
                    guard let snapshot = snapshot else { return }
                    guard let room = try? snapshot.data(as: RoomState.self) else { return }
                    showRoomName = String(room.name)
                    showRoomPassword = String(room.password)
                    showRoomStart = Bool(room.start)
                    
                    showRoomQuantity = Int(room.quantity)
                    showPreparedQuantity = Int(room.preparedQuantity)
                    
                    showPlayer1 = String(room.player1)
                    showPlayer2 = String(room.player2)
                    showPlayer3 = String(room.player3)
                    
                    URLString_Player1 = String(room.URL_player1)
                    URLString_Player2 = String(room.URL_player2)
                    URLString_Player3 = String(room.URL_player3)
                    
                    print("room.URL_player1 :\(room.URL_player1)")
                    print("room.URL_player2 :\(room.URL_player2)")
                    print("room.URL_player3 :\(room.URL_player3)")
                    
                }
                
                //取userData得Player1的url
                
 /*
                //取userData得Player2的url
                db.collection("UserData").document("\(showPlayer2)").addSnapshotListener { snapshot, error in
                    
                    guard let snapshot = snapshot else { return }
                    guard let userData = try? snapshot.data(as: PlayerData.self) else { return }
                    showURL_Player2 = userData.URLString
                    print("showURL_Player2:\(showURL_Player2)")
                }
                //取userData得Player3的url
                db.collection("UserData").document("\(showPlayer3)").addSnapshotListener { snapshot, error in
                    
                    guard let snapshot = snapshot else { return }
                    guard let userData = try? snapshot.data(as: PlayerData.self) else { return }
                    showURL_Player3 = userData.URLString
                    
                }*/
            })
        EmptyView().sheet(isPresented: $goGameView,content:{GameView(roomDocumentName:$roomDocumentName)})
        
    }
}
/*
struct WaitingRoomView_Previews: PreviewProvider {
    static var previews: some View {
        WaitingRoomView(searchRoomName: "", creatRoomName: "", crearhRoomPassword: "", roomDocumentName: searchRoomName)
    }
}
*/
