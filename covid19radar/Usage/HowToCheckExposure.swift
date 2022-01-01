//
//  HowToCheckExposure.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2021/12/31.
//

import SwiftUI

struct HowToCheckExposure: View {
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(spacing: 64) {
                    VStack(spacing: 16) {
                        Text("通知")
                            .font(.system(size: 21))
                            .bold()
                        HStack(spacing: 32) {
                            Image("HelpPage30")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100)
                            VStack(alignment: .leading, spacing: 16) {
                                Text("接触した人の中に新型コロナウイルスの陽性登録された方がいた場合、スマートフォンに通知が届きます")
                            }
                        }
                    }
                    
                    VStack(spacing: 16) {
                        Text("ホーム画面")
                            .font(.system(size: 21))
                            .bold()
                        VStack {
                            Image("HelpPage31")
                                .resizable()
                                .scaledToFit()
                                .frame(width: proxy.size.width - 32, height: 100)
                            Text("※「ホーム」画面のイメージ画像")
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                        }
                        VStack(alignment: .leading, spacing: 16) {
                            Text("最近の接触件数の確認へはホーム画面からも移動することができます")
                        }
                    }
                    
                    VStack(spacing: 16) {
                        Text("陽性者と接触があった場合")
                            .font(.system(size: 21))
                            .bold()
                        VStack {
                            Image("HelpPage32")
                                .resizable()
                                .scaledToFit()
                                .frame(width: proxy.size.width - 32, height: 250)
                            Text("※「陽性者との接触確認」画面のイメージ画像")
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                        }
                        VStack(alignment: .leading, spacing: 16) {
                            Text("接触があった日付の一覧を確認できます。また適切な連絡先をお知らせします。")
                        }
                    }
                }
                .padding(EdgeInsets(top: 32, leading: 16, bottom: 32, trailing: 16))
            }
            .navigationBarTitle("接触の記録方法")
        }
    }
}

struct HowToCheckExposure_Previews: PreviewProvider {
    static var previews: some View {
        HowToCheckExposure()
    }
}
