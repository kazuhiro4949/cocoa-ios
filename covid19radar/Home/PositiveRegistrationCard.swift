//
//  PositiveRegistrationCard.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2021/12/31.
//

import SwiftUI

struct PositiveRegistrationCard: View {
    @State private var isNavigatingPositiveRegistration = false
    var body: some View {
        ZStack {
            NavigationLink(
                destination: PositiveRegistrationConfirm(),
                isActive: $isNavigatingPositiveRegistration) { EmptyView() }
            
            CardBackground()
            VStack(spacing: 32) {
                VStack(spacing: 8) {
                    Text("陽性と診断されたら")
                        .font(.system(size: 21))
                        .bold()
                    Text("周りの人たちを守るために匿名での陽性登録へのご協力をお願いします")
                        .font(.caption)
                }
                DefaultButton(
                    systemImageName: "icloud.and.arrow.up.fill",
                    title: "陽性情報の登録") {
                            isNavigatingPositiveRegistration = true
                    }
            }
            .padding(32)
        }
    }
}

struct PositiveRegistrationCard_Previews: PreviewProvider {
    static var previews: some View {
        PositiveRegistrationCard()
    }
}
