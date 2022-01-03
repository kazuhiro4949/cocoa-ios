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
                    } label: {
                        HStack(spacing: 4) {
                            Text("接触有無の最終確認日時")
                                .foregroundColor(.primary)
                            Image(systemName: "questionmark.circle")
                        }
                        .font(.system(.caption))
                        .padding(.leading, 16)
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
    
    private var observers = [NSObjectProtocol]()
    
    init() {
        observers.append(NotificationCenter.default.addObserver(
            forName: ExposureManager.exposureNotificationStatusChanged,
            object: ExposureManager.shared,
            queue: .main) { [weak self] notification in
                self?.status = ExposureManager.shared.helthCheck
            })
        
    }
}

struct HelthCheckBoard_Previews: PreviewProvider {
    static var previews: some View {
        HelthCheckBoard(value: .constant(true))
    }
}
