//
//  ContentView.swift
//  iOSFinal
//
//  Created by CK on 2021/4/14.
//UIImage合成的圖片
//metadatad要補充的資料，可有可無
//background thread:有網路的 會比較慢;main thread:沒網的一次執行一個 先執行完 @escaping fun跑完還是可以讀取資料
//照片:snap讓玩家合成後 存成UIImage 再upload
//conpactMap{要取的內容}，把nil去掉
//firebase抓下的型別都是不好用的 要去轉型別
//whereField去抓user id就可曲玩家資料
//即時更新 ：持續偵測 collection 下的 document 是否有新增，刪除，修改 ＝＝＝.addSnapshotListener
//文件id直接存user id


import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseStorageSwift//要有swift的,才有result

struct ContentView: View {
    func uploadPhoto(image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
            
            let fileReference = Storage.storage().reference().child(UUID().uuidString + ".jpg")
            if let data = image.jpegData(compressionQuality: 0.9) {
                
                fileReference.putData(data, metadata: nil) { result in
                    switch result {
                    case .success(_):
                        fileReference.downloadURL { result in
                            switch result {
                            case .success(let url)://result省略result.success
                                completion(.success(url))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
    }
    var body: some View {
        Button(action: {
                if let user = Auth.auth().currentUser {
                    print("\(user.uid) login")
                } else {
                    print("not login")
                }
                Auth.auth().signIn(withEmail: "0504@gmail.com", password: "1100504") { result, error in
            guard error == nil else {
               print(error?.localizedDescription)
               return
            }
            print("S")
        }}, label: {Text("signIn")})
        
        Button(action: {
            Auth.auth().createUser(withEmail: "0504@gmail.com", password: "1100504") { result, error in
                        
                 guard let user = result?.user,
                       error == nil else {
                     print(error?.localizedDescription)
                     return
                 }
                 print(user.email, user.uid)
            }
        }, label: {Text("register")})
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
