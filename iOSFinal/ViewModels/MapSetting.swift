//
//  MapSetting.swift
//  iOSFinal
//
//  Created by CK on 2021/6/13.
//
import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseStorageSwift//要有swift的,才有result
import Kingfisher
import FirebaseFirestoreSwift
import Firebase
import Combine
import GoogleMobileAds

func createRoom(name:String,password:String,start:Bool,player1:String, player2:String,player3:String,quantity: Int,preparedQuantity:Int,URL_player1 :String,URL_player2 :String,URL_player3 :String) {
            let db = Firestore.firestore()
            
    let creatingRoom = RoomState(name:name, password:password, start: start,player1 :player1,player2 :player2, player3: player3,quantity:quantity, preparedQuantity:preparedQuantity,URL_player1 :URL_player1,URL_player2 :URL_player2,URL_player3 :URL_player3)
        
            do {
                try db.collection("waitingRoom").document("\(name)").setData(from: creatingRoom)
            } catch {
                print(error)
            }
}

func createFood(room: String, vegetable : Int,tomato : Int,cutVegetable : Int,cutTomato:Int,cutVegetableForCook:Int,cutTomatoForCook : Int,cookingVegetableNum : Int, cookingTomatoNum : Int,orderVegetableNum : Int,orderTomatoNum:Int,coin : Int,tapTimes_washTomato:Int,tapTimes_washVegetable:Int,gameStart:Int) {
            let db = Firestore.firestore()
            
    let food = Food(room: room, vegetable : vegetable,tomato : tomato,cutVegetable : cutVegetable,cutTomato:cutTomato,cutVegetableForCook:cutVegetableForCook,cutTomatoForCook : cutTomatoForCook,cookingVegetableNum : cookingVegetableNum, cookingTomatoNum : cookingTomatoNum,orderVegetableNum : orderVegetableNum,orderTomatoNum:orderTomatoNum,coin : coin,tapTimes_washVegetable:tapTimes_washVegetable, tapTimes_washTomato:tapTimes_washTomato,gameStart:gameStart)
        
            do {
                try db.collection("food").document("\(food.room)").setData(from: food)
            } catch {
                print(error)
            }
}
func addPreparedQuantity(room:String) {
        let db = Firestore.firestore()
        let documentReference =
            db.collection("waitingRoom").document("\(room)")
        documentReference.getDocument { document, error in
                        
          guard let document = document,
                document.exists,
                var room = try? document.data(as: RoomState.self)
          else {
                    return
          }
            room.preparedQuantity+=1
          do {
             try documentReference.setData(from: room)
          } catch {
             print(error)
          }
                        
        }
}
func minusPreparedQuantity(room:String) {
    let db = Firestore.firestore()
    let documentReference =
        db.collection("waitingRoom").document("\(room)")
    documentReference.getDocument { document, error in
                    
      guard let document = document,
            document.exists,
            var room = try? document.data(as: RoomState.self)
      else {
                return
      }
        room.preparedQuantity-=1
      do {
         try documentReference.setData(from: room)
      } catch {
         print(error)
      }
                    
    }
}
func addQuantity(room:String) {//因firebase更新速度問題無法同時使用,此功能寫在ModifyChararcterName內
    let db = Firestore.firestore()
    let documentReference =
        db.collection("waitingRoom").document("\(room)")
    documentReference.getDocument { document, error in
                    
      guard let document = document,
            document.exists,
            var room = try? document.data(as: RoomState.self)
      else {
                return
      }
        room.quantity+=1
        print("addQuantity")
      do {
         try documentReference.setData(from: room)
      } catch {
         print(error)
      }
                    
    }
}
func minusQuantity(room:String) {//因firebase更新速度問題無法同時使用,此功能寫在ModifyChararcterName內
    let db = Firestore.firestore()
    let documentReference =
        db.collection("waitingRoom").document("\(room)")
    documentReference.getDocument { document, error in
                    
      guard let document = document,
            document.exists,
            var room = try? document.data(as: RoomState.self)
      else {
                return
      }
        room.quantity-=1
        print("minusQuantity")
      do {
         try documentReference.setData(from: room)
      } catch {
         print(error)
      }
                    
    }
}
func setLocation(location: Location) {
    let db = Firestore.firestore()
        
    do {
        try db.collection("location").document(location.name).setData(from: location)
    } catch {
        print(error)
    }
}
func setFood(food: Food) {
    let db = Firestore.firestore()
        
    do {
        try db.collection("food").document(food.room).setData(from: food)
    } catch {
        print(error)
    }
}
struct ImageView: View {
    @ObservedObject var imageLoader:ImageLoader
    @State var image:UIImage = UIImage()

    init(withURL url:String) {
        imageLoader = ImageLoader(urlString:url)
    }

    var body: some View {
        
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .onReceive(imageLoader.didChange) { data in
                self.image = UIImage(data: data) ?? UIImage()
        }
    }
}

class ImageLoader: ObservableObject {
    var didChange = PassthroughSubject<Data, Never>()
    var data = Data() {
        didSet {
            didChange.send(data)
        }
    }

    init(urlString:String) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.data = data
            }
        }
        task.resume()
    }
}
class RewardedAdController: NSObject {
    private var ad: GADRewardedAd?

    func loadAd() {
            let request = GADRequest()
            GADRewardedAd.load(withAdUnitID: "ca-app-pub-3940256099942544/1712485313", request: request){ad, error in
                if let error = error {
                        print(error)
                        return
                }
                ad?.fullScreenContentDelegate = self
                self.ad = ad
            }

    }

    func showAd() {
        if let ad = ad,
           let controller = UIViewController.getLastPresentedViewController() {

            ad.present(fromRootViewController: controller) {
            }
        }
    }
}





