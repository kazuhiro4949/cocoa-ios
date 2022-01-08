//
//  SomePositiveExposures.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2022/01/08.
//

import SwiftUI

struct SomePositiveExposures: View {
    var body: some View {
        List {
            Section {
                HStack(alignment: .center) {
                    Spacer()
                    Image(systemName: "exclamationmark.triangle")
                    Text("以下の日に陽性者との接触が確認されました。")
                    Spacer()
                }
                .padding([.top, .bottom], 16)
                .font(.system(size: 14))
            }
            Section(header: Text("一覧")) {
                HStack {
                    Text("2021年10月1日")
                    Spacer()
                    Text("10回")
                        .foregroundColor(.secondary)
                }
                HStack {
                    Text("2021年10月1日")
                    Spacer()
                    Text("10回")
                        .foregroundColor(.secondary)
                }
            }
        }
        .listStyle(.grouped)
    }
}

struct SomePositiveExposures_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SomePositiveExposures()
        }
    }
}
