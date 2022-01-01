//
//  HowToReset.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2021/12/31.
//

import SwiftUI

struct HowToReset: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 64) {
                VStack(spacing: 16) {
                    Text("メニューの設定から「アプリを初期化」を選択することで、保存されている過去14日間の接触履歴を削除して、アプリを初期状態に戻すことができます。")
                    Text("再度アプリの利用を開始するまで、接触の記録や通知は行われなくなります")
                }
                DefaultButton(systemImageName: "rectangle.portrait.and.arrow.right", title: "設定を開く") {
                    
                }
            }
            .padding(16)
            .navigationBarTitle("アプリの初期化")
        }
    }
}

struct HowToReset_Previews: PreviewProvider {
    static var previews: some View {
        HowToReset()
    }
}
