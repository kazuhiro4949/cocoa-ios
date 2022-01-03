//
//  HelthCheckBoard.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2021/12/31.
//

import SwiftUI
import ExposureNotification

struct HelthCheckBoard: View {
    @Binding var value: Bool
    @ObservedObject private var viewModel = HelthCheckBoardViewModel()
    
    @State private var isPresentAboutLastDate = false
    
    var body: some View {
        VStack(spacing: 32) {
            if case .active = viewModel.status {
                HelthCheckActive(value: $value)
            } else if case .unauthorized = viewModel.status {
                HelthCheckUnauthorized()
            } else if case .needsConfirm = viewModel.status {
                HelthCheckNeedsConfirm()
            } else {
                EmptyView()
            }
            
            VStack(spacing: 8) {
                HStack {
                    Button {
                        isPresentAboutLastDate = true
                    } label: {
                        HStack(spacing: 4) {
                            Text("接触有無の最終確認日時")
                                .foregroundColor(.primary)
                            Image(systemName: "questionmark.circle")
                        }
                        .font(.system(.caption))
                        .padding(.leading, 16)
                    }
                    .alert(isPresented: $isPresentAboutLastDate) {
                        Alert(
                            title: Text("確認"),
                            message: Text("ホーム画面に「接触有無を確認できません」と表示された場合は、以下をお試しください。"),
                            dismissButton: .default(Text("OK")))
                    }
                }
                Text("取得中")
                    .font(.system(.caption))
            }

        }
    }
}

class HelthCheckBoardViewModel: ObservableObject {
    @Published var status: HelthCheck = .unauthorized
    @Published var progressString: String = "0"
    
    private var observers = [NSObjectProtocol]()
    
    init() {
        observers.append(NotificationCenter.default.addObserver(
            forName: ExposureManager.exposureNotificationStatusChanged,
            object: ExposureManager.shared,
            queue: .main) { [weak self] notification in
                self?.status = ExposureManager.shared.helthCheck
            })
    }
    
    func updateProgress() {
        if let startDate = UserDefaults.standard.object(forKey: "StartDate") as? Date,
           let day = Calendar.current.dateComponents([.day], from: startDate, to: Date()).day {
            progressString = "\(day)"
        } else {
            progressString = "0"
        }
    }
}

struct HelthCheckBoard_Previews: PreviewProvider {
    static var previews: some View {
        HelthCheckBoard(value: .constant(true))
    }
}
