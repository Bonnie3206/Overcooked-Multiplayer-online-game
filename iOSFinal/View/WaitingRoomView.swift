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
    /*
    let showURL_Player1 = URL(string: "https://firebasestorage.googleapis.com/v0/b/final2-3da54.appspot.com/o/E1124AF6-2BE6-48F3-B878-EA7F620826EF.jpg?alt=media&token=fda505dc-e90f-49ee-be33-176983c80612")!*/
    @State private var url = URL(string: "")
    
    @State private var url2 = URL(string: "https://firebasestorage.googleapis.com/v0/b/final2-3da54.appspot.com/o/0642024A-069D-4D60-8A66-CDAD6F0DB5D3.jpg?alt=media&token=595b5aa6-ed87-486b-a4cb-deb6afc6f60b")!
    let url3 = URL(string: "https://firebasestorage.googleapis.com/v0/b/final2-3da54.appspot.com/o/E1124AF6-2BE6-48F3-B878-EA7F620826EF.jpg?alt=media&token=fda505dc-e90f-49ee-be33-176983c80612")!
    @State private var showURL_Player1 :String = ""
    let url11 = URL(string: "showURL_Player1")
    @State private var showURL_Player2 = URL(string: "")
    @State private var showURL_Player3 = URL(string: "")
    
    @State var searchRoomName: String
    @State var creatRoomName: String
    @State var crearhRoomPassword: String
    
    @State var GamePrepared: Bool = false
    @State var GamePreparedText: String = "未準備"
    
    @Binding var roomDocumentName:String
    
    @State var goGameView = false
    @State var showEnterGameError = false
    
    @State var photo1 :String = ""
    @State var photo2 :String = ""
    @State var photo3 :String = ""
    
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
                    /*
                    KFImage(url11)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 180)*/
                    Image("\(photo1)")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 180)
                    HStack{
                        Text("\(showPlayer1)")
                            .font(.largeTitle)
                    }
                }
                VStack{
                    /*
                    KFImage(url2)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 180)
 */
                    Image("\(photo2)")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 180)
                    
                    HStack{
                        Text("\(showPlayer2)")
                            .font(.largeTitle)
                    }
                }
                VStack{
                    /*
                    KFImage(url3)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 180)
                    */
                    Image("\(photo3)")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 180)
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
                //監聽room性質
                db.collection("waitingRoom").document("\(roomDocumentName)").addSnapshotListener { snapshot, error in
                    
                    guard let snapshot = snapshot else { return }
                    guard let room = try? snapshot.data(as: WaitingRoom.self) else { return }
                    showRoomName = String(room.name)
                    showRoomPassword = String(room.password)
                    showRoomStart = Bool(room.start)
                    showRoomQuantity = Int(room.quantity)
                    
                    print("hi\(showRoomQuantity)")
                    showPreparedQuantity = Int(room.preparedQuantity)
                    showPlayer1 = String(room.player1)
                    photo1 = String(room.player1)
                    showPlayer2 = String(room.player2)
                    photo2 = String(room.player2)
                    showPlayer3 = String(room.player3)
                    photo3 = String(room.player3)
                    
                }/*
                //取userData得Player1的url
                db.collection("UserData").document("\(showPlayer1)").addSnapshotListener { snapshot, error in
                    
                    guard let snapshot = snapshot else { return }
                    guard let userData = try? snapshot.data(as: PlayerData.self) else { return }
                    showURL_Player1 = String(contentsOf: userData.URLString)
                    print("showURL_Player1:\(showURL_Player1)")
                    
                }
 
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
