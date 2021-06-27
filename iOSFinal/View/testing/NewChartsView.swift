//
//  NewChartsView.swift
//  iOSFinal
//
//  Created by CK on 2021/6/28.
//
import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseStorageSwift//要有swift的,才有result
import Kingfisher
import FirebaseFirestoreSwift
import Firebase
import AVFoundation

struct NewChartsView: View {
    
    @State private var chartName = [String](repeating: "", count:6)
    @State private var chartCoin = [Int](repeating: 0, count:6)
    @State private var goFirstView = false
    
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
                        .frame(width: 170, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    
                    Text("排行榜")
                        .font(.system(size: 30, weight: .regular, design: .monospaced))
                }
                ZStack{
                    Rectangle()
                        .foregroundColor(.white)
                        .opacity(0.99)
                        .cornerRadius(30)
                        .frame(width: 310, height: 290, alignment: .center)
                        .offset(x:0,y:0)
                    HStack{
                            VStack{
                                Text("排行")
                                    .padding(.bottom)
                                    .font(.system(size: 25, weight: .regular, design: .monospaced))
                                ForEach(0..<5){ (i) in
                                    Text(String( i + 1))
                                        .padding(.bottom)
                                        .font(.system(size: 20, weight: .regular, design: .monospaced))
                                }
                            }
                            
                            VStack{
                                Text("玩家")
                                    .padding(.bottom)
                                    .font(.system(size: 25, weight: .regular, design: .monospaced))
                                Text("Test0000")
                                    .padding(.bottom)
                                    .font(.system(size: 20, weight: .regular, design: .monospaced))
                                Text("Test6666")
                                    .padding(.bottom)
                                    .font(.system(size: 20, weight: .regular, design: .monospaced))
                                Text("Test3210")
                                    .padding(.bottom)
                                    .font(.system(size: 20, weight: .regular, design: .monospaced))
                                Text("Test1234")
                                    .padding(.bottom)
                                    .font(.system(size: 20, weight: .regular, design: .monospaced))
                                Text("Test77777")
                                    .padding(.bottom)
                                    .font(.system(size: 20, weight: .regular, design: .monospaced))
                            }
                            VStack{
                                Text("金幣")
                                    .padding(.bottom)
                                    .font(.system(size: 25, weight: .regular, design: .monospaced))
                                Text("3700")
                                    .padding(.bottom)
                                    .font(.system(size: 20, weight: .regular, design: .monospaced))
                                Text("1100")
                                    .padding(.bottom)
                                    .font(.system(size: 20, weight: .regular, design: .monospaced))
                                Text("700")
                                    .padding(.bottom)
                                    .font(.system(size: 20, weight: .regular, design: .monospaced))
                                Text("600")
                                    .padding(.bottom)
                                    .font(.system(size: 20, weight: .regular, design: .monospaced))
                                Text("400")
                                    .padding(.bottom)
                                    .font(.system(size: 20, weight: .regular, design: .monospaced))

                            }
                        }
                }
                
                Button(action: {
                    goFirstView = true
                }, label: {
                    Text("回到首頁")
                        .padding(7)
                        .padding(.horizontal, 25)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal, 10)
                        .frame(width: 400, height: 50, alignment: .center)
                        .offset(x:0,y:0)
                })
                
            }
            
        }.onAppear(perform: {
            
            let db = Firestore.firestore()
            db.collection("UserData").order(by: "coin", descending: true).limit(to: 5).getDocuments { snapshot, error in
                
                if let error = error{
                    print("Error")
                }else{
                    var i = 4
                    for document in snapshot!.documents{
                        
                        db.collection("UserData").document("\(document.documentID)").getDocument { document, error in
                                            
                             guard let document = document,
                                   document.exists,
                                   let player = try? document.data(as: PlayerData.self) else {
                                  return
                             }
                            chartName[i] = document.documentID
                            chartCoin[i] = player.coin
                            i -= 1
                            print("document:\(document.documentID)")
                            print("coin:\(player.coin)")
                        }
                    }
                }
            }
            
        })
        EmptyView().sheet(isPresented: $goFirstView,content:{FirstView(playerSignInMail: "", playerSignInPassword: "", searchRoomName: "")})
    }
}

struct NewChartsView_Previews: PreviewProvider {
    static var previews: some View {
        NewChartsView()
    }
}

