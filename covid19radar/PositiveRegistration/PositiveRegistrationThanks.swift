//
//  SwiftUIView.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2022/01/09.
//

import SwiftUI

struct PositiveRegistrationThanks: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Image("TutorialPage60")
                VStack(spacing: 8) {
                    Text("新型コロナウイルス接触確認アプリ")
                        .font(.system(size: 21))
                        .bold()
                    Text("陽性のご登録をいただきありがとうございました")
                        .font(.system(size: 21))
                        .bold()
                }
                Text("登録は匿名で行われ、氏名や連絡先など個人が特定される情報を登録する必要はありません。また、接触した場所の位置情報が記録や通知されることもありません。")
                    .padding()
                AppShareSheetButton()
            }
            .padding()
        }
        .navigationBarTitle(Text("登録完了"))
    }
}

struct PositiveRegistrationThanks_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PositiveRegistrationThanks()
        }
    }
}
