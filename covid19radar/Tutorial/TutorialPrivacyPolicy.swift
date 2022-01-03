//
//  TutorialPrivacyPolicy.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2022/01/03.
//

import SwiftUI

struct TutorialPrivacyPolicy: View {
    var next: () -> Void
    
    var body: some View {
        VStack {
            Text("プライバシーポリシー")
                .font(.system(size: 26))
                .bold()
                .padding()
            // TODO: - Error Handling?
            WebView(url: .constant(.privacyPolicyWebPage))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            DefaultButton(title: "同意する") {
                UserDefaults.standard.set(Date(), forKey: "PrivacyPolicyLastUpdated")
                next()
            }.padding()
        }
    }
}

struct TutorialPrivacyPolicy_Previews: PreviewProvider {
    static var previews: some View {
        TutorialPrivacyPolicy {}
    }
}
