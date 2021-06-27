//
//  FirstView.swift
//  iOSFinal
//
//  Created by CK on 2021/6/7.
//帳號Test1234@gmail.com密碼12341234
//帳號Test2222@gmail.com密碼22222222
//帳號Test0000@gmail.com密碼00000000
//帳號Test3333@gmail.com密碼00000000
//帳號Test4444@gmail.com密碼44444444
//帳號Test5555@gmail.com密碼55555555
//帳號Test6666@gmail.com密碼66666666
//帳號Test7777@gmail.com密碼77777777
//帳號Test11111@gmail.com密碼11111111

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
    @State var goIntroductionView = false
    @State var goSetting = false
    
    @State var playerSignInMail: String
    @State var playerSignInPassword: String
    @State private var goCharacterView = false
    @StateObject var authorization = Authorization()
    
    @State var searchRoomName: String
    
    var body: some View {
        ZStack{
            Image("房間背景")
                .resizable()
                .scaledToFit()
                .scaleEffect(1.1)
            VStack{
                ZStack{
                    Image("標題")
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(1.5)
                        .frame(width: 270, height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    Text("Overcooked")
                        .font(.system(size: 45, weight: .regular, design: .monospaced))
                        .offset(x: 0, y: 10)
                }
                Button(action: {
                    
                    goSetting = true
                    
                }, label: {
                    Image(systemName: "gearshape.fill")
                        .scaleEffect(3)
                })
                .offset(x: -375, y: -70)
                
                HStack{
                    
                    VStack{
                        Text("使用者帳號(mail)")
                            .font(.system(size: 25, weight: .regular, design: .monospaced))
                        ZStack{
                            Rectangle()
                                .foregroundColor(.white)
                                .opacity(0.99)
                                .cornerRadius(30)
                                .frame(width: 310, height: 40, alignment: .center)
                                .offset(x:0,y:0)
                            TextField("請輸入帳號",text:$playerSignInMail)
                                .font(.system(size: 18, weight: .regular, design: .monospaced))
                                .offset(x: 270, y: 0)
                        }
                        Text("密碼")
                            .font(.system(size: 25, weight: .regular, design: .monospaced))
                        ZStack{
                            Rectangle()
                                .foregroundColor(.white)
                                .opacity(0.99)
                                .cornerRadius(30)
                                .frame(width: 310, height: 40, alignment: .center)
                                .offset(x:0,y:0)
                            
                            TextField("請輸入密碼",text:$playerSignInPassword)
                                .font(.system(size: 18, weight: .regular, design: .monospaced))
                                .offset(x: 270, y: 0)
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
                    }}, label: {Text("登入")
                            .font(.system(size:24, weight: .regular, design: .monospaced))
                            .padding(7)
                            .padding(.horizontal, 38)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .offset(x: 0, y: 20)
                        
                    })
                    
                    Button(action:{
                        
                        goRegisterView = true
                    }
                   , label: {
                        Text("註冊")
                            .font(.system(size:24, weight: .regular, design: .monospaced))
                            .padding(7)
                            .padding(.horizontal, 38)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .offset(x: 0, y: 20)
                   })
                    Button(action:{
                        
                        goIntroductionView = true
                    }
                   , label: {
                        Text("遊戲介紹")
                            .font(.system(size:24, weight: .regular, design: .monospaced))
                            .padding(7)
                            .padding(.horizontal, 38)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .offset(x: 0, y: 20)
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
        EmptyView().sheet(isPresented: $goIntroductionView, content:{IntroductionView()})
        EmptyView().sheet(isPresented: $goSetting, content:{SettingView()})
        
        
        
        
    }
}

struct FirstView_Previews: PreviewProvider {
    static var previews: some View {
        FirstView(playerSignInMail: "", playerSignInPassword: "", searchRoomName: "")
            .previewLayout(.fixed(width: 844, height: 390))
            .previewDevice("iPhone 11")
    }
}
