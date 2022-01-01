//
//  HowToTraceExposure.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2021/12/31.
//

import SwiftUI

struct HowToTraceExposure: View {
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(spacing: 32) {
                    VStack(spacing: 16) {
                        Text("端末の識別")
                            .font(.system(size: 21))
                            .bold()
                        Image("HelpPage20")
                            .resizable()
                            .scaledToFit()
                            .frame(width: proxy.size.width - 32, height: 100)
                        VStack(alignment: .leading, spacing: 16) {
                            Text("アプリを実行した際に、各スマートフォンで接触符号（※1）を生成して持ちます。氏名・電話番号などの個人情報やGPS（※2）などスマートフォンの位置情報を使うことはなく、記録されることもありません。")
                            Text("※1 利用者の端末内で作られ、端末同士の接触を記録するために使用する符号")
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                            Text("※2 位置を特定する仕組み")
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    VStack(spacing: 16) {
                        Text("記録される接触の条件")
                            .font(.system(size: 21))
                            .bold()
                        Image("HelpPage22")
                            .resizable()
                            .scaledToFit()
                            .frame(width: proxy.size.width - 32, height: 200)
                        VStack(alignment: .leading, spacing: 16) {
                            Text("1メートル以内、15分以上の他のアプリユーザーとの接触は「接触」として記録されます。")
                        }
                    }
                    
                    VStack(spacing: 16) {
                        Text("接触情報の記録")
                            .font(.system(size: 21))
                            .bold()
                        Image("HelpPage21")
                            .resizable()
                            .scaledToFit()
                            .frame(width: proxy.size.width - 32, height: 100)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("このとき、接触した相手の接触符号の記録をアプリに行います。どちらかの利用者が陽性の登録を行うまでは接触の情報は利用されません。接触の履歴は14日後に消去されます。 ※接触符号は定期的に変わります。")
                        }
                    }
                }
                .padding(EdgeInsets(top: 32, leading: 16, bottom: 32, trailing: 16))
            }
            .navigationBarTitle("接触の記録方法")
        }
    }
}

struct UsageExposureCheck_Previews: PreviewProvider {
    static var previews: some View {
        HowToTraceExposure()
    }
}
