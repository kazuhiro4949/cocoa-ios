//
//  Inquery.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2021/12/31.
//

import SwiftUI

struct Inquery: View {
    var body: some View {
        NavigationView {
            List {
                Section {
                    Button {
                        
                    } label: {
                        HStack(alignment: .center) {
                            Image(systemName: "questionmark.circle")
                            Text("よくある質問")
                        }
                    }
                    Button {
                        
                    } label: {
                        HStack(alignment: .center) {
                            Image(systemName: "envelope")
                            Text("メールでお問い合わせ")
                        }
                    }
                }
                Section {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("アプリの改善にご協力ください")
                            .font(.system(size: 18))
                        Text("お問い合わせ後、動作情報を送信いただくことで本アプリの改善に役立ちます。")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                        HStack {
                            Spacer()
                            DefaultButton(
                                systemImageName: "icloud.and.arrow.up.fill",
                                title: "動作情報の送信") {
                                    
                                }
                            Spacer()
                        }
                    }.padding(.vertical, 16)
                }
                Section {
                    Button {
                        
                    } label: {
                        HStack(alignment: .center) {
                            Image(systemName: "info.circle")
                            Text("接触確認アプリに関する情報")
                        }
                    }
                }
            }
            .listStyle(.grouped)
            .navigationBarTitle("お問い合わせ")
        }
    }
}

struct Inquery_Previews: PreviewProvider {
    static var previews: some View {
        Inquery()
    }
}
