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

func createCharacter(name:String,URLString:URL,bestCoin_map1:Int,coin:Int) {
    let db = Firestore.firestore()
    //name: characterName, gender: genderSelect,coins: 0
    let userData = PlayerData(name:name,URLString:URLString,coin:coin, bestCoin_map1:bestCoin_map1)
    do {
        try db.collection("UserData").document("\(name)").setData(from: userData)
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

func setPlayerCoin(UserData: PlayerData) {
    let db = Firestore.firestore()
        
    do {
        try db.collection("UserData").document(UserData.name).setData(from: UserData)
    } catch {
        print(error)
    }
}
func ModifyChararcterName(roomName:String,name:String,URLSting:String) {
        let db = Firestore.firestore()
        let documentReference =
            db.collection("waitingRoom").document("\(roomName)")
        documentReference.getDocument { document, error in
                        
          guard let document = document,
                document.exists,
                var modifyChararcter = try? document.data(as: RoomState.self)
          else {
                    return
          }
            //存url
            if modifyChararcter.player2==""{
                
                modifyChararcter.URL_player2 = "\(URLSting)"
            }else if modifyChararcter.player3==""{
                modifyChararcter.URL_player3 = "\(URLSting)"
            }
            //存名字
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

