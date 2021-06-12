//
//  CharacterView.swift
//  iOSFinal
//
//  Created by CK on 2021/5/10.
//
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
struct CharacterView: View {
    
    @State private var currentUser = Auth.auth().currentUser
    @State private var userPhotoURL = URL(string: "")
    @State private var userName = ""
    @State private var goRoomBuilding = false
    @State private var goRoomSearching = false
    
    @State var searchRoomName: String
    
    var body: some View {
        VStack{
            KFImage(userPhotoURL)
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
            
            HStack{
                Text("角色名稱:")
                
                Text("\(userName)")
                    .font(.largeTitle)
                
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
                if let user = Auth.auth().currentUser {
                    print(user.uid, user.email, user.displayName, user.photoURL)
                }
                goRoomSearching = true
            }
                , label: {
                    Text("搜尋房間")
                        .font(.largeTitle)
                        .bold()
            })
        }.onAppear(
            perform:{
                userPhotoURL = (currentUser?.photoURL)
                if let user = Auth.auth().currentUser {
                    
                    userName = user.displayName ?? "nil"
                    
                }
                
            })
        EmptyView().sheet(isPresented: $goRoomBuilding, content:{RoomBuildingView()})
        EmptyView().sheet(isPresented: $goRoomSearching, content:{RoomSearchingView(searchRoomName: searchRoomName)})
        
        
    }
}

struct CharacterView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterView(searchRoomName: "")
            .previewLayout(.fixed(width: 844, height: 390))
            .previewDevice("iPhone 11")
    }
}
