//
//  Test0617View.swift
//  iOSFinal
//
//  Created by CK on 2021/6/17.
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


struct Test0617View: View {
    
    @State var characterFrame  = [CGRect](repeating: CGRect.zero, count: 3)//有三個第一次的絕對位置
    @State var foodFrame = [CGRect](repeating: CGRect.zero, count: 6)//有六個食物位置[0青菜上,切好的青菜上,切好的青菜下,番茄,切好的番茄上,切好的番茄下]
    //之後一直變化
    @State var nowCharacterFrameX = [CGFloat](repeating: CGFloat.zero, count: 3)//新的絕對位置Answer
    @State var nowCharacterFrameY = [CGFloat](repeating: CGFloat.zero, count: 3)
    //food不動,不變
    @State var foodFrameX = [CGFloat](repeating: CGFloat.zero, count: 6)
    @State var foodFrameY = [CGFloat](repeating: CGFloat.zero, count: 6)
    
    @State private var newPosition = [CGSize.zero]
    
    var frameData = FrameData()
    
    func judgeIntersection(objectX: CGFloat, objectY: CGFloat)->Int{//input人 對比跟六種菜是否有交集
        let objectRect = CGRect(x: objectX, y: objectY, width: 100, height: 100)
        for index in (0..<5){
            
            let targetRect = CGRect(x: frameData.foodFrameX[0], y: frameData.foodFrameY[0], width: 100, height: 100)//frameData.foodFrameX[index]暫時改成0
            
            //print("\(index),\(qaData.answerFrame[index].origin.x),\(qaData.answerFrame[index].origin.y)")
            let interRect = objectRect.intersection(targetRect)
            if(interRect.width>=1 || interRect.height>=1){
                
                print("Intersect")
                print("\(Int(interRect.width))")
                
                return Int(interRect.width)
                /*
                if(answers[num-1][index].isEqual(questions[num][wordIndex])){
                    
                    print("correct\(index)")
                    print("correctNum\(correctNum)")
                    
                    return index
                }//放對位置
                else{
                    return 200//放錯
                }*/
                
            }
        }
        return 0//沒放到
    }
    func updateCharacterFrame(geometry: GeometryProxy) {//0是自己
        
        frameData.characterFrame[0]=(geometry.frame(in: .global))
        //frameData.nowCharacterFrameX[0] = frameData.characterFrame[0].origin.x
        //frameData.nowCharacterFrameY[0] = frameData.characterFrame[0].origin.y
        //print(frameData.characterFrame[0].origin.x+newPosition[0].width)
    }
    
    func updateFoodFrame(geometry: GeometryProxy, index: Int) {
        
        frameData.foodFrame[index]=(geometry.frame(in: .global))
        //print("frameData.foodFrame[index]:\(frameData.foodFrame[index])")
    }
    var body: some View {
        Image("未洗的菜去背")//切菜桌
            .resizable()
            .scaledToFit()
            //.position(x: -700, y: -600)
            //.offset(x:-240,y:-130)
            .scaleEffect(0.20)
            
            .overlay(
                GeometryReader(content: { geometry in
                    
                    let _ = updateFoodFrame(geometry: geometry, index: 0)
                    Color.clear
                       
                })
             )
        Image("未洗的菜去背")//切菜桌
            .resizable()
            .scaledToFit()
            //.position(x: -700, y: -600)
            //.offset(x:-240,y:-130)
            .scaleEffect(0.20)
            
            .overlay(
                GeometryReader(content: { geometry in
                    
                    let _ = updateCharacterFrame(geometry: geometry)
                    Color.clear
                       
                })
             )
        Button(action: {
            
            print("gi\(judgeIntersection(objectX: frameData.characterFrame[0].origin.x, objectY: frameData.characterFrame[0].origin.y))")
            print("gi2x\(frameData.characterFrame[0].origin.x)")
            print("gi2y\(frameData.characterFrame[0].origin.y)")
            print("gi3x\(frameData.foodFrameX[0])")
            print("gi3y\(frameData.foodFrameY[0])")
            
        }, label: {
            Text("0")
        })
    }
}

struct Test0617View_Previews: PreviewProvider {
    static var previews: some View {
        Test0617View()
    }
}
