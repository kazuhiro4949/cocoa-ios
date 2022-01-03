//
//  HelthCheckActive.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2022/01/03.
//

import SwiftUI

struct HelthCheckActive: View {
    @Binding var value: Bool
    
    var body: some View {
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
    }
}

struct HelthCheckActive_Previews: PreviewProvider {
    static var previews: some View {
        HelthCheckActive(value: .constant(true))
    }
}
