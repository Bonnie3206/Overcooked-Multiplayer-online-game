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

func createRoom(name:String,password:String,start:Bool,player1:String, player2:String,player3:String,quantity: Int,preparedQuantity:Int) {
            let db = Firestore.firestore()
            
    let creatingRoom = WaitingRoom(name:name, password:password, start: start,player1 :player1,player2 :player2, player3: player3,quantity:quantity, preparedQuantity:preparedQuantity)
        
            do {
                try db.collection("waitingRoom").document("\(name)").setData(from: creatingRoom)
            } catch {
                print(error)
            }
}
func createCharacterPositon(name:String,x:CGFloat,y:CGFloat) {
            let db = Firestore.firestore()
            
    let location = Location(name: name,x:x,y:y)
        
            do {
                try db.collection("location").document("\(location.name)").setData(from: location)
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
                var room = try? document.data(as: WaitingRoom.self)
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
            var room = try? document.data(as: WaitingRoom.self)
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
            var room = try? document.data(as: WaitingRoom.self)
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
func minusQuantity() {
        let db = Firestore.firestore()
        let documentReference =
            db.collection("map").document("room")
        documentReference.getDocument { document, error in
                        
          guard let document = document,
                document.exists,
                var map = try? document.data(as: Map.self)
          else {
                    return
          }
            map.quantity -= 1
          do {
             try documentReference.setData(from: map)
          } catch {
             print(error)
          }
                        
        }
}
func setLocation(location: Location) {//更新狀態 沒用到
    let db = Firestore.firestore()
        
    do {
        try db.collection("location").document(location.name).setData(from: location)
    } catch {
        print(error)
    }
}/*
func getLocation(userName:String){//取得位置
    
    let db = Firestore.firestore()
    db.collection("location").document("\(userName)").addSnapshotListener { snapshot, error in
        
        guard let snapshot = snapshot else { return }
        guard let location = try? snapshot.data(as: Location.self) else { return }
        offset = CGSize(width: location.x, height: location.y)
        
    }

}*/

//no use
func fetchPlayers() {//no use
    let db = Firestore.firestore()
    db.collection("location").getDocuments { snapshot, error in
            
         guard let snapshot = snapshot else { return }
        
         let location = snapshot.documents.compactMap { snapshot in
             try? snapshot.data(as: Location.self)
         }
        //print(location.first?.name)
        
        print(location)
        //print(location)
        
            
     }
}


