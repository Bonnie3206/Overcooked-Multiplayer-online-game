//
//  GameView.swift
//  iOSFinal
//
//  Created by CK on 2021/6/9.
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

struct GameView: View {
    
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
    @State var characterFrame  = [CGRect](repeating: CGRect.zero, count: 3)//有三個第一次的絕對位置
    @State var foodFrame = [CGRect](repeating: CGRect.zero, count:7)
    //有六個食物位置[0青菜上,切好的青菜上,切好的青菜下,番茄,切好的番茄上,切好的番茄下]
    @State var nowCharacterFrameX = [CGFloat](repeating: CGFloat.zero, count: 3)
    @State var nowCharacterFrameY = [CGFloat](repeating: CGFloat.zero, count: 3)
    
    @State var nowfoodFrameX = [CGFloat](repeating: CGFloat.zero, count: 7)//新的絕對位置Answer
    @State var nowfoodFrameY = [CGFloat](repeating: CGFloat.zero, count: 7)
    //food不動,不變
    @State var foodFrameX = [CGFloat](repeating: CGFloat.zero, count: 7)
    @State var foodFrameY = [CGFloat](repeating: CGFloat.zero, count: 7)
//數值顯示
    @State private var newPosition = [CGSize.zero]
    @State private var intersectionReturn = Int()
    
    @State private var takeVegetable = false
    @State private var takeTomato = false
    
    @State private var takeWhat :String = ""
    @State private var ifTake = false
    @State private var nextAction :String = ""
    
    @State private var correctNum = 0
    @State private var coin = 0
    
    
    //
    
    var frameData = FrameData()
    var cooking = Cooking()
    var order = Order()
    
    func judgeIntersection(objectX: CGFloat, objectY: CGFloat)->Int{//input人 對比跟六種菜是否有交集
        let objectRect = CGRect(x: objectX, y: objectY, width:100, height: 100)
        var outcome = 0
        for index in (0..<7){
            
            let targetRect = CGRect(x: frameData.foodFrameX[index], y: frameData.foodFrameY[index], width: 50, height: 125)
            
            //print("\(index),\(qaData.answerFrame[index].origin.x),\(qaData.answerFrame[index].origin.y)")
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
        frameData.foodFrameX[index] = frameData.foodFrame[index].origin.x + CGFloat(offsetX)+175
        frameData.foodFrameY[index] = frameData.foodFrame[index].origin.y - CGFloat(offsetY)-160
        
    }
    func updateVegetableFrame_down(geometry: GeometryProxy,offsetX:Float,offsetY:Float,index: Int) {
        // 170 ,-160 與人物神秘的座標差
        frameData.foodFrame[index]=(geometry.frame(in: .global))
        frameData.foodFrameX[index] = frameData.foodFrame[index].origin.x + CGFloat(offsetX)+177
        frameData.foodFrameY[index] = frameData.foodFrame[index].origin.y - CGFloat(offsetY)+204
        
    }
    func updateTomatoFrame(geometry: GeometryProxy,offsetX:Float,offsetY:Float,index: Int) {
        // 412 ,-160 tomato與人物神秘的座標差
        frameData.foodFrame[index]=(geometry.frame(in: .global))
        frameData.foodFrameX[index] = frameData.foodFrame[index].origin.x + CGFloat(offsetX)+182
        frameData.foodFrameY[index] = frameData.foodFrame[index].origin.y - CGFloat(offsetY)-160
        
    }
    func updateCutTomatoFrame_up(geometry: GeometryProxy,offsetX:Float,offsetY:Float,index: Int) {
        // 412 ,-160 tomato與人物神秘的座標差
        frameData.foodFrame[index]=(geometry.frame(in: .global))
        frameData.foodFrameX[index] = frameData.foodFrame[index].origin.x + CGFloat(offsetX)+172
        frameData.foodFrameY[index] = frameData.foodFrame[index].origin.y - CGFloat(offsetY)-160
        
    }
    func updateCutTomatoFrame_down(geometry: GeometryProxy,offsetX:Float,offsetY:Float,index: Int) {
        // 412 ,-160 tomato與人物神秘的座標差
        frameData.foodFrame[index]=(geometry.frame(in: .global))
        frameData.foodFrameX[index] = frameData.foodFrame[index].origin.x + CGFloat(offsetX)+130
        frameData.foodFrameY[index] = frameData.foodFrame[index].origin.y - CGFloat(offsetY)+204
        
    }
    func updateCook(geometry: GeometryProxy,offsetX:Float,offsetY:Float,index: Int) {
        // 412 ,-160 tomato與人物神秘的座標差
        frameData.foodFrame[index]=(geometry.frame(in: .global))
        frameData.foodFrameX[index] = frameData.foodFrame[index].origin.x + CGFloat(offsetX)+171
        frameData.foodFrameY[index] = frameData.foodFrame[index].origin.y - CGFloat(offsetY)+555
        
    }
    func initial(){
        newPosition = [CGSize.zero]
        orderVegetableNum = Int.random(in: 1...3)
        orderTomatoNum = Int.random(in: 1...3)
        correctNum = 0
    }
    func updateOrder(){
        orderVegetableNum = Int.random(in: 1...3)
        orderTomatoNum = Int.random(in: 1...3)
    }
    
    
    var body: some View {
        ZStack{
            Image("大背景")
                .resizable()
                .scaledToFit()
                .scaleEffect(1.4)
                .offset(x:0,y:20)
            Group{//桌
                
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
                    
                    .frame(width:400,height:400)
                    .scaleEffect(0.20)
                   .offset(x:-245,y:-170)
                   // .position(x: 200, y: 50)
                    .overlay(
                        GeometryReader(content: { geometry in
                        
                            let _ = updateVegetableFrame_up(geometry: geometry,offsetX:-250.0,offsetY:-170, index: 0)
                            Color.clear
                               
                        })
                     )
                    .overlay(
                        
                        Text("\(vegetable)")
                            .padding(.horizontal, 10)
                            .background(Color(.systemGray6))
                            .cornerRadius(15)
                            .offset(x:-245,y:-130)
                    )
                Image("洗好的菜去背")//切菜桌1
                    .resizable()
                    .scaledToFit()
                    //.position(x: 0, y: 0)
                    .frame(width:400,height:400)
                    .scaleEffect(0.20)
                    .offset(x:-170,y:-170)
                    .overlay(
                        GeometryReader(content: { geometry in
                            let _ = updateVegetableFrame_up(geometry: geometry,offsetX:-170.0,offsetY:-170, index: 1)
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
                        Text("\(tomato)")
                            .padding(.horizontal, 10)
                            .background(Color(.systemGray6))
                            .cornerRadius(15)
                            .offset(x:-10,y:-130)
                    )
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
                Text("訂單")
                    .padding(.horizontal, 10)
                    .frame(width:100,height:20)
                    .background(Color(.systemGray6))
                    .cornerRadius(15)
                    .offset(x:-360,y:-170)
                Image("洗好的菜去背")//菜單
                    .resizable()
                    .scaledToFit()
                    .frame(width:300,height:300)
                    .scaleEffect(0.20)
                    .offset(x:-430,y:-140)
                    .overlay(
                        Text("青菜:\(orderVegetableNum)份")
                            .padding(.horizontal, 10)
                            .background(Color(.systemGray6))
                            .cornerRadius(15)
                            .offset(x:-360,y:-140)
                    )
                Image("番茄切片去背")//菜單
                    .resizable()
                    .scaledToFit()
                    .frame(width:300,height:300)
                    .scaleEffect(0.17)
                    .offset(x:-430,y:-105)
                    .overlay(
                        Text("番茄:\(orderTomatoNum)份")
                            .padding(.horizontal, 10)
                            .background(Color(.systemGray6))
                            .cornerRadius(15)
                            .offset(x:-360,y:-105)
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
                
            }
//數值顯示///////////
            Group{
                Text("金幣:\(coin)")
                    .position(x: 750, y: 300)
                
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
                    .offset(x:-10,y:200)
                    .overlay(
                        GeometryReader(content: { geometry in
                        
                            let _ = updateCook(geometry: geometry,offsetX:-10.0,offsetY:200, index: 6)
                            Color.clear
                               
                        })
                     )
            }
//移動////////////////////////////////////
            Group{
                //上
                Button(action: {
                    
                    myOffset.height = newPosition[0].height - footStep
                    newPosition[0] = myOffset
                    frameData.nowCharacterFrameY[0] = frameData.characterFrame[0].origin.y+newPosition[0].height//移動後座標
                    setLocation(location: Location(name: "\(userName)", x: myOffset.width, y: myOffset.height))
                    print("character at :")
                    print(frameData.nowCharacterFrameX[0],frameData.nowCharacterFrameY[0])
                   

                }, label: {
                    Image(systemName: "chevron.up.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        
                }).position(x: 50, y: 250)
                //左
                Button(action: {
                    myOffset.width = newPosition[0].width - footStep
                    newPosition[0] = myOffset
                    frameData.nowCharacterFrameX[0] = frameData.characterFrame[0].origin.x+newPosition[0].width//移動後座標
                    //frameData.nowCharacterFrameX[0] = newPosition[0].width//移動後座標
                    setLocation(location: Location(name: "\(userName)", x: myOffset.width, y: myOffset.height))
                    
                    print("character at :")
                    print(frameData.nowCharacterFrameX[0],frameData.nowCharacterFrameY[0])
                }, label: {
                    Image(systemName: "chevron.left.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        
                }).position(x: 0, y: 300)
                //右
                Button(action: {
                    myOffset.width = newPosition[0].width + footStep
                    newPosition[0] = myOffset
                    frameData.nowCharacterFrameX[0] = frameData.characterFrame[0].origin.x+newPosition[0].width//移動後座標
                    setLocation(location: Location(name: "\(userName)", x: myOffset.width, y: myOffset.height))
                    
                    print("right at :")
                    print(frameData.nowCharacterFrameX[0],frameData.nowCharacterFrameY[0])
                }, label: {
                    Image(systemName: "chevron.right.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                }).position(x: 100, y: 300)
                //下
                Button(action: {
                    myOffset.height = newPosition[0].height + footStep
                    newPosition[0] = myOffset
                    frameData.nowCharacterFrameY[0] = frameData.characterFrame[0].origin.y+newPosition[0].height//移動後座標
                    setLocation(location: Location(name: "\(userName)", x: myOffset.width, y: myOffset.height))
                    
                    
                    print("down :")
                    print(frameData.nowCharacterFrameX[0],frameData.nowCharacterFrameY[0])
                    
                }, label: {
                    Image(systemName: "chevron.down.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                }).position(x: 50, y: 350)
                
//功能鍵//////////////////////////////
                Group{
                    
                    Button(action: {
                        initial()
                        
                    }, label: {
                        Text("遊戲開始")
                            .padding(7)
                            .padding(.horizontal, 25)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .padding(.horizontal, 10)
                    }).position(x: 750, y: 150)
                    
                    
                    Button(action: {
                        intersectionReturn = judgeIntersection(objectX: frameData.nowCharacterFrameX[0], objectY: frameData.nowCharacterFrameY[0])
                        
                        if  intersectionReturn == 10{
                            print("10")
                        }else if intersectionReturn == 0{
                            print("洗菜 : 0")
                            //ifTake.toggle()
                            cutVegetable += 1
                        }else if intersectionReturn == 2{
                            print("洗菜 : 2")
                            cutTomato += 1
                        }
                        
                    }, label: {
                        Text("洗菜")
                            .padding(7)
                            .padding(.horizontal, 25)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .padding(.horizontal, 10)
                    }).position(x: 750, y: 250)
                    
                    Button(action: {
                        
                        intersectionReturn = judgeIntersection(objectX: frameData.nowCharacterFrameX[0], objectY: frameData.nowCharacterFrameY[0])
                        print("character at :")
                        print(frameData.nowCharacterFrameX[0],frameData.nowCharacterFrameY[0])
                        print("frameData.foodFrame[4]:\(frameData.foodFrameX[4]),\(frameData.foodFrameY[4])")
                        print("frameData.foodFrame[5]:\(frameData.foodFrameX[5]),\(frameData.foodFrameY[5])")
                        print("frameData.foodFrame[6]:\(frameData.foodFrameX[6]),\(frameData.foodFrameY[6])")
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
                                cutTomato -= 1
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
                        
                    }, label: {
                        Text("\(nextAction):\(takeWhat)")
                            .padding(7)
                            .padding(.horizontal, 25)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .padding(.horizontal, 10)
                    }).position(x: 750, y: 300)
                    
                    
                    Button(action: {
                        if orderTomatoNum == cookingTomatoNum && orderVegetableNum == cookingVegetableNum {
                            coin += 100*(orderTomatoNum + orderVegetableNum)
                            cookingTomatoNum = 0
                            cookingVegetableNum = 0
                            updateOrder()
                            correctNum+=1
                        }
                        
                    }, label: {
                        Text("做菜")
                            .padding(7)
                            .padding(.horizontal, 25)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .padding(.horizontal, 10)
                    }).position(x: 750, y: 400)
                    
                }
                
                
            }
//人物位置
            KFImage(URL(string: "\(URLString_Player1)"))
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .offset(offset1)
                .overlay(
                    GeometryReader(content: { geometry in
                        
                        let _ = updateCharacterFrame(geometry: geometry)
                        Color.clear
                           
                    })
                 )
            KFImage(URL(string: "\(URLString_Player2)"))
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .offset(offset2)
            KFImage(URL(string: "\(URLString_Player3)"))
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .offset(offset3)
            
            
        }.onAppear(perform:{
            if ifTake == false{
                nextAction = "拿取"
            }else{
                nextAction = "放下"
            }
            //取位置
            nowCharacterFrameX = [CGFloat](repeating: CGFloat.zero, count: 3)//新的絕對位置Answer
            nowCharacterFrameY = [CGFloat](repeating: CGFloat.zero, count: 3)
            
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
            })
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(roomDocumentName: .constant("Room2"))
            .previewLayout(.fixed(width: 844, height: 390))
            .previewDevice("iPhone 11")
            .environment(\.horizontalSizeClass, .regular)
            
    }
    
}

