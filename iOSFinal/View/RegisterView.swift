//
//  RegisterView.swift
//  iOSFinal
//
//  Created by CK on 2021/5/5.
//問題：帳號自首強迫大寫？/密碼不能隱藏
import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseStorageSwift//要有swift的,才有result

enum RegsiterStatus {
    case ok
    case error
}

struct RegisterView: View {
    @State var playerRegisterMail: String
    @State var playerRegisterPassword: String
    @State var goFirstView = false
    @State private var showAlert = false
    @State private var showErrorAlert = false
    @State private var alertContent = ""
    @State private var regsiterStatus = RegsiterStatus.error
    
    @State var searchRoomName: String

    
    
    
    var body: some View {
        ZStack{
            Image("房間背景")
                .resizable()
                .scaledToFit()
                .scaleEffect(1.1)
            HStack{
                
                VStack{
                    ZStack{
                        Image("標題")
                            .resizable()
                            .scaledToFit()
                            .scaleEffect(1.5)
                            .frame(width: 270, height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        Text("帳號註冊")
                            .font(.system(size: 45, weight: .regular, design: .monospaced))
                            .offset(x: 0, y: 10)
                    }
                    HStack{
                        
                        VStack{
                            Text("使用者帳號(mail)")
                                .font(.system(size: 25, weight: .regular, design: .monospaced))
                            ZStack{
                                Rectangle()
                                    .foregroundColor(.white)
                                    .opacity(0.99)
                                    .cornerRadius(30)
                                    .frame(width: 300, height: 40, alignment: .center)
                                    .offset(x:0,y:0)
                                TextField("請輸入帳號",text:$playerRegisterMail)
                                    .font(.system(size: 18, weight: .regular, design: .monospaced))
                                    .offset(x: 300, y: 0)
                            }
                            Text("密碼")
                                .font(.system(size: 25, weight: .regular, design: .monospaced))
                            ZStack{
                                Rectangle()
                                    .foregroundColor(.white)
                                    .opacity(0.99)
                                    .cornerRadius(30)
                                    .frame(width: 270, height: 40, alignment: .center)
                                    .offset(x:0,y:0)
                                
                                TextField("請輸入密碼",text:$playerRegisterPassword)
                                    .font(.system(size: 18, weight: .regular, design: .monospaced))
                                    .offset(x: 300, y: 0)
                            }
                        }
                    }
                    HStack{
                        Button(action: {
                            goFirstView = true
                        }, label: {
                            Text("回到上頁")
                                .padding(7)
                                .padding(.horizontal, 25)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .padding(.horizontal, 10)
                        })
                        Button(action: {
                            Auth.auth().createUser(withEmail: "\(playerRegisterMail)", password: "\(playerRegisterPassword)") { result, error in
                    
                                guard let user = result?.user,
                                      error == nil else {
                                    print(error?.localizedDescription)
                                    showAlert = true
                                    regsiterStatus = RegsiterStatus.error
                                    alertContent = "註冊失敗：\(error?.localizedDescription)"
                        
                                    return
                                }
                                print(user.email, user.uid)
                                showAlert = true
                                regsiterStatus = .ok
                                alertContent = "註冊成功！"
                   
                                }
                        }, label: {
                            Text("註冊")
                                .padding(7)
                                .padding(.horizontal, 25)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .padding(.horizontal, 10)
                        })
                    }.alert(isPresented: $showAlert) { () -> Alert in
                
                        Alert(title: Text("\(alertContent)"), message: Text(""), dismissButton: .default(Text("確定"), action: {
                    
                            if regsiterStatus == .ok {
                                goFirstView = true
                            } else {
                        
                            }
                        }))
                    }
                        
                }
                    
            }
        }
        .fullScreenCover(isPresented: $goFirstView, content: {
            FirstView(playerSignInMail: "", playerSignInPassword: "", searchRoomName: "")
        })
    
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(playerRegisterMail: "", playerRegisterPassword: "", searchRoomName: "")
            .previewLayout(.fixed(width: 844, height: 390))
            .previewDevice("iPhone 11")
    }
}
