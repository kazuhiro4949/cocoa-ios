//
//  TutorialTerms.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2022/01/03.
//

import SwiftUI

struct TutorialTerms: View {
    var next: () -> Void
    @ObservedObject private var viewModel = TutorialTermsViewModel()
    @State private var isFaildToConfirmed = false
    
    var body: some View {
        VStack {
            Text("利用規約")
                .font(.system(size: 26))
                .bold()
                .padding()
            // TODO: - Error Handling?
            WebView(url: .constant(.termsWebPage))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            DefaultButton(title: "同意する") {
                Task {
                    do {
                        try await viewModel.register()
                        UserDefaults.standard.set(Date(), forKey: "TermsLastUpdated")
                        UserDefaults.standard.set(Date(), forKey: "StartDate")
                        next()
                    } catch {
                        isFaildToConfirmed = true
                    }
                }
            }
            .disabled(viewModel.registrationState == .loading)
            .padding()
        }
        .overlay(
            viewModel.registrationState == .loading ? AnyView(Rectangle().fill(.white).opacity(0.5)) : AnyView(EmptyView())
        )
        .alert(isPresented: $isFaildToConfirmed) {
            Alert(
                title: Text("エラー"),
                message: Text("通信に失敗しました"),
                dismissButton: .default(Text("閉じる")))
        }
    }
}

class TutorialTermsViewModel: ObservableObject {
    @Published var isPresentAgreementAlert = false
    @Published var registrationState: LoadingState = .terminated

    func register() async throws {        
        let (data, resp) = try await URLSession.defaultApi.data(for: .makePostUserRegistration())
        
        if (resp as? HTTPURLResponse)?.statusCode == 200, !data.isEmpty {
            registrationState = .completed
        } else {
            registrationState = .failed
        }
    }
}

struct TutorialTerms_Previews: PreviewProvider {
    static var previews: some View {
        TutorialTerms {}
    }
}
