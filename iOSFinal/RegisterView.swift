//
//  RegisterView.swift
//  iOSFinal
//
//  Created by CK on 2021/5/5.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseStorageSwift//要有swift的,才有result

struct RegisterView: View {
    @State var playerRegisterMail: String
    @State var playerRegisterPassword: String
    @State var goStartView = false
    @State private var showAlert = false

    
    
    
    var body: some View {
        VStack{
            Image("cook2")
            Form{
                Section(header: Text("使用者帳號(mail)"))
                {
                    TextField("請輸入帳號",text:$playerRegisterMail)
                }
                Section(header: Text("密碼"))
                {
                    TextField("請輸入密碼",text:$playerRegisterPassword)
                }
            }
            Button(action: {
                Auth.auth().createUser(withEmail: "\(playerRegisterMail)", password: "\(playerRegisterPassword)") { result, error in
                            
                     guard let user = result?.user,
                           error == nil else {
                         print(error?.localizedDescription)
                         return
                     }
                     print(user.email, user.uid)
                     showAlert = true
                    
                }
                goStartView = true
                
            }, label: {Text("註冊")}).alert(isPresented: $showAlert) { () -> Alert in
                
                return Alert(title: Text("註冊成功"))
            }
            
            
            
            
        }
        .fullScreenCover(isPresented: $goStartView, content: {
            StartView(playerSignInMail: "", playerSignInPassword: "")
        })
    
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(playerRegisterMail: "", playerRegisterPassword: "")
    }
}
