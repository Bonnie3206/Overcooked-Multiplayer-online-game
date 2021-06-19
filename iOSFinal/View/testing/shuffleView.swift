//
//  shuffleView.swift
//  iOSFinal
//
//  Created by CK on 2021/6/16.
//

import SwiftUI


struct shuffleView: View {
    
    @State var albums = ["bearbody1", "bearbody2", "bearbody3", "bearbody4","bearbody5","bearbody6"]
    
    var body: some View {
        
        List {
            ForEach(albums, id: \.self) { album in
                HStack {
                    Image(album)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 150)
                    Text(album)
                    
                }
            }
            
        }
        .onTapGesture {
            withAnimation {
                albums.shuffle()
            }
        }
    }
}
struct shuffleView_Previews: PreviewProvider {
    static var previews: some View {
        shuffleView()
    }
}
