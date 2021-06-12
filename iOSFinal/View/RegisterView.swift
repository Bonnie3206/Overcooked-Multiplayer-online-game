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
    @State var goStartView = false
    @State private var showAlert = false
    @State private var showErrorAlert = false
    @State private var alertContent = ""
    @State private var regsiterStatus = RegsiterStatus.error
    
    @State var searchRoomName: String

    
    
    
    var body: some View {
        HStack{
            Image("cook2")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
            VStack{
                Form{
                    Section(header: Text("使用者帳號(mail)"))
                    {
                        TextField("請輸入帳號",text:$playerRegisterMail)
                            //.textFieldStyle(RoundedBorderTextFieldStyle())
                                            .frame(width: 200)
                    }
                    Section(header: Text("密碼"))
                    {
                        TextField("請輸入密碼",text:$playerRegisterPassword)
                            //.textFieldStyle(RoundedBorderTextFieldStyle())
                                            .frame(width: 200)
                    }
                }
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
        //goStartView = true
        
    }, label: {
        Text("註冊")
    }).alert(isPresented: $showAlert) { () -> Alert in
        
        Alert(title: Text("\(alertContent)"), message: Text(""), dismissButton: .default(Text("確定"), action: {
            
            if regsiterStatus == .ok {
                goStartView = true
            } else {
                
            }
        }))
    }
            }
        }
        .fullScreenCover(isPresented: $goStartView, content: {
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
