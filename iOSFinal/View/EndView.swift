//
//  EndView.swift
//  iOSFinal
//
//  Created by CK on 2021/6/21.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseStorageSwift//要有swift的,才有result
import Kingfisher
import FirebaseFirestoreSwift
import Firebase
import AppTrackingTransparency
import AVFoundation
import GoogleMobileAds

struct EndView: View {
    
    @Binding var roomDocumentName:String
    @State private var turnURLString : String = ""
    
    @State private var currentUser = Auth.auth().currentUser
    @State private var userPhotoURL = URL(string: "")
    @State private var userName = ""
    
    @State private var roomCoins :Int = 0//此關得到的
    @State private var totalCoins :Int = 0//玩家累積
    @State private var newTotalCoins :Int = 0//玩家新累積
    @State private var bestCoin_map1 :Int = 0//map1中最佳得分
    
    @State private var goGameView = false
    @State private var showAdvertising = false
    @State private var showAdvertisingAlert = false
    
    @State private var ad:GADRewardedAd?
    
    func loadAd() {
        let request = GADRequest()
        

        GADRewardedAd.load(withAdUnitID: "ca-app-pub-3940256099942544/1712485313" , request: request) {ad, error in

            if let error = error {
                print(error)
                return
            }
            self.ad = ad
        }

    }
    func showAd() {
        if let ad = ad,
        let controller = UIViewController.getLastPresentedViewController() {

            ad.present(fromRootViewController: controller) {
                //得到多少錢
            }
        }
    }
    var body: some View {
        VStack{
            
            Text("此關得分:\(roomCoins)！")
                
            Button(action: {
                
                newTotalCoins = totalCoins + roomCoins
                if bestCoin_map1 < roomCoins{
                    bestCoin_map1 = roomCoins
                }
                setPlayerCoin(UserData: PlayerData(name: "\(userName)",URLString: userPhotoURL!, coin:newTotalCoins
                ,bestCoin_map1 :bestCoin_map1))
                
                goGameView = true
                
                
            }, label: {
                Text("再玩一次")
                    .padding(7)
                    .padding(.horizontal, 25)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal, 10)
            })
            Button(action: {
                showAdvertisingAlert = true
                
                
            }, label: {
                Text("看廣告加分")
                    .padding(7)
                    .padding(.horizontal, 25)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal, 10)
            }).alert(isPresented: $showAdvertisingAlert) { () -> Alert in
                
                Alert(title: Text("看廣告拿金幣500"), message: Text("要看完廣告才能得免費金幣喔"), dismissButton: .default(Text("確定"), action: {
                    
                    //showAd()
                    newTotalCoins = totalCoins + roomCoins
                    newTotalCoins += 500
                    if bestCoin_map1 < roomCoins{
                        bestCoin_map1 = roomCoins
                    }
                    setPlayerCoin(UserData: PlayerData(name: "\(userName)",URLString: userPhotoURL!, coin:newTotalCoins
                    ,bestCoin_map1 :bestCoin_map1))
                }))
            }
            
        }.onAppear(
            perform:{
               
                //取得角色資訊
                userPhotoURL = (currentUser?.photoURL)
                turnURLString = userPhotoURL!.absoluteString
                if let user = Auth.auth().currentUser {
                    userName = user.displayName ?? "nil"
                }
                //
                let db = Firestore.firestore()
                let queue = DispatchQueue(label: "com.appcoda.myqueue")
                
 //監聽玩家個別原始coin
                db.collection("UserData").document("\(userName)").addSnapshotListener { snapshot, error in
                    
                    guard let snapshot = snapshot else { return }
                    guard let player = try? snapshot.data(as: PlayerData.self) else { return }
                    
                    queue.sync{
                        totalCoins = Int(player.coin)
                        bestCoin_map1 = Int(player.bestCoin_map1)
                    }
                }
//監聽房間得分
                db.collection("food").document("\(roomDocumentName)").addSnapshotListener { snapshot, error in
                    
                    guard let snapshot = snapshot else { return }
                    guard let food = try? snapshot.data(as: Food.self) else { return }
                    
                    queue.sync{
                        roomCoins = Int(food.coin)
                    }
                }
                loadAd()
            })
        
        
        EmptyView().sheet(isPresented: $goGameView,content:{GameView(roomDocumentName: $roomDocumentName)})
    }
}

struct EndView_Previews: PreviewProvider {
    static var previews: some View {
        EndView(roomDocumentName: .constant("Room2"))
    }
}

