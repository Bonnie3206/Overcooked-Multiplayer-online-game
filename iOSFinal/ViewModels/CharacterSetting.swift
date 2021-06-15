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
}/*
func getURLSting(name:String)throws -> String{//沒用 問怎麼return值
    
        let db = Firestore.firestore()
        var urll = ""
        db.collection("UserData").document("\(name)").getDocument { document, error in
              
            
            guard let document = document,document.exists,
                   var userData = try? document.data(as: PlayerData.self) else {return()}
            do{
                print("myURL:\(userData.URLString)")
                urll = "\(userData.URLString)"
                print("內:\(urll)")
                //return urll
            }
            
        }
    urll = "1"
    print("外圍:\(urll)")
    return urll
}
*/
func getURLSting(name:String){//從creatCharacter(in CharacterSet)讀取後存入room(in CharacterView)
    let db = Firestore.firestore()
    var urll = ""
    db.collection("UserData").document("\(name)").getDocument { document, error in
          
        
        guard let document = document,document.exists,
               var userData = try? document.data(as: PlayerData.self) else {return()}
        do{
            print("myURL:\(userData.URLString)")
            urll = "\(userData.URLString)"
            print("內:\(urll)")
            //return urll
        }
        
    }
}/*
func saveURLtoRoom(roomName:String,URLSting:String){//從creatCharacter(in CharacterSet)讀取後存入room(in CharacterView)
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
            
            modifyChararcter.URL_player2 = "\(URLSting)"
        }else if modifyChararcter.player3==""{
            modifyChararcter.URL_player3 = "\(URLSting)"
        }
      do {
         try documentReference.setData(from: modifyChararcter)
      } catch {
         print(error)
      }
                    
    }
    
}*/
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
