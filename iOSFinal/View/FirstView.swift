//
//  FirstView.swift
//  iOSFinal
//
//  Created by CK on 2021/6/7.
//帳號Test1234@gmail.com密碼12341234
//帳號Test2222@gmail.com密碼22222222
//帳號Test0000@gmail.com密碼00000000

import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseStorageSwift//要有swift的,才有result
import Kingfisher
import FirebaseFirestoreSwift
import Firebase
import AppTrackingTransparency


struct FirstView: View {
    @State var goCharacterSet = false
    @State var goRegisterView = false
    @State var playerSignInMail: String
    @State var playerSignInPassword: String
    @State private var goCharacterView = false
    @StateObject var authorization = Authorization()
    
    @State var searchRoomName: String
    
    var body: some View {
        VStack{
            VStack{
                Text("Overcooked")
                    .font(.largeTitle)
                HStack{
                    Image("cook")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                    
                   
                    Form{
                        Section(header: Text("使用者帳號(mail)"))
                        {
                            TextField("請輸入帳號",text:$playerSignInMail)
                        }
                        Section(header: Text("密碼"))
                        {
                            TextField("請輸入密碼",text:$playerSignInPassword)
                        }
                    }
                }
                
                HStack{
                    Button(action: {Auth.auth().signIn(withEmail: "\(playerSignInMail)", password: "\(playerSignInPassword)") { result, error in
                        guard error == nil else {
                           print(error?.localizedDescription)
                           return
                        }
                        print("S")
                        //是否登入
                        if let user = Auth.auth().currentUser {
                            print("\(user.uid) login")
                            
                            print(user.uid, user.email, user.displayName, user.photoURL)
                            if user.displayName == nil{
                                goCharacterSet = true
                            }else{
                                goCharacterView = true
                            }
                            
                            
                        } else {
                            print("not login")
                        }
                    }}, label: {Text("登入   ")
                        .font(.largeTitle)
                    })
                    
                    Button(action:{
                        Text("say:\"1234\"")
                        goRegisterView = true
                    }
                   , label: {
                        Text("   註冊")
                            .font(.largeTitle)
                   })
                    
                }
            }
            
            
        }.onAppear(perform: {
            authorization.requestTracking()
        })
        EmptyView().sheet(isPresented: $goRegisterView, content: {
            RegisterView(playerRegisterMail: "", playerRegisterPassword: "", searchRoomName: "")
        })
        EmptyView().sheet(isPresented: $goCharacterSet, content:{CharacterSetView(searchRoomName: "")})
        EmptyView().sheet(isPresented: $goCharacterView, content:{EnterRoomView(roomName: "", creatRoomName: "", SearchRoomName: "", searchRoomPassword: "", crearhRoomPassword: "")})
        
        
        
    }
}

struct FirstView_Previews: PreviewProvider {
    static var previews: some View {
        FirstView(playerSignInMail: "", playerSignInPassword: "", searchRoomName: "")
            .previewLayout(.fixed(width: 844, height: 390))
            .previewDevice("iPhone 11")
    }
}
