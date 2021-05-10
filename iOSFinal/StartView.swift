//
//  StartView.swift
//  iOSFinal
//
//  Created by CK on 2021/5/5.
//12341234@gmail.com 12341234
import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseStorageSwift//要有swift的,才有result
import Kingfisher
import FirebaseFirestoreSwift
import Firebase

struct Character: Codable, Identifiable {
    @DocumentID var id: String?
    let name: String
    let gender: String
    let start : Int
    
}

struct StartView: View {
    /*func getCharacter() {//得到角色
            let db = Firestore.firestore()
            db.collection("songs").document("陪你很久很久").getDocument { document, error in
                        
                 guard let document = document,
                       document.exists,
                       let song = try? document.data(as: Song.self) else {
                      return
                 }
                 print(song)
                     
            }
    }
    func createCharacter() {//創造角色
            let db = Firestore.firestore()
            
            let song = Song(name: "陪你很久很久", singer: "小球", rate: 5)
            do {
                let documentReference = try db.collection("songs").addDocument(from: song)
                do {
                    try db.collection("UserData").document("陪你很久很久").setData(from: song)
                } catch {
                    print(error)
                }
                print(documentReference.documentID)
            } catch {
                print(error)
            }
    }*/
    @State var goCharacterSet = false
    @State var goRegisterView = false
    @State var playerSignInMail: String
    @State var playerSignInPassword: String
    @State private var goCharacterView = false
    
    var body: some View {
        VStack{
            VStack{
                Text("Overcooked")
                    .font(.largeTitle)
                Image("cook")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                /*KFImage(URL(string:"https://s.newtalk.tw/album/news/525/600516515a5e7.jpg"))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)*/
               
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
                        goRegisterView = true
                    }
                   , label: {
                        Text("   註冊")
                            .font(.largeTitle)
                   })
                    
                }
            }
            
            
        }/*(isPresented: $goRegisterView, content: {
            RegisterView(playerRegisterMail: "", playerRegisterPassword: "")
        })*/
        EmptyView().sheet(isPresented: $goRegisterView, content: {
            RegisterView(playerRegisterMail: "", playerRegisterPassword: "")
        })
        EmptyView().sheet(isPresented: $goCharacterSet, content:{CharacterSetView()})
        EmptyView().sheet(isPresented: $goCharacterView, content:{CharacterView()})
        
        
        
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView(playerSignInMail: "", playerSignInPassword: "")
    }
}
