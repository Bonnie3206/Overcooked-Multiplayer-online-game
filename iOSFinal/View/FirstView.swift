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
    @State var showIntroduction = false
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
                            .padding(7)
                            .padding(.horizontal, 25)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .padding(.horizontal, 10)
                        
                    })
                    
                    Button(action:{
                        
                        goRegisterView = true
                    }
                   , label: {
                        Text("   註冊").padding(7)
                            .padding(.horizontal, 25)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .padding(.horizontal, 10)
                   })
                    Button(action:{
                        
                        showIntroduction = true
                    }
                   , label: {
                        Text("遊戲介紹")
                            .padding(7)
                            .padding(.horizontal, 25)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .padding(.horizontal, 10)
                   }).alert(isPresented: $showIntroduction) { () -> Alert in
                    
                    Alert(title: Text("遊戲介紹"), message: Text("1.遊戲由三個人進行\n 2.訂單完成需先洗菜，再將菜拿起到鍋子放下，若鍋子內的東西達成訂單上的需求，即可完成一道菜得分。\n3.三人可分工完成洗菜、拿菜、煮菜，以節省時間\n4.計分方式為：依訂單原料個數多寡計算，每完成一個訂單得分一次\n5.遊戲時間為三分鐘，最後可看個小廣告加分～"), primaryButton: .default(Text("了解"), action: {
                    }), secondaryButton: .default(Text("不了解，想試玩"), action: {
                    }))
                }
                    
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
