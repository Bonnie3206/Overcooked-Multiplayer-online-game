//
//  CharacterSetting.swift
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

func createCharacter(name:String,URLString:URL,action:String,x:Int,y:Int,coin:Int) {
    let db = Firestore.firestore()
    //name: characterName, gender: genderSelect,coins: 0
    let userData = PlayerData(name: name,URLString:URLString,action:action,x : x, y :y,coin:coin)
    do {
        try db.collection("UserData").document("\(name)").setData(from: userData)
    } catch {
        print(error)
    }
}

func ModifyChararcterName(roomName:String,name:String) {
        let db = Firestore.firestore()
        let documentReference =
            db.collection("waitingRoom").document("\(roomName)")
        documentReference.getDocument { document, error in
                        
          guard let document = document,
                document.exists,
                var modifyChararcter = try? document.data(as: WaitingRoom.self)
          else {
                    return
          }
            if modifyChararcter.player2==""{
                
                modifyChararcter.player2 = "\(name)"
            }else if modifyChararcter.player3==""{
                modifyChararcter.player3 = "\(name)"
            }
            modifyChararcter.quantity += 1
            
          do {
             try documentReference.setData(from: modifyChararcter)
          } catch {
             print(error)
          }
                        
        }
}
