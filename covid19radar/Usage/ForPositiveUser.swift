//
//  ForPositiveUser.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2021/12/31.
//

import SwiftUI

struct ForPositiveUser: View {
    var body: some View {
            ScrollView {
                VStack(spacing: 16) {
                    HStack(spacing: 32) {
                        Image("HelpPage40")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100)
                        Text("検査により新型コロナウイルスの感染が確認された場合")
                    }
                    HStack(spacing: 32) {
                        Text("保健所等公的機関から登録用の「処理番号」が発行されます")
                        Image("HelpPage41")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100)
                    }
                    HStack(spacing: 32) {
                        Image("HelpPage42")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100)
                        Text("本アプリを用いて処理番号の登録を行います")
                    }
                    HStack(spacing: 32) {
                        Text("発症日または検査日の二日前以降にあなたと接触した人に通知が届きます")
                        Image("HelpPage44")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100)
                    }
                    HStack(spacing: 32) {
                        Image("HelpPage45")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100)
                        Text("通知される情報はランダムな符号のみです。それ以外の、指名など個人情報や位置情報が送られることはありません")
                    }
                    
                    Spacer()
                        .frame(height: 120)
                    
                    DefaultButton(
                        systemImageName: "icloud.and.arrow.up.fill",
                        title: "陽性情報の登録") {

                        }
                }
                .padding(EdgeInsets(top: 32, leading: 16, bottom: 32, trailing: 16))
            }
            .navigationBarTitle("接触の記録方法")
    }
}

struct ForPositiveUser_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ForPositiveUser()
        }
    }
}
