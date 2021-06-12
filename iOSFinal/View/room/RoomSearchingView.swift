//
//  RoomSearchingView.swift
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
/*
func set(){//設定房間
    let db = Firestore.firestore()
    
    let roomQuaitity = WaitingRoom(quantity: 0)
    do{
        try
            db.collection("location").document(location.name)
            .setData(from:roomQuaitity)
    }catch{
        print(error)
    }
}*/
struct RoomSearchingView: View {
    
    @State private var currentUser = Auth.auth().currentUser
    @State private var userPhotoURL = URL(string: "")
    @State private var userName = ""
    @State private var goRoomBuilding = false
    @State private var goRoomSearching = false
    
    @State private var showRoomQuantity: Int = 0
    @State private var showRoomName = ""
    @State private var showRoomPassword = ""
    @State private var showRoomStart : Bool = false
    
    @State var searchRoomName: String
    
    var body: some View {
        
        VStack{
            HStack{
                VStack{
                    KFImage(userPhotoURL)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                    
                    HStack{
                        Text("\(userName)")
                            .font(.largeTitle)
                    }
                }
                VStack{
                    
                    Text("showRoomQuantity:\(showRoomQuantity)")
                    Text("showRoomName:\(showRoomName)")
                    Text("showRoomPassword:\(showRoomPassword)")
                    
                    TextField("Search ...", text: $searchRoomName)
                        .padding(7)
                        .padding(.horizontal, 25)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal, 10)
                    
                }
                
            }
            
            Button(action:
            {
                if let user = Auth.auth().currentUser {
                    print(user.uid, user.email, user.displayName, user.photoURL)
                }
                goRoomBuilding = true
            }
                , label: {
                    Text("創建房間")
                        .font(.largeTitle)
            })
            Button(action:
            {
                print("searchRoomName1:\(searchRoomName)")
                let db = Firestore.firestore()
                db.collection("waitingRoom").whereField("name", isEqualTo: "\(searchRoomName)").getDocuments { snapshot, error in
                    guard let snapshot = snapshot else { return }
                         if snapshot.documents.isEmpty  {
                        
                            print("searchRoomName:\(searchRoomName)")
                            print("now error")
                         } else {
                            print("success")
                                
                         }
                }
                /*
                if let user = Auth.auth().currentUser {
                    print(user.uid, user.email, user.displayName, user.photoURL)
                }
                goRoomSearching = true
 */
            }
                , label: {
                    Text("搜尋房間")
                        .font(.largeTitle)
                        .bold()
            })
        }.onAppear(
            perform:{
                //取得角色資訊
                userPhotoURL = (currentUser?.photoURL)
                if let user = Auth.auth().currentUser {
                    
                    userName = user.displayName ?? "nil"
                    
                }
                //監聽room號碼
                let db = Firestore.firestore()
                
                db.collection("map").document("room").addSnapshotListener { snapshot, error in
                    
                    guard let snapshot = snapshot else { return }
                    guard let roomQuantity = try? snapshot.data(as: Map.self) else { return }
                    showRoomQuantity = Int(roomQuantity.quantity)
                    
                }//監聽room性質
                db.collection("waitingRoom").document("room1").addSnapshotListener { snapshot, error in
                    
                    guard let snapshot = snapshot else { return }
                    guard let room = try? snapshot.data(as: WaitingRoom.self) else { return }
                    showRoomName = String(room.name)
                    showRoomPassword = String(room.password)
                    showRoomStart = Bool(room.start)
                    
                }
                //測試
                db.collection("waitingRoom").document("room1").addSnapshotListener { snapshot, error in
                    
                    guard let snapshot = snapshot else { return }
                    guard let room = try? snapshot.data(as: WaitingRoom.self) else { return }
                    showRoomName = String(room.name)
                    showRoomPassword = String(room.password)
                    showRoomStart = Bool(room.start)
                    
                }
                
                
            })
        EmptyView().sheet(isPresented: $goRoomBuilding, content:{RoomBuildingView()})
        EmptyView().sheet(isPresented: $goRoomSearching, content:{RoomSearchingView(searchRoomName: searchRoomName)})
        
        
    }
}

struct RoomSearchingView_Previews: PreviewProvider {
    static var previews: some View {
        RoomSearchingView(searchRoomName: "")///????????????????
    }
}
