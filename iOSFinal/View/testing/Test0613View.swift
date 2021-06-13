//
//  Test0613View.swift
//  iOSFinal
//
//  Created by CK on 2021/6/13.
//

import SwiftUI

struct Test0613View: View {
    var body: some View {
        Button(action: {
            fetchPlayers()
        }, label: {
            Text("進入遊戲")
        })
    }
}

struct Test0613View_Previews: PreviewProvider {
    static var previews: some View {
        Test0613View()
    }
}
