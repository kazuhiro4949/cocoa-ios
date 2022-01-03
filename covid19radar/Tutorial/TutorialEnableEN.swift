//
//  TutorialEnableEN.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2022/01/03.
//

import SwiftUI

struct TutorialEnableEN: View {
    @ObservedObject private var viewModel = TutorialEnableENViewModel()
    @State private var isFailedToStartEN = false
    var next: () -> Void
    
    var body: some View {
        VStack {
            ScrollView {
                Text("接触検知をご利用いただくために")
                    .font(.system(size: 26))
                    .bold()
                    .padding()
                VStack(spacing: 32) {
                    Image("TutorialPage50")
                    VStack(alignment: .leading, spacing: 16) {
                        Text("本アプリで接触検知をご利用いただくために、スマートフォンのBluetooth（ブルートゥース）（※）通信を有効にしてください。")
                        Text("※機器同士を繋ぐ無線通信システム")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                }.padding()
            }
            VStack(spacing: 16) {
                DefaultButton(title: "有効にする") {
                    Task {
                        do {
                            try await viewModel.startEN()
                            next()
                        } catch {
                            isFailedToStartEN = true
                        }
                    }
                }
                .padding([.leading, .trailing, .top], 16)
                .alert(isPresented: $isFailedToStartEN) {
                    Alert(
                        title: Text("エラー"),
                        message: Text("失敗しました。OS設定からオンにしてください。"),
                        dismissButton: .default(Text("OK"), action: {
                            next()
                        })
                    )
                }
                SecondaryButton(title: "あとで設定する") {
                    next()
                }.padding([.leading, .trailing, .bottom], 16)
            }
        }
    }
}

class TutorialEnableENViewModel: ObservableObject {
    @Published var loadingState: LoadingState = .terminated
    
    func startEN() async throws {
        do {
            loadingState = .loading
            try await ExposureManager.shared.activateENManager()
            try await ExposureManager.shared.enableENManagerIfNeeded()
            loadingState = .completed
        } catch {
            loadingState = .failed
            throw error
        }
    }
}

struct TutorialEnableEN_Previews: PreviewProvider {
    static var previews: some View {
        TutorialEnableEN {}
    }
}
