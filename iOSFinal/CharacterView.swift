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
    
    var body: some View {
        VStack{
            
            Button(action:
            {
                if let user = Auth.auth().currentUser {
                    
                    print(user.uid, user.email, user.displayName, user.photoURL)
                    
                }
            }
                , label: {
                
                    if let user = Auth.auth().currentUser {
                        VStack{
                            KFImage(userPhotoURL)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 300, height: 300)
                            HStack{
                                Text("角色名稱")
                                Text("\(user.displayName ?? "nil")")
                                    .font(.largeTitle)
                                
                            }
                            Spacer()
                            Text("進入遊戲")
                                .font(.largeTitle)
                        }
                    }
                    
            })
        }.onAppear(
            perform:{
                userPhotoURL = (currentUser?.photoURL)
                if let user = Auth.auth().currentUser {
                    
                    userName = user.displayName ?? "nil"
                    
                }
                
                
                
            })
        
        
    }
}

struct CharacterView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterView()
    }
}
