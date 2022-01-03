//
//  HelthCheckUnauthorized.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2022/01/03.
//

import SwiftUI

struct HelthCheckUnauthorized: View {
    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(Color.yellow)
                            .frame(width: 15, height: 15)
                    }
                    Text("停止中")
                        .font(.headline)
                }
                VStack(alignment: .leading) {
                    Text("現在、接触を記録できていません。")
                    Text("接触通知を有効にするため、必要な対処方法を確認してください。")
                }
                .font(.system(size: 14))
                .frame(width: 250)
            }
            NavigationLink("対処方法を確認") {
                HelthCheckTroubleShooting()
            }
            .foregroundColor(.blue)
        }
    }
}

struct HelthCheckUnauthorized_Previews: PreviewProvider {
    static var previews: some View {
        HelthCheckUnauthorized()
    }
}
