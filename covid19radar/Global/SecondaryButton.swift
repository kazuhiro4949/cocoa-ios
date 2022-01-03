//
//  SecondaryButton.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2022/01/03.
//

import SwiftUI

struct SecondaryButton: View {
    var systemImageName: String?
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 8) {
                if let systemImageName = systemImageName {
                    Image(systemName: systemImageName)
                }
                Text(title)
                    .font(.system(size: 16))
                    .bold()
            }
            .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 44)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(.gray, lineWidth: 1)
        )
    }
}

struct SecondaryButton_Previews: PreviewProvider {
    static var previews: some View {
        SecondaryButton(systemImageName: "person.2.fill", title: "陽性者との接触結果") {}
    }
}
