//
//  NoPositiveExposure.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2022/01/08.
//

import SwiftUI

struct NoPositiveExposure: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("陽性者との接触は確認されませんでした")
                    .font(.title)
                    .bold()
                Text("引き続き「新しい生活様式」の実践をよろしくお願いいたします。")
                Image("Nocontact10")
                AppShareSheetButton()
            }
            .padding()
        }
    }
}

struct NoPositiveExposure_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NoPositiveExposure()
        }
    }
}
