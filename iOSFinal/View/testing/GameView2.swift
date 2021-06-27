//
//  GameView2.swift
//  iOSFinal
//
//  Created by CK on 2021/6/26.
//

import SwiftUI

import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseStorageSwift//要有swift的,才有result
import Kingfisher
import FirebaseFirestoreSwift
import Firebase
import AppTrackingTransparency
import AVFoundation
import Combine
import OMJoystick

struct GameView2: View {
    
    @Binding var roomDocumentName:String
    
    //character
    @State private var currentUser = Auth.auth().currentUser
    @State private var userPhotoURL = URL(string: "")
    @State private var userName = ""
    //position
    @State private var myOffset:CGSize = .zero
    @State private var playerOffset2:CGSize = .zero
    @State private var playerOffset3:CGSize = .zero
    @State private var offset1:CGSize = .zero
    @State private var offset2:CGSize = .zero
    @State private var offset3:CGSize = .zero
    @State private var footStep :CGFloat = 15.0
    //photo
    @State private var URLString_Player1 : String = ""
    @State private var URLString_Player2 : String = ""
    @State private var URLString_Player3 : String = ""
    
    @State private var showPlayer1 : String = ""
    @State private var showPlayer2 : String = ""
    @State private var showPlayer3 : String = ""
    
    @State private var arrowKeyPosition_x : CGFloat = -350.0//間距25
    @State private var arrowKeyPosition_y : CGFloat = 80.0//間距30
    //食材數量
    @State private var vegetable : Int = 0
    @State private var tomato : Int = 0
    
    @State private var cutVegetable : Int = 0
    @State private var cutTomato : Int = 0
    
    @State private var cutVegetableForCook : Int = 0
    @State private var cutTomatoForCook : Int = 0
    
    @State private var cookingVegetableNum : Int = 0
    @State private var cookingTomatoNum : Int = 0
    
    @State private var orderVegetableNum : Int = 0
    @State private var orderTomatoNum : Int = 0
    @State private var FinishedOrder : Int = 0
    
//偵測位置
    
    @State private var newPosition = [CGSize.zero]
    @State private var intersectionReturn = Int()
    
    @State var characterFrame  = [CGRect](repeating: CGRect.zero, count: 3)
    @State var nowCharacterFrameX = [CGFloat](repeating: CGFloat.zero, count: 3)
    @State var nowCharacterFrameY = [CGFloat](repeating: CGFloat.zero, count: 3)
    
    @State var foodFrame = [CGRect](repeating: CGRect.zero, count:7)
    @State var nowfoodFrameY = [CGFloat](repeating: CGFloat.zero, count: 7)
    @State var foodFrameX = [CGFloat](repeating: CGFloat.zero, count: 7)
    @State var foodFrameY = [CGFloat](repeating: CGFloat.zero, count: 7)
//數值顯示
    
    @State private var takeVegetable = false
    @State private var takeTomato = false
    
    @State private var takeWhat :String = ""
    @State private var ifTake = false
    @State private var nextAction :String = ""
    
    
    @State private var coin : Int = 0
    
    @State private var correctNum = 0
    @State private var gameStart :Int = 0//0還沒開始,1開始
//timer
    @StateObject var gameTimer = GameTimer()
    @State private var timeBar = CGSize.zero
    @State private var gameTime = 120
    @State private var goEndView = false
    
    
//tap
    @State private var tapGoal_wash : Int = 5
    @State private var tapGoal_cook : Int = 3
    
    @State private var tapTimes_washVegetable : Int = 0
    @State private var tapTimes_washTomato : Int = 0
    @State private var tapTimes_cook : Int = 0

    
    
//animation
    @State private var flameCircleColorChanged = false
    @State private var flameColorChanged = false
    @State private var flameSizeChanged = false
    
    @State private var dropCircleColorChanged_vegetable = false
    @State private var dropColorChanged_vegetable = false
    @State private var dropSizeChanged_vegetable = false
    
    @State private var dropCircleColorChanged_tomato = false
    @State private var dropColorChanged_tomato = false
    @State private var dropSizeChanged_tomato = false
    
    @State private var isLoading = false
    @State private var remainingTime = 120
    
    @State private var receiveTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var timeElapsed = 0
//虛擬搖桿
    @State var isDragging = false
    @State var dragValue = CGSize.zero
    @State var newOffsetX = CGFloat.zero
    @State var newOffsetY = CGFloat.zero
    @State var smallDragIconX = CGFloat.zero
    @State var smallDragIconY = CGFloat.zero

    
    var frameData = FrameData()
    var cooking = Cooking()
    var order = Order()
    
    
    func judgeIntersection(objectX: CGFloat, objectY: CGFloat)->Int{//input人 對比跟六種菜是否有交集
        let objectRect = CGRect(x: objectX, y: objectY, width:100, height: 100)
        var outcome = 0
        for index in (0..<7){
            
            let targetRect = CGRect(x: frameData.foodFrameX[index], y: frameData.foodFrameY[index], width: 50, height: 125)
            
            let interRect = objectRect.intersection(targetRect)
            if(interRect.width>=50 || interRect.height>=50){
                
                print("Intersect with:\(index) ")
                print("\(Int(interRect.width))")
                print("frameData.nowCharacterFrameX:\(frameData.nowCharacterFrameX)")
                print("frameData.nowCharacterFrameY:\(frameData.nowCharacterFrameY)")
                
                return index
                
            }
        }
        return 10
    }
    
    func updateCharacterFrame(geometry: GeometryProxy) {//0是自己
        
        frameData.characterFrame[0]=(geometry.frame(in: .global))
    }
    
    func updateVegetableFrame_up(geometry: GeometryProxy,offsetX:Float,offsetY:Float,index: Int) {
        // 170 ,-160 與人物神秘的座標差
        frameData.foodFrame[index]=(geometry.frame(in: .global))
        frameData.foodFrameX[index] = frameData.foodFrame[index].origin.x - CGFloat(offsetX)-372
        frameData.foodFrameY[index] = frameData.foodFrame[index].origin.y - CGFloat(offsetY)-207
        
    }
    func updateVegetableFrame_up2(geometry: GeometryProxy,offsetX:Float,offsetY:Float,index: Int) {
        // 170 ,-160 與人物神秘的座標差
        frameData.foodFrame[index]=(geometry.frame(in: .global))
        frameData.foodFrameX[index] = frameData.foodFrame[index].origin.x - CGFloat(offsetX)-216
        frameData.foodFrameY[index] = frameData.foodFrame[index].origin.y - CGFloat(offsetY)-207
        
    }
    func updateVegetableFrame_down(geometry: GeometryProxy,offsetX:Float,offsetY:Float,index: Int) {
        // 170 ,-160 與人物神秘的座標差
        frameData.foodFrame[index]=(geometry.frame(in: .global))
        frameData.foodFrameX[index] = frameData.foodFrame[index].origin.x - CGFloat(offsetX)-155
        frameData.foodFrameY[index] = frameData.foodFrame[index].origin.y - CGFloat(offsetY)+204
        
    }
    func updateTomatoFrame(geometry: GeometryProxy,offsetX:Float,offsetY:Float,index: Int) {
        // 412 ,-160 tomato與人物神秘的座標差
        frameData.foodFrame[index]=(geometry.frame(in: .global))
        frameData.foodFrameX[index] = frameData.foodFrame[index].origin.x - CGFloat(offsetX)+137
        frameData.foodFrameY[index] = frameData.foodFrame[index].origin.y - CGFloat(offsetY)-160
        
    }
    func updateCutTomatoFrame_up(geometry: GeometryProxy,offsetX:Float,offsetY:Float,index: Int) {
        // 412 ,-160 tomato與人物神秘的座標差
        frameData.foodFrame[index]=(geometry.frame(in: .global))
        frameData.foodFrameX[index] = frameData.foodFrame[index].origin.x - CGFloat(offsetX)+286
        frameData.foodFrameY[index] = frameData.foodFrame[index].origin.y - CGFloat(offsetY)-160
        
    }
    func updateCutTomatoFrame_down(geometry: GeometryProxy,offsetX:Float,offsetY:Float,index: Int) {
        // 412 ,-160 tomato與人物神秘的座標差
        frameData.foodFrame[index]=(geometry.frame(in: .global))
        frameData.foodFrameX[index] = frameData.foodFrame[index].origin.x - CGFloat(offsetX)+254
        frameData.foodFrameY[index] = frameData.foodFrame[index].origin.y - CGFloat(offsetY)+204
        
    }
    func updateCook(geometry: GeometryProxy,offsetX:Float,offsetY:Float,index: Int) {
        // 412 ,-160 tomato與人物神秘的座標差
        frameData.foodFrame[index]=(geometry.frame(in: .global))
        frameData.foodFrameX[index] = frameData.foodFrame[index].origin.x - CGFloat(offsetX)+171
        frameData.foodFrameY[index] = frameData.foodFrame[index].origin.y - CGFloat(offsetY)+555
        
    }
    func initial(){
        
        gameStart = 1
        newPosition = [CGSize.zero]
        orderVegetableNum = Int.random(in: 1...3)
        orderTomatoNum = Int.random(in: 1...3)
        correctNum = 0
        remainingTime = gameTime - timeElapsed
        coin = 0
        setFood(food:Food(room: "\(roomDocumentName)", vegetable : vegetable,tomato : tomato,cutVegetable : cutVegetable,cutTomato:cutTomato,cutVegetableForCook:cutVegetableForCook,cutTomatoForCook : cutTomatoForCook,cookingVegetableNum : cookingVegetableNum, cookingTomatoNum : cookingTomatoNum,orderVegetableNum : orderVegetableNum,orderTomatoNum:orderTomatoNum,coin : coin,tapTimes_washVegetable:tapTimes_washVegetable, tapTimes_washTomato:tapTimes_washTomato,gameStart:gameStart))
    }
    func updateOrder(){
        orderVegetableNum = Int.random(in: 1...3)
        orderTomatoNum = Int.random(in: 1...3)
    }
//
    
    func updateRemainingTime(){//計算remainingTime
        
        if gameStart == 1{
            remainingTime = gameTime - timeElapsed
        }
    }
    
    func ifTimeUp(){
        
        if remainingTime > 0{
            
        }else{
            print("RemainingTime in TimeUp:\(remainingTime)")
            print("timeUp")
            gameStart = 0
            
            if goEndView == false{
                setFood(food:Food(room: "\(roomDocumentName)", vegetable : vegetable,tomato : tomato,cutVegetable : cutVegetable,cutTomato:cutTomato,cutVegetableForCook:cutVegetableForCook,cutTomatoForCook : cutTomatoForCook,cookingVegetableNum : cookingVegetableNum, cookingTomatoNum : cookingTomatoNum,orderVegetableNum : orderVegetableNum,orderTomatoNum:orderTomatoNum,coin : coin,tapTimes_washVegetable:tapTimes_washVegetable, tapTimes_washTomato:tapTimes_washTomato,gameStart:gameStart))
            }
            
        }
        if gameStart == 0 {
            remainingTime = 0
            goEndView = true
            print("goEndView:\(goEndView)")
        }
    }
    
    var body: some View {
        ZStack{
            Image("大背景")
                .resizable()
                .scaledToFit()
                .scaleEffect(1.4)
                .offset(x:0,y:20)
 //桌
            Group{
                
                Image("桌子橫x8")
                    .resizable()
                    .scaledToFit()
                    .offset(x:0,y:30)
                    .scaleEffect(0.65)
                Image("桌子橫x2")//切菜桌
                    .resizable()
                    .scaledToFit()
                    .position(x: 1750, y: -700)
                    .scaleEffect(0.175)
                Image("桌子橫x2")//切菜桌
                    .resizable()
                    .scaledToFit()
                    .position(x: 500, y: -700)
                    .scaleEffect(0.175)
                
                Image("桌子橫x2")//切菜桌
                    .resizable()
                    .scaledToFit()
                    .position(x: -750, y: -700)
                    .scaleEffect(0.175)
                
            }
            
 //切菜桌///////////////////////////////////////
            Group{
                //切菜桌
                Image("未洗的菜去背")//切菜桌0
                    .resizable()
                    .scaledToFit()
                    
                    .frame(width:300,height:300)
                    .scaleEffect(0.20)
                    .offset(x:-245,y:-170)
                    .overlay(
                        GeometryReader(content: { geometry in
                        
                            let _ = updateVegetableFrame_up(geometry: geometry,offsetX:-250.0,offsetY:-170, index: 0)
                            Color.clear
                               
                        })
                     )
                    .overlay(
                        
                        Text("\(tapTimes_washVegetable) / \(tapGoal_wash)")
                            .padding(.horizontal, 10)
                            .background(Color(.systemGray6))
                            .cornerRadius(15)
                            .offset(x:-245,y:-130)
                    )
                ZStack {
                    
                    Circle()
                        .frame(width: 20, height: 20)
                        .foregroundColor( dropCircleColorChanged_vegetable ? Color(.systemGray5) : .blue)
                 
                    Image(systemName: "drop.fill")
                        .frame(width: 20, height: 20)
                        .foregroundColor(dropColorChanged_vegetable ? .blue : .white)
                        .font(.system(size: 30))
                        .scaleEffect(dropSizeChanged_vegetable ? 1.0 : 0.5)
                }.offset(x:-285,y:-130)
                   
                Image("洗好的菜去背")//切菜桌1
                    .resizable()
                    .scaledToFit()
                    .frame(width:300,height:300)
                    .scaleEffect(0.20)
                    .offset(x:-170,y:-170)
                    .overlay(
                        GeometryReader(content: { geometry in
                            let _ = updateVegetableFrame_up2(geometry: geometry,offsetX:-170.0,offsetY:-170, index: 1)
                            Color.clear
                        })
                     )
                    .overlay(
                        Text("\(cutVegetable)")
                            .padding(.horizontal, 10)
                            .background(Color(.systemGray6))
                            .cornerRadius(15)
                            .offset(x:-170,y:-130)
                    )
                Image("番茄去背")//切菜桌2
                    .resizable()
                    .scaledToFit()
                    .frame(width:400,height:400)
                    .scaleEffect(0.20)
                    .offset(x:-20,y:-172)
                    .overlay(
                        GeometryReader(content: { geometry in
                        
                            let _ = updateTomatoFrame(geometry: geometry,offsetX:-20.0,offsetY:-170, index: 2)
                            Color.clear
                               
                        })
                     )
                    .overlay(
                        Text("\(tapTimes_washTomato) / \(tapGoal_wash)")
                            .padding(.horizontal, 10)
                            .background(Color(.systemGray6))
                            .cornerRadius(15)
                            .offset(x:-10,y:-130)
                        
                    )
        ////////
                    ZStack {
                        
                        Circle()
                            .frame(width: 20, height: 20)
                            .foregroundColor( dropCircleColorChanged_tomato ? Color(.systemGray5) : .blue)
                     
                        Image(systemName: "drop.fill")
                            .frame(width: 20, height: 20)
                            .foregroundColor(dropColorChanged_tomato ? .blue : .white)
                            .font(.system(size: 30))
                            .scaleEffect(dropSizeChanged_tomato ? 1.0 : 0.5)
                    }.offset(x:-50,y:-130)
                
                
                Image("番茄切片去背")//切菜桌3
                    .resizable()
                    .scaledToFit()
                    .frame(width:400,height:400)
                    .scaleEffect(0.17)
                    .offset(x:58,y:-165)
                    .overlay(
                        GeometryReader(content: { geometry in
                        
                            let _ = updateCutTomatoFrame_up(geometry: geometry,offsetX:58.0,offsetY:-175, index: 3)
                            Color.clear
                               
                        })
                     )
                    .overlay(
                        Text("\(cutTomato)")
                            .padding(.horizontal, 10)
                            .background(Color(.systemGray6))
                            .cornerRadius(15)
                            .offset(x:70,y:-130)
                    )
            }
//菜單、正在煮的東西////////////////////////
            Group{
                Text("目前訂單")
                    .padding(.horizontal, 10)
                    .frame(width:150,height:30)
                    .background(Color(.systemGray6))
                    .cornerRadius(15)
                    .offset(x:-360,y:-175)
                Image("洗好的菜去背")//菜單
                    .resizable()
                    .scaledToFit()
                    .frame(width:300,height:300)
                    .scaleEffect(0.20)
                    .offset(x:-430,y:-140)
                    .overlay(
                        HStack{
                            Text("青菜:")
                                .padding(.horizontal, 10)
                                .background(Color(.systemGray6))
                                .cornerRadius(15)
                                .offset(x:-360,y:-140)
                            Text("\(orderVegetableNum)")
                                .padding(.horizontal, 10)
                                .background(Color(.systemGray6))
                                .cornerRadius(15)
                                .offset(x:-360,y:-140)
                            
                        }
                        
                    )
                Image("番茄切片去背")//菜單
                    .resizable()
                    .scaledToFit()
                    .frame(width:300,height:300)
                    .scaleEffect(0.17)
                    .offset(x:-430,y:-105)
                    .overlay(
                        HStack{
                            Text("番茄:")
                                .padding(.horizontal, 10)
                                .background(Color(.systemGray6))
                                .cornerRadius(15)
                                .offset(x:-360,y:-105)
                            Text("\(orderTomatoNum)")
                                .padding(.horizontal, 10)
                                .background(Color(.systemGray6))
                                .cornerRadius(15)
                                .offset(x:-360,y:-105)
                        }
                    )
                
                
                Image("洗好的菜去背")//正在煮的東西
                    .resizable()
                    .scaledToFit()
                    .frame(width:200,height:200)
                    .scaleEffect(0.20)
                    .offset(x:70,y:170)
                    .overlay(
                        Text("\(cookingVegetableNum)")
                            .padding(.horizontal, 10)
                            .background(Color(.systemGray6))
                            .cornerRadius(15)
                            .offset(x:100,y:170)
                    )
                
                Image("番茄切片去背")//正在煮的東西
                    .resizable()
                    .scaledToFit()
                    .frame(width:200,height:200)
                    .scaleEffect(0.17)
                    .offset(x:70,y:200)
                    .overlay(
                        Text("\(cookingTomatoNum)")
                            .padding(.horizontal, 10)
                            .background(Color(.systemGray6))
                            .cornerRadius(15)
                            .offset(x:100,y:200)
                    )
                if takeWhat == "蔬菜"{
                    Image("洗好的菜去背")//跟隨玩家
                        .resizable()
                        .scaledToFit()
                        .frame(width:200,height:200)
                        .scaleEffect(0.20)
                        .offset(offset1)
                        .overlay(
                            Text("\(cookingVegetableNum)")
                                .padding(.horizontal, 10)
                                .background(Color(.systemGray6))
                                .cornerRadius(15)
                                .offset(x:100,y:170)
                        )
                    
                }else if takeWhat == "番茄"{
                    Image("番茄切片去背")//跟隨玩家
                        .resizable()
                        .scaledToFit()
                        .frame(width:200,height:200)
                        .scaleEffect(0.17)
                        .offset(x:offset1.width,y:offset1.height)
                        .overlay(
                            Text("\(cookingTomatoNum)")
                                .padding(.horizontal, 10)
                                .background(Color(.systemGray6))
                                .cornerRadius(15)
                                .offset(x:100,y:200)
                        )
                }
            }
//數值顯示///////////
            Group{
                
                Button(action: {
                    
                    if gameStart == 0{
                        initial()
                    }
                }, label: {
                    Text("遊戲開始")
                        .padding(7)
                        .padding(.horizontal, 15)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal, 10)
                }).offset(x: 160, y: -175)
                
                if remainingTime > 0 {
                    
                    HStack{
                        Text("剩餘時間：")
                            .padding(7)
                            .padding(.horizontal, 25)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .padding(.horizontal, 10)
                            .offset(x:330,y:-175)
                        Text("\(remainingTime)")
                            .padding(7)
                            .padding(.horizontal, 10)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .padding(.horizontal, 10)
                            .offset(x:280,y:-175)
                    }
                    
                }else{
                    Text("時間結束")
                        .padding(7)
                        .padding(.horizontal, 25)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal, 10)
                        .offset(x:350,y:-175)
                }
                if gameStart == 1{
                    Circle()
                        .trim(from: 0, to: 0.5)
                        .stroke(Color.green, lineWidth: 5)
                        .frame(width: 50, height: 50)
                        .rotationEffect(Angle(degrees: isLoading ? 360 : 0))
                        .animation(Animation.default.repeatForever(autoreverses: false))
                        .offset(x:385,y:-175)
                        .onAppear() {
                            self.isLoading = true
                         }
                }
                HStack{
                    
                    Text("金幣:")
                        .padding(7)
                        .padding(.horizontal, 25)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal, 10)
                        .offset(x:350,y:-130)
                    Text("\(coin)")
                        .padding(7)
                        .padding(.horizontal, 25)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal, 10)
                        .offset(x:310,y:-130)
                    
                }
                
                
                
            }
//中間桌以下/////////////
            Group{
                Image("番茄切片去背")//4中間桌
                    .resizable()
                    .scaledToFit()
                    .frame(width:400,height:400)
                    .scaleEffect(0.17)
                    .offset(x:40,y:17)
                    .overlay(
                        GeometryReader(content: { geometry in
                        
                            let _ = updateCutTomatoFrame_down(geometry: geometry,offsetX: 42.0,offsetY:17, index: 4)
                            Color.clear
                               
                        })
                     )
                    .overlay(
                        Text("\(cutTomatoForCook)")
                            .padding(.horizontal, 10)
                            .background(Color(.systemGray6))
                            .cornerRadius(15)
                            .offset(x:40,y:47)
                    )
                Image("洗好的菜去背")//5中間桌
                    .resizable()
                    .scaledToFit()
                    .frame(width:400,height:400)
                    .scaleEffect(0.20)
                    .offset(x:-165,y:15)
                    .overlay(
                        GeometryReader(content: { geometry in
                        
                            let _ = updateVegetableFrame_down(geometry: geometry,offsetX:-165.0,offsetY:15, index: 5)
                            Color.clear
                               
                        })
                     )
                    .overlay(
                        Text("\(cutVegetableForCook)")
                            .padding(.horizontal, 10)
                            .background(Color(.systemGray6))
                            .cornerRadius(15)
                            .offset(x:-165,y:55)
                    )
                
                
                Image("煮飯去背")//6中間桌
                    .resizable()
                    .scaledToFit()
                    .frame(width:400,height:400)
                    .scaleEffect(0.25)
                    .offset(x:-10,y:180)
                    .overlay(
                        GeometryReader(content: { geometry in
                        
                            let _ = updateCook(geometry: geometry,offsetX:-10.0,offsetY:200, index: 6)
                            Color.clear
                               
                        })
                     )
                    .overlay(
                        Text("\(tapTimes_cook) / \(tapGoal_cook)")
                            .padding(.horizontal, 10)
                            .background(Color(.systemGray6))
                            .cornerRadius(15)
                            .offset(x:-10,y:200)
                    )
                ZStack {
                    Circle()
                        .frame(width: 20, height: 20)
                        .foregroundColor(flameCircleColorChanged ? Color(.systemGray5) : .red)
                 
                    Image(systemName: "flame.fill")
                        .frame(width: 20, height: 20)
                        .foregroundColor(flameColorChanged ? .red : .white)
                        .font(.system(size: 30))
                        .scaleEffect(flameSizeChanged ? 1.0 : 0.5)
                }.offset(x:-50,y:200)
                VStack {
                    
                    Text("width: \(dragValue.width)")
                    Text("height: \(dragValue.height)")
                    
                    VStack (spacing: 10) {
                        HStack(spacing: 10) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.gray)
                            VStack (spacing: 16) {
                                Image(systemName: "chevron.up")
                                    .foregroundColor(.gray)
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.gray)

                            }
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                    }
                    .frame(width: 70, height: 70)

                    .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), Color(#colorLiteral(red: 0.8705882353, green: 0.8941176471, blue: 0.9450980392, alpha: 1))]), startPoint: .top, endPoint: .bottom))
                    .clipShape(Circle())
                    .offset(x: -300+dragValue.width, y: 50+dragValue.height)

                    .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
                    .padding(.horizontal, 30)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                
                                let limit: CGFloat = 100        // the less the faster resistance
                                let xOff = value.translation.width
                                let yOff = value.translation.height
                                let dist = sqrt(xOff*xOff + yOff*yOff);
                                let factor = 1 / (dist / limit + 1)
                                self.dragValue = CGSize(width: value.translation.width * factor,
                                                    height: value.translation.height * factor)
                                self.isDragging = true
                                /*
                                myOffset.width = newPosition[0].width + (dragValue.width * 0.05)
                                myOffset.height = newPosition[0].height + (dragValue.height * 0.05)
 */
                                myOffset.width += (dragValue.width * 0.05)
                                myOffset.height += (dragValue.height * 0.05)
                                newPosition[0] = myOffset
                                frameData.nowCharacterFrameX[0] = frameData.characterFrame[0].origin.x+newPosition[0].width
                                frameData.nowCharacterFrameY[0] = frameData.characterFrame[0].origin.y+newPosition[0].height//移動後座標
                                setLocation(location: Location(name: "\(userName)", x: myOffset.width, y: myOffset.height))
                                print("character at :")
                                print(frameData.nowCharacterFrameX[0],frameData.nowCharacterFrameY[0])

                                
                        }
                        .onEnded({value in
                            
                            dragValue.width = 0
                            dragValue.height = 0
                            
                        })
                    )
                        .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
                }
                
            }
//方向鍵////////////////////////////////////
            
///功能鍵
            Group{
                Button(action: {
                    print("frameData.foodFrameX[0]:\(frameData.foodFrameX[0]),frameData.foodFrameY[0]:\(frameData.foodFrameY[0])")
                    print("frameData.foodFrameX[1]:\(frameData.foodFrameX[1]),frameData.foodFrameY[1]:\(frameData.foodFrameY[0])")
                    print("frameData.foodFrameX[2]:\(frameData.foodFrameX[2]),frameData.foodFrameY[2]:\(frameData.foodFrameY[2])")
                    print("frameData.foodFrameX[3]:\(frameData.foodFrameX[3]),frameData.foodFrameY[3]:\(frameData.foodFrameY[3])")
                    print("frameData.foodFrameX[4]:\(frameData.foodFrameX[4]),frameData.foodFrameY[4]:\(frameData.foodFrameY[4])")
                    print("frameData.foodFrameX[5]:\(frameData.foodFrameX[5]),frameData.foodFrameY[5]:\(frameData.foodFrameY[5])")
                    print("frameData.foodFrameX[6]:\(frameData.foodFrameX[6]),frameData.foodFrameY[6]:\(frameData.foodFrameY[6])")
                   
                    intersectionReturn = judgeIntersection(objectX: frameData.nowCharacterFrameX[0], objectY: frameData.nowCharacterFrameY[0])
                    
                    if  intersectionReturn == 10{
                        print("10")
                    }else if intersectionReturn == 0{
                        
                        print("洗菜 : 0")
                        
                        if tapTimes_washVegetable < tapGoal_wash{
                            tapTimes_washVegetable += 1
                            withAnimation(.default) {
                                self.dropCircleColorChanged_vegetable.toggle()
                                self.dropColorChanged_vegetable.toggle()
                                self.dropSizeChanged_vegetable.toggle()
                            }
                        }else if tapTimes_washVegetable == tapGoal_wash{
                            tapTimes_washVegetable = 0
                            cutVegetable += 1
                            
                        }
                    }else if intersectionReturn == 2{
                        
                        print("洗菜 : 2")
                        if tapTimes_washTomato < tapGoal_wash{
                            tapTimes_washTomato += 1
                            
                            withAnimation(.default) {
                                
                                dropCircleColorChanged_tomato.toggle()
                                dropColorChanged_tomato.toggle()
                                dropSizeChanged_tomato.toggle()

                            }
                            
                        }else if tapTimes_washTomato == tapGoal_wash{
                            tapTimes_washTomato = 0
                            cutTomato += 1
                        }
                    }
                    setFood(food:Food(room: "\(roomDocumentName)", vegetable : vegetable,tomato : tomato,cutVegetable : cutVegetable,cutTomato:cutTomato,cutVegetableForCook:cutVegetableForCook,cutTomatoForCook : cutTomatoForCook,cookingVegetableNum : cookingVegetableNum, cookingTomatoNum : cookingTomatoNum,orderVegetableNum : orderVegetableNum,orderTomatoNum:orderTomatoNum,coin : coin,tapTimes_washVegetable:tapTimes_washVegetable, tapTimes_washTomato:tapTimes_washTomato,gameStart: gameStart))
                    
                }, label: {
                    Text("洗菜")
                        .padding(7)
                        .padding(.horizontal, 25)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal, 10)
                }).position(x: 750, y: 300)
                
                Button(action: {
                    
                    intersectionReturn = judgeIntersection(objectX: frameData.nowCharacterFrameX[0], objectY: frameData.nowCharacterFrameY[0])
                    
                    if  intersectionReturn == 10{
                        print("10")
                    }else if intersectionReturn == 1{
                        if nextAction == "放下" && takeWhat == "蔬菜"{
                            print("intersect : 1 ,放下")
                            ifTake.toggle()
                            cutVegetable += 1
                            takeWhat = ""
                            nextAction = "拿取"
                        }else if nextAction == "拿取" && cutVegetable>0{
                            print("intersect : 1 ,拿取")
                            ifTake.toggle()
                            cutVegetable -= 1
                            takeWhat = "蔬菜"
                            nextAction = "放下"
                        }
                    }else if intersectionReturn == 3{
                        
                        if nextAction == "放下" && takeWhat == "番茄"{
                            print("intersect : 3 ,放下")
                            ifTake.toggle()
                            cutTomato += 1
                            takeWhat = ""
                            nextAction = "拿取"
                        }else if nextAction == "拿取" && cutTomato>0 {
                            print("intersect : 3 ,拿取")
                            ifTake.toggle()
                            cutTomato -= 1
                            takeWhat = "番茄"
                            nextAction = "放下"
                        }
                    }else if intersectionReturn == 4{
                        
                        if nextAction == "放下" && takeWhat == "番茄"{
                            print("intersect : 5 ,放下")
                            ifTake.toggle()
                            cutTomatoForCook += 1
                            takeWhat = ""
                            nextAction = "拿取"
                        }else if nextAction == "拿取" && cutTomatoForCook>0 {
                            print("intersect : 5 ,拿取")
                            ifTake.toggle()
                            cutTomatoForCook -= 1
                            takeWhat = "番茄"
                            nextAction = "放下"
                        }

                    }else if intersectionReturn == 5{
                        if nextAction == "放下" && takeWhat == "蔬菜"{
                            print("intersect : 4 ,放下")
                            ifTake.toggle()
                            cutVegetableForCook += 1
                            takeWhat = ""
                            nextAction = "拿取"
                        }else if nextAction == "拿取" && cutVegetableForCook>0 {
                            print("intersect : 4 ,拿取")
                            ifTake.toggle()
                            cutVegetableForCook -= 1
                            takeWhat = "蔬菜"
                            nextAction = "放下"
                        }

                    }else if intersectionReturn == 6{
                        
                        if nextAction == "放下" && takeWhat == "蔬菜"{
                            
                            print("intersect : 6 ,放下蔬菜")
                            ifTake.toggle()
                            cookingVegetableNum += 1
                            takeWhat = ""
                            nextAction = "拿取"
                        }else if nextAction == "拿取" && cookingVegetableNum>0 {
                            print("intersect : 6 ,拿取蔬菜")
                            ifTake.toggle()
                            cookingVegetableNum -= 1
                            takeWhat = "蔬菜"
                            nextAction = "放下"
                        }else if nextAction == "放下" && takeWhat == "番茄"{
                            print("intersect : 6 ,放下番茄")
                            ifTake.toggle()
                            cookingTomatoNum += 1
                            takeWhat = ""
                            nextAction = "拿取"
                        }else if nextAction == "拿取" && cookingTomatoNum>0 {
                            print("intersect : 6 ,拿取番茄")
                            ifTake.toggle()
                            cookingTomatoNum -= 1
                            takeWhat = "番茄"
                            nextAction = "放下"
                        }
                    }else if intersectionReturn == 100{
                        print("no intersect")
                    }else{
                    }
                    setFood(food:Food(room: "\(roomDocumentName)", vegetable : vegetable,tomato : tomato,cutVegetable : cutVegetable,cutTomato:cutTomato,cutVegetableForCook:cutVegetableForCook,cutTomatoForCook : cutTomatoForCook,cookingVegetableNum : cookingVegetableNum, cookingTomatoNum : cookingTomatoNum,orderVegetableNum : orderVegetableNum,orderTomatoNum:orderTomatoNum,coin : coin,tapTimes_washVegetable:tapTimes_washVegetable, tapTimes_washTomato:tapTimes_washTomato,gameStart: gameStart))
                    
                }, label: {
                    HStack{
                        if nextAction == "拿取" && takeWhat == ""{
                            Text("拿取:")
                                .padding(7)
                                .padding(.horizontal, 25)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .padding(.horizontal, 10)
                            
                        }else if nextAction == "放下" && takeWhat == "番茄"{
                            Text("放下:")
                                .padding(7)
                                .padding(.horizontal, 25)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .padding(.horizontal, 10)
                                .offset(x:-20,y:0)
                            Text("番茄")
                                .padding(7)
                                .padding(.horizontal, 5)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .offset(x:-70,y:0)
                        }else if nextAction == "放下" && takeWhat == "蔬菜"{
                            Text("放下:")
                                .padding(7)
                                .padding(.horizontal, 25)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .padding(.horizontal, 10)
                                .offset(x:-20,y:0)
                            Text("青菜")
                                .padding(7)
                                .padding(.horizontal, 5)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .offset(x:-70,y:0)
                        }
                    }
                    
                }).position(x: 750, y: 350)
                
                
                Button(action: {
                    
                    if tapTimes_cook < tapGoal_cook{
                        
                        withAnimation(.default) {
                            self.flameCircleColorChanged.toggle()
                            self.flameColorChanged.toggle()
                            self.flameSizeChanged.toggle()
                        }
                        tapTimes_cook += 1
                        
                    }else if tapTimes_cook == tapGoal_cook{
                        tapTimes_cook = 0
                        
                        if orderTomatoNum == cookingTomatoNum && orderVegetableNum == cookingVegetableNum {
                            print("出菜成功")
                            var correctPoint = orderTomatoNum + orderVegetableNum
                            print("\(orderTomatoNum + orderVegetableNum)")
                            print("\(100*(orderTomatoNum + orderVegetableNum))")
                            
                            coin += (100*(orderTomatoNum + orderVegetableNum))
                            print("\(coin)")
                            cookingTomatoNum = 0
                            cookingVegetableNum = 0
                            updateOrder()
                            correctNum+=1
                        }
                    }
                    
                    print("coin:\(coin)")
                    
                    setFood(food:Food(room: "\(roomDocumentName)", vegetable : vegetable,tomato : tomato,cutVegetable : cutVegetable,cutTomato:cutTomato,cutVegetableForCook:cutVegetableForCook,cutTomatoForCook : cutTomatoForCook,cookingVegetableNum : cookingVegetableNum, cookingTomatoNum : cookingTomatoNum,orderVegetableNum : orderVegetableNum,orderTomatoNum:orderTomatoNum,coin : coin,tapTimes_washVegetable:tapTimes_washVegetable, tapTimes_washTomato:tapTimes_washTomato,gameStart: gameStart))
                    
                }, label: {
                    
                    
                    Text("做菜")
                        .padding(7)
                        .padding(.horizontal, 25)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal, 10)
                }).position(x: 750, y: 400)
                
            }
//////人物位置
            ImageView(withURL: "\(URLString_Player1)")
                .scaledToFit()
                .frame(width: 50, height: 50)
                .cornerRadius(100)
                .offset(offset1)
                .overlay(
                    GeometryReader(content: { geometry in
                        
                        let _ = updateCharacterFrame(geometry: geometry)
                        Color.clear
                           
                    })
                 )
                
                
            ImageView(withURL:"\(URLString_Player2)")
                .scaledToFit()
                .frame(width: 50, height: 50)
                .cornerRadius(100)
                .offset(offset2)
            
            ImageView(withURL: "\(URLString_Player3)")
                .scaledToFit()
                .frame(width: 50, height: 50)
                .cornerRadius(100)
                .offset(offset3)
            
            
            
            
        }.onAppear(perform:{
            
            myOffset.width = 0
            myOffset.height = 0
            
            if ifTake == false{
                nextAction = "拿取"
            }else{
                nextAction = "放下"
            }
            let queue = DispatchQueue(label: "com.appcoda.myqueue")
            //取得角色資訊
            userPhotoURL = (currentUser?.photoURL)
            if let user = Auth.auth().currentUser {
                userName = user.displayName ?? "nil"
            }
            //取得角色位置與照片
            let db = Firestore.firestore()
            let db2 = Firestore.firestore()
            
            db.collection("waitingRoom").document("\(roomDocumentName)").addSnapshotListener { snapshot, error in
                
                guard let snapshot = snapshot else { return }
                guard let room = try? snapshot.data(as: RoomState.self) else { return }
                
                showPlayer1 = String(room.player1)
                showPlayer2 = String(room.player2)
                showPlayer3 = String(room.player3)
                queue.sync{
                    URLString_Player1 = String(room.URL_player1)
                    URLString_Player2 = String(room.URL_player2)
                    URLString_Player3 = String(room.URL_player3)
                }
                db.collection("food").document("\(roomDocumentName)").addSnapshotListener { snapshot, error in
                    
                    guard let snapshot = snapshot else { return }
                    guard let food = try? snapshot.data(as: Food.self) else { return }
                    vegetable=Int(food.vegetable)
                    tomato = Int(food.tomato)
                    cutVegetable = Int(food.cutVegetable)
                    cutTomato =  Int(food.cutTomato)
                    cutVegetableForCook = Int(food.cutVegetableForCook)
                    cutTomatoForCook = Int(food.cutTomatoForCook)
                    cookingVegetableNum = Int(food.cookingVegetableNum)
                    cookingTomatoNum = Int(food.cookingTomatoNum)
                    orderVegetableNum = Int(food.orderVegetableNum)
                    orderTomatoNum = Int(food.orderTomatoNum)
                    coin = Int(food.coin)
                    
                    tapTimes_washVegetable = Int(food.tapTimes_washVegetable)
                    tapTimes_washTomato = Int(food.tapTimes_washTomato)
                    
                    gameStart = Int(food.gameStart)
                }
                
                //自己的位置
                db2.collection("location").document("\(showPlayer1)").addSnapshotListener { snapshot, error in
                    
                    guard let snapshot = snapshot else { return }
                    guard let location = try? snapshot.data(as: Location.self) else { return }
                    offset1 = CGSize(width: location.x, height: location.y)
                    
                }
                //player2的位置
                db.collection("location").document("\(showPlayer2)").addSnapshotListener { snapshot, error in
                    
                    guard let snapshot = snapshot else { return }
                    guard let location = try? snapshot.data(as: Location.self) else { return }
                    offset2 = CGSize(width: location.x, height: location.y)
                }
                //player3的位置
                db.collection("location").document("\(showPlayer3)").addSnapshotListener { snapshot, error in
                    
                    guard let snapshot = snapshot else { return }
                    guard let location = try? snapshot.data(as: Location.self) else { return }
                    offset3 = CGSize(width: location.x, height: location.y)
                    
                }
            }
//
            }).onReceive(receiveTimer, perform: { (_) in
                
                if gameStart == 1{
                    timeElapsed+=1
                    ifTimeUp()
                   
                }else{
                    timeElapsed=0
                }
                
                updateRemainingTime()
            })
        EmptyView().sheet(isPresented: $goEndView,content:{EndView(roomDocumentName: $roomDocumentName)})
    }
}

struct GameView2_Previews: PreviewProvider {
    static var previews: some View {
        GameView2(roomDocumentName: .constant("Room2"))
            .previewLayout(.fixed(width: 844, height: 390))
            .previewDevice("iPhone 11")
            .environment(\.horizontalSizeClass, .regular)
            
    }
    
}


