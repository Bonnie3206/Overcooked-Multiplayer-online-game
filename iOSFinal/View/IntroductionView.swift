//
//  IntroductionView.swift
//  iOSFinal
//
//  Created by CK on 2021/6/21.
//

import SwiftUI

struct IntroductionView: View {
    @State var goFirstView = false
    
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
                        .frame(width: 270, height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    Text("遊戲介紹")
                        .font(.system(size: 45, weight: .regular, design: .monospaced))
                }
                
                Text("1.遊戲由三個人進行。\n2.訂單完成需先洗菜，再將菜拿起到鍋子放下，\n  若鍋子內的東西達成訂單上的需求，即可完成一道菜得分。\n3.三人可分工完成洗菜、拿菜、煮菜，以節省時間。\n4.計分方式為：依訂單原料個數多寡計算，每完成一個訂單得分一次。\n5.遊戲時間為三分鐘，最後可看個小廣告加分～")
                    .font(.system(size: 25, weight: .regular, design: .monospaced))
                    .lineLimit(10)
                    .multilineTextAlignment(.leading)
                    .offset(x: 20, y: 0)
                Button(action: {
                    
                    goFirstView = true
                    
                }, label: {
                    Text("暸解了")
                        .padding(7)
                        .padding(.horizontal, 25)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal, 10)
                })
            }
            EmptyView().sheet(isPresented: $goFirstView, content:{FirstView(playerSignInMail: "", playerSignInPassword: "", searchRoomName: "")})
            
        }
    }
}

struct IntroductionView_Previews: PreviewProvider {
    static var previews: some View {
        IntroductionView()
    }
}
