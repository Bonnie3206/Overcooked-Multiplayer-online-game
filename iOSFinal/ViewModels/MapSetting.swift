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

func createRoom(name:String,password:String,start:Bool,player1:String, player2:String,player3:String,quantity: Int,preparedQuantity:Int,URL_player1 :String,URL_player2 :String,URL_player3 :String) {
            let db = Firestore.firestore()
            
    let creatingRoom = RoomState(name:name, password:password, start: start,player1 :player1,player2 :player2, player3: player3,quantity:quantity, preparedQuantity:preparedQuantity,URL_player1 :URL_player1,URL_player2 :URL_player2,URL_player3 :URL_player3)
        
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
/*
//水果有六個點 人就是自己而已 
//是否相交
func judgeIntersection(objectX: CGFloat, objectY: CGFloat, wordIndex: Int)->Int{
    let objectRect = CGRect(x: objectX, y: objectY, width: 100, height: 100)
    for index in (0..<answers[num-1].count){
        print(answers[num-1].count)
        //print("c\(wordIndex)")
        let targetRect = CGRect(x: qaData.nowAnswerFrameX[index], y: qaData.nowAnswerFrameY[index], width: 100, height: 100)
        print("\(index),\(qaData.answerFrame[index].origin.x),\(qaData.answerFrame[index].origin.y)")
        let interRect = objectRect.intersection(targetRect)
        if(interRect.width>=1 || interRect.height>=1){
            if(answers[num-1][index].isEqual(questions[num][wordIndex])){
                
                print("correct\(index)")
                print("correctNum\(correctNum)")
                
                return index
            }//放對位置
            else{
                return 200//放錯
            }
            
        }
    }
    
    return 100//沒放到
    
}*/




