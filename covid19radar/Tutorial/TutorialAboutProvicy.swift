//
//  TutorialAboutProvicy.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2022/01/03.
//

import SwiftUI

struct TutorialAboutProvicy: View {
    @Binding var step: TutorialStep
    
    var body: some View {
        VStack {
            ScrollView {
                Text("プライバシーについて")
                    .font(.system(size: 26))
                    .bold()
                    .padding()
                VStack(spacing: 32) {
                    Image("TutorialPage20")
                    VStack(spacing: 17) {
                        Text("氏名・電話番号などの個人情報や、GPS（※）などスマートフォンの位置情報を使うことはなく、記録されることもありません。")
                        Text("接触の記録は、暗号化され、あなたのスマートフォンの中にのみ記録され、14日後に自動的に削除されます。行政機関や第三者が暗号化された情報を利用して接触歴を把握することはありません。")
                        Text("接触の記録はいつでも止めることができます。アプリ内の設定を無効にするか、アプリを削除してください。")
                    }
                }.padding()
            }
            DefaultButton(title: "利用規約へ") {
                step = .terms
            }.padding()
        }
    }
}

struct TutorialAboutProvicy_Previews: PreviewProvider {
    static var previews: some View {
        TutorialAboutProvicy(step: .constant(.aboutPrivacy))
    }
}
