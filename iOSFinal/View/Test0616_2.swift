//
//  Test0616_2.swift
//  iOSFinal
//
//  Created by CK on 2021/6/16.
//

import SwiftUI

struct Test0616_2: View {
    var body: some View {
        let showURL_Player1 = URL(string: "https://firebasestorage.googleapis.com/v0/b/final2-3da54.appspot.com/o/E1124AF6-2BE6-48F3-B878-EA7F620826EF.jpg?alt=media&token=fda505dc-e90f-49ee-be33-176983c80612")!
        var articleString = showURL_Player1.absoluteString
        Text("\(articleString)")
    }
}

struct Test0616_2_Previews: PreviewProvider {
    static var previews: some View {
        Test0616_2()
    }
}
