//
//  TutorialThanks.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2022/01/03.
//

import SwiftUI

struct TutorialThanks: View {
    var next: (TutorialStep.FinishedDestination) -> Void
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 32) {
                    Image("TutorialPage60")
                    VStack(spacing: 17) {
                        Text("新型コロナウイルス接触確認アプリ")
                            .font(.system(size: 26))
                            .bold()
                            .padding()
                        Text("ご登録いただきありがとうございました。")
                            .font(.system(size: 26))
                            .bold()
                            .padding()
                    }
                }.padding()
            }
            VStack(spacing: 16) {
                DefaultButton(title: "ホーム画面へ") {
                    next(.home)
                }
                .padding([.leading, .trailing, .top], 16)
                SecondaryButton(title: "使い方を学ぶ") {
                    next(.usage)
                }
                .padding([.leading, .trailing, .bottom], 16)
            }
        }
    }
}

struct TutorialThanks_Previews: PreviewProvider {
    static var previews: some View {
        TutorialThanks { _ in }
    }
}
