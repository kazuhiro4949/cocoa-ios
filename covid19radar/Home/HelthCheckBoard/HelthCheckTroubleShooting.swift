//
//  HelthCheckTroubleShooting.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2022/01/03.
//

import SwiftUI

struct HelthCheckTroubleShooting: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                Image("alert_workaround_img")
                VStack(alignment: .leading, spacing: 32) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("日本語のみ：※")
                        Text("日本語のみ：「ホーム」画面のイメージ画像")
                        Text("ホーム画面に「接触有無を確認できません」と表示された場合は、以下をお試しください。")
                        Text("・アプリの再起動を行ってください。")
                    }
                    Text("上記を試しても表示される場合は、カスタマーサポートまでお問い合わせください。")
                }
            }.padding()
        }.navigationBarTitle("対処方法")
    }
}

struct HelthCheckTroubleShooting_Previews: PreviewProvider {
    static var previews: some View {
        HelthCheckTroubleShooting()
    }
}
