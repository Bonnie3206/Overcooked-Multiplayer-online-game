//
//  Test0622View.swift
//  iOSFinal
//
//  Created by CK on 2021/6/22.
//
import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseStorageSwift//要有swift的,才有result
import Kingfisher
import FirebaseFirestoreSwift
import Firebase
import AppTrackingTransparency
import SwiftUI
import OMJoystick
//import TILogger
//import SFSafeSymbols

struct Test0622View: View {

    @State var isDragging = false
    @State var dragValue = CGSize.zero
    @State var newOffsetX = CGFloat.zero
    @State var newOffsetY = CGFloat.zero
    @State private var receiveTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            Image("煮飯")
                .resizable()
                .scaleEffect(0.1)
                .offset(x: newOffsetX, y: newOffsetY)
            Text("width: \(dragValue.width)")
            Text("height: \(dragValue.height)")
            
            VStack (spacing: 16) {
                HStack(spacing: 35) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.gray)
                    VStack (spacing: 80) {
                        Image(systemName: "chevron.up")
                            .foregroundColor(.gray)
                        Image(systemName: "chevron.down")
                            .foregroundColor(.gray)

                    }
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
            }
            .offset(x: dragValue.width * 0.05, y: dragValue.height * 0.05)

            .frame(width: 150, height: 150)

            .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), Color(#colorLiteral(red: 0.8705882353, green: 0.8941176471, blue: 0.9450980392, alpha: 1))]), startPoint: .top, endPoint: .bottom))
            .clipShape(Circle())
            .offset(x: dragValue.width, y: dragValue.height)

            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
            .padding(.horizontal, 30)
            .gesture(
                DragGesture().onChanged { value in
                    let limit: CGFloat = 100        // the less the faster resistance
                    let xOff = value.translation.width
                    let yOff = value.translation.height
                    let dist = sqrt(xOff*xOff + yOff*yOff);
                    let factor = 1 / (dist / limit + 1)
                    self.dragValue = CGSize(width: value.translation.width * factor,
                                        height: value.translation.height * factor)
                    self.isDragging = true
                }
            )
                .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
        }.onReceive(receiveTimer, perform: { (_) in
            
            newOffsetX += dragValue.width * 0.05
            newOffsetY += dragValue.height * 0.05
        })

    }

    /*
    @State var foodFrame = [CGRect](repeating: CGRect.zero, count:7)
    @State var x : CGPoint
    let iconSetting = IconSetting(
        leftIcon: Image(systemName: "chevron.left.circle.fill"),
        rightIcon: Image(systemName: "chevron.right.circle.fill"),
        upIcon: Image(systemName: "chevron.up.circle.fill"),
        downIcon: Image(systemName: "chevron.down.circle.fill")
    )
    
    let colorSetting = ColorSetting(subRingColor: .red, bigRingNormalBackgroundColor: .green, bigRingDarkBackgroundColor: .blue, bigRingStrokeColor: .yellow)
    
    func update(geometry: GeometryProxy) {
        // 412 ,-160 tomato與人物神秘的座標差
        foodFrame[1]=(geometry.frame(in: .global))
        print("\(foodFrame[1].origin.x)")
        print("\(foodFrame[1].origin.y)")
        
        
    }
    var body: some View {
        VStack{
            GeometryReader { geometry in
                VStack(alignment: .center, spacing: 5) {
                    OMJoystick(isDebug: true, iconSetting: self.iconSetting,  colorSetting: ColorSetting(), smallRingRadius: 10, bigRingRadius: 30
                    ) { (joyStickState, stickPosition)  in
                        x = CGPoint(from: stickPosition)
                        
                    }.frame(width: geometry.size.width-40, height: geometry.size.width-40)
                    Button(action: {
                        update(geometry: geometry)
                        
                    }, label: {
                        Text("hi")
                    })
                }
                
            }
            
            
        }
        
    }
    let iconSize: CGFloat = 40
            
        let iconSetting = IconSetting(
            leftIcon: Image(systemName: "chevron.left.circle.fill"),
            rightIcon: Image(systemName: "chevron.right.circle.fill"),
            upIcon: Image(systemName: "chevron.up.circle.fill"),
            downIcon: Image(systemName: "chevron.down.circle.fill")
        )
        
        let colorSetting = ColorSetting(subRingColor: .red, bigRingNormalBackgroundColor: .green, bigRingDarkBackgroundColor: .blue, bigRingStrokeColor: .yellow, iconColor: .red)
        
        var body: some View {
            GeometryReader { geometry in
                VStack(alignment: .center, spacing: 5) {
                    OMJoystick(isDebug: true, colorSetting: self.colorSetting) { (joyStickState, stickPosition) in
                        TILogger().info(joyStickState.rawValue)
                        TILogger().info(stickPosition)
                        
                    }.frame(width: geometry.size.width-40, height: geometry.size.width-40)
                    
                    OMJoystick(isDebug: true, iconSetting: self.iconSetting,  colorSetting: ColorSetting(iconColor: .orange), smallRingRadius: 70, bigRingRadius: 120
                    ) { (joyStickState, stickPosition)  in
                        TILogger().info(joyStickState.rawValue)
                        TILogger().info(stickPosition)
                        
                    }.frame(width: geometry.size.width-40, height: geometry.size.width-40)
                }
            }
        }*/
}

struct Test0622View_Previews: PreviewProvider {
    static var previews: some View {
        Test0622View()
    }
}
/*
struct Test0622View: View {

    var body: some View {
        OMJoystick(colorSetting: ColorSetting()) { (joyStickState, stickPosition) in
        }
    }
}

struct Test0622View_Previews: PreviewProvider {
    static var previews: some View {
        Test0622View()
    }
}
*/
