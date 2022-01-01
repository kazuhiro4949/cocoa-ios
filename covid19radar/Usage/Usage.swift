//
//  Usage.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2021/12/31.
//

import SwiftUI

struct Usage: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink("どのように接触を記録していますか？") {
                    HowToTraceExposure()
                }
                NavigationLink("接触の有無はどのように知ることができますか？") {
                    HowToCheckExposure()
                }
                NavigationLink("新型コロナウィルスに感染していると判明したら") {
                    ForPositiveUser()
                }
                NavigationLink("接触の記録を削除してアプリを初期状態に戻すには") {
                    HowToReset()
                }
            }
            .navigationBarTitle("使い方")
        }
    }
}

struct Usage_Previews: PreviewProvider {
    static var previews: some View {
        Usage()
    }
}
