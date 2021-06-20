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
    
    
    
    
    var body: some View {
        
        VStack{
            HStack{
                VStack{
                    KFImage(userPhotoURL)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 180)
                    
                    HStack{
                        Text("\(userName)")
                            .font(.largeTitle)
                    }
                }
                VStack{
                    //creat
                    Form{
                        Section(header: Text("創建房間"))
                        {
                            TextField("房間名稱",text:$creatRoomName)
                        }
                        Section(header: Text("密碼"))
                        {
                            TextField("房間密碼",text:$crearhRoomPassword)
                        }
                    }
                        .padding(7)
                        .padding(.horizontal, 25)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal, 10)
                    
                    Button(action:
                    {
                        createRoom(name:creatRoomName,password:crearhRoomPassword,start:true,player1: "\(userName)",player2: "",player3: "",quantity:1,preparedQuantity:0,URL_player1 :"\(turnURLString)",URL_player2 :"",URL_player3 :"")
                        createFood(room: creatRoomName, vegetable : 0,tomato : 0,cutVegetable : 0,cutTomato:0,cutVegetableForCook:0,cutTomatoForCook : 0,cookingVegetableNum : 0, cookingTomatoNum : 0,orderVegetableNum : 0,orderTomatoNum:0,coin : 0)
                        roomName = creatRoomName
                        goWaitingRoom = true
                    }
                        , label: {
                            Text("創建房間")
                                .padding(7)
                                .padding(.horizontal, 25)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .padding(.horizontal, 10)
                            
                    })
                }
                VStack{
                    //search
                    Form{
                        Section(header: Text("進入房間"))
                        {
                            TextField("房間名稱",text:$SearchRoomName)
                        }
                        Section(header: Text("密碼"))
                        {
                            TextField("房間密碼",text:$searchRoomPassword)
                        }
                    }
                        .padding(7)
                        .padding(.horizontal, 25)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal, 10)
                    
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
                                .padding(7)
                                .padding(.horizontal, 25)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .padding(.horizontal, 10)
                    })
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
