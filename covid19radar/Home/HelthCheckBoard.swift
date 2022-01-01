//
//  HelthCheckBoard.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2021/12/31.
//

import SwiftUI

struct HelthCheckBoard: View {
    @Binding var value: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 15, height: 15)
                        .opacity(value ? 0 : 0.3)
                        .animation(.linear(duration: 0.5)
                                    .delay(2.5)
                                    .repeatForever(autoreverses: false), value: value)
                        .scaleEffect(value ? 2.5 : 1)
                        .animation(.linear(duration: 3).repeatForever(autoreverses: false), value: value)
                    Circle()
                        .fill(Color.green)
                        .frame(width: 15, height: 15)
                }
                Text("動作中")
                    .font(.headline)
            }
            HStack {
                Button {
                    
                } label: {
                    HStack(spacing: 4) {
                        Text("接触有無の最終確認日時")
                            .foregroundColor(.primary)
                        Image(systemName: "questionmark.circle")
                    }
                    .font(.system(.caption))
                    .padding(.leading, 16)
                }
            }
            Text("取得中")
                .font(.system(.caption))
        }
    }
}

struct HelthCheckBoard_Previews: PreviewProvider {
    static var previews: some View {
        HelthCheckBoard(value: .constant(true))
    }
}
