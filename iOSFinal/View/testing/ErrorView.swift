//
//  ErrorView.swift
//  iOSFinal
//
//  Created by CK on 2021/6/2.
//

import SwiftUI

struct ErrorView: View {
    func buttonTap() {
            fatalError()
    }
    var body: some View {
        Button(action: buttonTap, label: {
            Text("Crash 吧，App")
                .font(.system(size: 50))
        })
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView()
    }
}
