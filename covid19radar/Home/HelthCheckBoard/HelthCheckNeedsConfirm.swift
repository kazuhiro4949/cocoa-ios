//
//  HelthCheckNeedsConfirm.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2022/01/03.
//

import SwiftUI

struct HelthCheckNeedsConfirm: View {
    var body: some View {
        VStack(spacing: 8) {
            VStack(spacing: 8) {
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 15, height: 15)
                    }
                    Text("接触有無を確認できません")
                        .font(.headline)
                }
                VStack(alignment: .leading) {
                    Text("お手数をおかけします。")
                    Text("解決のため下記リンクより対処方法をご確認ください。")
                }
                .font(.system(size: 12))
                .frame(width: 250)
            }
            NavigationLink("対処方法を確認") {
                HelthCheckTroubleShooting()
            }
            .font(.system(size: 14))
            .foregroundColor(.blue)
        }
    }
}

struct HelthCheckNeedsConfirm_Previews: PreviewProvider {
    static var previews: some View {
        HelthCheckNeedsConfirm()
    }
}
