//
//  CharacterSetView.swift
//  iOSFinal
//
//  Created by CK on 2021/5/5.
//
import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseStorageSwift//要有swift的,才有result
import Kingfisher
import FirebaseFirestoreSwift
import Firebase

extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        
        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        
        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}

struct CharacterSetView: View {
    
    @State private var goCharacterView = false
    @State private var uiImage: UIImage?
    @State private var changeFace = "face1"
    @State private var changeBody = "body1"
    @State private var changeHair = "hair1"
    @State private var num = 0
    @State private var hairNum = 0
    @State private var bodyNum = 0
    @State private var faceNum = 0
    @State private var hairTotal = 45
    @State private var bodyTotal = 29
    @State private var faceTotal = 29
    @State private var characterName = ""
    @State private var genderSelect = ""
    var gender = ["男", "女"]
    
    
    
    func createCharacter() {//創造角色
        let db = Firestore.firestore()
            
        let userData = Character(name: characterName, gender: genderSelect,start: 0 )
            do {
                let documentReference = try db.collection("UserData").addDocument(from: userData)
                do {
                    try db.collection("UserData").document(characterName).setData(from: userData)
                    
                } catch {
                    print(error)
                }
                print(documentReference.documentID)
            } catch {
                print(error)
            }
    }
    
    var demoView: some View {
        VStack {
            
            ZStack{
                
                Image(changeHair)
                    .resizable()
                    .frame(width: 200, height: 200)
                    .scaledToFill()
                    
                    .offset(x:0,y:35)
                
                Image(changeFace)
                    .resizable()
                    .frame(width: 200, height: 200)
                    .scaledToFill()
                    .clipShape(Circle())
                    .scaleEffect(0.55)
                    .offset(x:17,y:53)
                
            }
            
            Image(changeBody)
                .resizable()
                .frame(width: 200, height: 200)
                .scaledToFill()
                
            
        }
        //.background(Color.white)
    }
    var body: some View {
        VStack{
            HStack{
                Image("角色設定title")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                Text("來設定遊戲角色吧!")
                    .font(.largeTitle)
            }
            HStack{
                
                if let uiImage = uiImage {
                    Image(uiImage: uiImage)
                }
                VStack{
                    HStack {
                      
                        Button(action: {
                            if faceNum > 1{
                                faceNum -= 1
                            }
                            changeFace = "face\(faceNum)"
                            uiImage = demoView.snapshot()
                            //UIImageWriteToSavedPhotosAlbum(uiImage!, nil, nil, nil)
                        }, label: {
                            Image(systemName: "chevron.backward.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                        //.foregroundColor(.purple)
                        })
                        Text("face")
                        Button(action: {
                            
                            if faceNum < faceTotal{
                                faceNum += 1
                                
                            }
                            changeFace = "face\(faceNum)"
                            uiImage = demoView.snapshot()
                            //UIImageWriteToSavedPhotosAlbum(uiImage!, nil, nil, nil)
                            
                            
                        }, label: {
                            Image(systemName: "chevron.right.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                        //.foregroundColor(.purple)
                        })
                        
                    }
                    HStack {
                        
                        Button(action: {
                            if bodyNum > 1{
                                bodyNum -= 1
                            }
                            changeBody = "body\(bodyTotal)"
                            uiImage = demoView.snapshot()
                            //UIImageWriteToSavedPhotosAlbum(uiImage!, nil, nil, nil)
                        }, label: {
                            Image(systemName: "chevron.backward.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                        //.foregroundColor(.purple)
                        })
                        Text("body")
                        Button(action: {
                            
                            if bodyNum < bodyTotal{
                                bodyNum += 1
                            }
                            changeBody = "body\(bodyNum)"
                            uiImage = demoView.snapshot()
                           // UIImageWriteToSavedPhotosAlbum(uiImage!, nil, nil, nil)
                            
                            
                        }, label: {
                            Image(systemName: "chevron.right.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                        //.foregroundColor(.purple)
                            
                        })
                        
                    }
                    HStack {
                       
                        Button(action: {
                            if hairNum > 0{
                                hairNum -= 1
                            }
                            changeHair = "hair\(hairNum)"
                            uiImage = demoView.snapshot()
                           //UIImageWriteToSavedPhotosAlbum(uiImage!, nil, nil, nil)
                        }, label: {
                            Image(systemName: "chevron.backward.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                        //.foregroundColor(.purple)
                        })
                        Text("hair")
                        Button(action: {
                            
                            if hairNum < hairTotal{
                                hairNum += 1
                                
                            }
                            changeHair = "hair\(hairNum)"
                            uiImage = demoView.snapshot()
                            //UIImageWriteToSavedPhotosAlbum(uiImage!, nil, nil, nil)
                            
                            
                        }, label: {
                            Image(systemName: "chevron.right.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                        //.foregroundColor(.purple)
                        })
                        
                    }
                    Button(action: {
                        changeFace = ["face1", "face2","face3","face4","face5","face6","face7","face9","face10"].randomElement()!
                        changeBody = ["body1", "body2"].randomElement()!
                        changeHair = ["hair1", "hair2"].randomElement()!
                        uiImage = demoView.snapshot()
                        //UIImageWriteToSavedPhotosAlbum(uiImage!, nil, nil, nil)
                    }, label: {
                        Text("隨機")
                    })
                }
                
                
            }
            HStack{
                Image("角色設定icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 50)
                TextField("請輸入名稱",text:$characterName)
                    .frame(width: 300)
            }
            HStack{
                Image("角色設定icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 50)
//**tag/SegmentedPickerStyle()
                Picker(selection: $genderSelect, label: Text("性別")) {
                    Text(gender[0]).tag(0)
                    Text(gender[1]).tag(1)
                                                
                }.pickerStyle(SegmentedPickerStyle())
                .frame(width: 300)
                .shadow(radius: 5)
                //Text("\(genderSelect)")
                
            }
            Spacer()
            Button(action:{
                createCharacter()
                uiImage = demoView.snapshot()
                UIImageWriteToSavedPhotosAlbum(uiImage!, nil, nil, nil)
                
                uploadPhoto(image: uiImage!) { result in
                    switch result {
                    case .success(let url):
                       setUserPhoto(url: url)
                        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                        
                        changeRequest?.displayName = "\(characterName)"
                        changeRequest?.commitChanges(completion: { error in
                           guard error == nil else {
                               print(error?.localizedDescription)
                               return
                           }
                                            
                        })
                        goCharacterView = true
                        print("success")
                        
                    case .failure(let error):
                       print(error)
                    }
                }
                
            } , label: {
                
                Text("確定")
                    .font(.largeTitle)
            })
            
        }.onAppear(perform:{
            changeFace = "face1"
            changeBody = "body1"
            changeHair = "hair1"
            uiImage = demoView.snapshot()
        }
      )
        .fullScreenCover(isPresented: $goCharacterView, content: {
            CharacterView()
        })
        
        
    }
}

struct CharacterSetView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterSetView()
    }
}
