//
//  TutorialHowToUse.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2022/01/03.
//

import SwiftUI

struct TutorialHowToUse: View {
    @Binding var step: TutorialStep
    
    var body: some View {
        VStack {
            ScrollView {
                Text("このアプリでできること")
                    .font(.system(size: 26))
                    .bold()
                    .padding()
                VStack(spacing: 32) {
                    HStack {
                        Image("TutorialPage10")
                            .frame(width: 110, height: 110)
                        Text("本アプリをスマートフォンに設定した人どうしの接触を記録します。")
                    }
                    HStack {
                        Text("新型コロナウイルスに陽性と判定されたら本アプリに匿名で登録することができます。")
                        Image("TutorialPage11")
                            .frame(width: 110, height: 110)
                    }
                    HStack {
                        Image("TutorialPage12")
                            .frame(width: 110, height: 110)
                        Text("最近接触した人の中に陽性登録した人がいたら、通知と適切な行動をお知らせします。")
                    }
                }.padding()
            }
            DefaultButton(title: "次へ") {
                step = .aboutPrivacy
            }.padding()
        }
    }
}

struct TutorialHowToUse_Previews: PreviewProvider {
    static var previews: some View {
        TutorialHowToUse(step: .constant(.howToUse))
    }
}
