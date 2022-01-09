//
//  PositiveRegistrationConfirm.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2022/01/09.
//

import SwiftUI

struct PositiveRegistrationConfirm: View {
    @State var isActiveNavigate = false
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 32) {
                    VStack(spacing: 16) {
                        Text("陽性登録の前にお読みください")
                            .font(.system(size: 21))
                            .bold()
                        VStack(spacing: 8) {
                            Text("・本アプリで陽性登録すると、スマートフォン内で日毎に生成された符号が、通知サーバーにアップロードされます")
                            Text("・通知サーバーの符号情報から判定の結果、接触した人に通知が届きます")
                            Text("・その通知が届いた人に、あなた個人が特定される情報が知られることはありません")
                            Text("・感染拡大防止のため、登録にご協力をお願いします")
                        }
                        Text("詳しくは以下をお読みください")
                    }
                    .padding()
                    .background(CardBackground())
                    VStack(spacing: 32) {
                        VStack(spacing: 16) {
                            Text("あなたが保健所や医療機関に伝えた（※）携帯電話番号またはメールアドレスが「新型コロナウイルス感染症等情報把握・管理支援システム」という全国的システム（以下「管理システム」という）に登録されています")
                            Text("※新型コロナウイルスの検査で陽性となった時などに連絡先として伝えたもの")
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                        }
                        Image(systemName: "arrowtriangle.down.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.gray)
                        
                        Text("管理システムに陽性情報が報告されると、登録されている携帯電話番号またはメールアドレスに、COCOA（※）の陽性登録に必要な「処理番号」が通知されます")
                        
                        Image(systemName: "arrowtriangle.down.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.gray)
                        Text("処理番号をCOCOAに登録すると、携帯電話から管理システムに対し、正しい処理番号であるかどうかの照会が行われます")
                        
                        Image(systemName: "arrowtriangle.down.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.gray)
                        Text("処理番号が正しい場合には、症状が始まった日または検査を受けた日の2日前以降にあなたと接触した人（概ね1メートル以内で15分以上近接した可能性のあるアプリ使用者）に、通知が届きます。その通知が届いた人に、あなた個人が特定される情報が知られることはありません")
                    }
                    DefaultButton(title: "同意して陽性登録する") {
                        isActiveNavigate = true
                    }
                }
                .padding()
                Spacer()
                    .frame(height: 64)
            }
            NavigationLink(isActive: $isActiveNavigate) {
                PositiveRegistration()
            } label: {
                EmptyView()
            }
        }
        .navigationBarTitle("陽性登録への同意")
    }
}

struct PositiveRegistrationConfirm_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PositiveRegistrationConfirm()
        }
    }
}
