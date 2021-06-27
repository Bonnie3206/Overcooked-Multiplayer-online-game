//
//  test0621View.swift
//  iOSFinal
//
//  Created by CK on 2021/6/21.
//

import SwiftUI

struct test0621View: View {
    
    @State private var circleColorChanged = false
    @State private var flameColorChanged = false
    @State private var flameSizeChanged = false
    var body: some View {
        
        ZStack {
            Circle()
                .frame(width: 200, height: 200)
                .foregroundColor(circleColorChanged ? Color(.systemGray5) : .red)
         
            Image(systemName: "flame.fill")
                .foregroundColor(flameColorChanged ? .red : .white)
                .font(.system(size: 100))
                .scaleEffect(flameSizeChanged ? 1.0 : 0.5)
        }
        .onTapGesture {
            withAnimation(.default) {
                self.circleColorChanged.toggle()
                self.flameColorChanged.toggle()
                self.flameSizeChanged.toggle()
            }
        }
    }
    /*
    @State private var isLoading = true
     
        var body: some View {
            Circle()
                .trim(from: 0, to: 0.7)
                .stroke(Color.green, lineWidth: 5)
                .frame(width: 100, height: 100)
                .rotationEffect(Angle(degrees: isLoading ? 360 : 0))
                .animation(Animation.default.repeatForever(autoreverses: false))
                /*
                .onAppear() {
                    self.isLoading = true
                }*/
        }
 */
}

struct test0621View_Previews: PreviewProvider {
    static var previews: some View {
        test0621View()
    }
}
