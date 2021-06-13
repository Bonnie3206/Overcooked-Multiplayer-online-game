//
//  test0614.swift
//  iOSFinal
//
//  Created by CK on 2021/6/14.
//

import SwiftUI
import Kingfisher

struct test0614: View {
    var body: some View {
        let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/final2-3da54.appspot.com/o/E1124AF6-2BE6-48F3-B878-EA7F620826EF.jpg?alt=media&token=fda505dc-e90f-49ee-be33-176983c80612")!
        KFImage(url)
            .resizable()
            .scaledToFit()
            .frame(width: 150, height: 180)
    }
}

struct test0614_Previews: PreviewProvider {
    static var previews: some View {
        test0614()
    }
}
