//
//  DefaultButton.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2021/12/31.
//

import SwiftUI

struct DefaultButton: View {
    let systemImageName: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 8) {
                Image(systemName: systemImageName)
                Text(title)
                    .font(.system(size: 16))
                    .bold()
            }
            .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 44)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.blue)
        )
        
    }
}

struct DefaultButton_Previews: PreviewProvider {
    static var previews: some View {
        DefaultButton(systemImageName: "person.2.fill", title: "陽性者との接触結果") {}
        
    }
}
