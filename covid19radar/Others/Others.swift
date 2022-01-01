//
//  Others.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2021/12/31.
//

import SwiftUI

struct Others: View {
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Text("アプリバージョン")
                        Spacer()
                        Text("3.0.0")
                    }
                }
                Section {
                    NavigationLink("ライセンス表記") {
                        
                    }
                    NavigationLink("利用規約") {
                        
                    }
                    NavigationLink("プライバシーポリシー") {
                        
                    }
                    NavigationLink("ウェブアクセシビリティ方針") {
                        
                    }
                } header: {
                    Text("情報")
                }
                Section {
                    Button {
                        
                    } label: {
                        VStack( spacing: 16) {
                            Text("アプリを初期化する")
                            Text("保存されている過去14日間の接触履歴を削除して、アプリを初期状態に戻します。再度アプリの利用を開始するまで、接触通知は行われなくなります。")
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                        }
                        .padding(8)
                    }
                } header: {
                    Text("設定")
                }
            }
            .listStyle(.grouped)
            .navigationBarTitle("その他")
        }
    }
}

struct Others_Previews: PreviewProvider {
    static var previews: some View {
        Others()
    }
}
