//
//  SettingView.swift
//  iOSFinal
//
//  Created by CK on 2021/6/26.
//

import SwiftUI
import AVFoundation

struct SettingView: View {
    @State var goFirstView = false
    @State var sound = 0.5
    
    var body: some View {
        ZStack{
            Image("房間背景")
                .resizable()
                .scaledToFit()
                .scaleEffect(1.1)
            VStack{
                Text("設定")
                    .font(.system(size: 45, weight: .regular, design: .monospaced))
                    .offset(x: -40, y: 40)
                HStack{
                    Image("聽音樂")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 280)
                        .cornerRadius(500)
                        .offset(x: -100, y: 0)
                    
                    Button(action: {
                        
                        if sound <= 0{
                            sound = 0
                        }else{
                            sound -= 0.05
                        }
                        AVPlayer.bgQueuePlayer.volume = Float(sound)
                    }, label: {
                        Image(systemName: "speaker.slash.fill")
                            .scaleEffect(3)
                    }).offset(x: -80, y: 0)
                    
                    ZStack{
                        Image("進度條")
                            .resizable()
                            .scaledToFit()
                            .scaleEffect(1.5)
                            .frame(width: 250, height: 30)
                            .offset(x: 0, y: 0)
                        
                        Image("紅點去背")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .offset(x: -130+280*CGFloat(sound), y: 0)
                    }
                    
                    Button(action: {
                        
                        if sound >= 1{
                            sound = 1
                        }else{
                            sound += 0.05
                        }
                        AVPlayer.bgQueuePlayer.volume = Float(sound)
                        
                    }, label: {
                        Image(systemName: "speaker.wave.2.fill")
                            .scaleEffect(3)
                    }).offset(x: 80, y: 0)
                }
                Button(action: {
                    goFirstView = true
                }, label: {
                    Text("回到上頁")
                        .padding(7)
                        .padding(.horizontal, 25)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal, 10)
                })
            }
        }
        EmptyView().sheet(isPresented: $goFirstView, content:{FirstView(playerSignInMail: "", playerSignInPassword: "", searchRoomName: "")})
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
