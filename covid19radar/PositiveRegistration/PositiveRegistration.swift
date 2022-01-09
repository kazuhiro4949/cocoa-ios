//
//  PositiveRegistration.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2021/12/31.
//

import SwiftUI
import Combine

enum Symptom: Int, CaseIterable, Hashable, Identifiable {
    case yes
    case no
    case unknown
    
    var label: String {
        switch self {
        case .yes:
            return "症状はあります"
        case .no:
            return "症状はありません"
        case .unknown:
            return "未選択"
        }
    }
    
    var id: Int {
        self.rawValue
    }
}

struct PositiveRegistration: View {
    @State var isPresentedSuccessAlert = false
    @ObservedObject var viewModel = PositiveRegistrationViewModel()
    
    var body: some View {
        Form {
            Section {
                Picker("選択してください", selection: $viewModel.sympotom) {
                    ForEach(Symptom.allCases) {
                        Text($0.label).tag($0)
                    }
                }
            } header: {
                VStack(alignment: .leading, spacing: 8) {
                    Text("次のような症状はありますか？")
                    Text("発熱、咳、呼吸困難、全身倦怠感、咽頭痛、鼻汁・鼻閉、頭痛、関節・筋肉痛、下痢、嘔気・嘔吐など")
                }
            }
            
            if viewModel.sympotom != .unknown {
                Section {
                    DatePicker("選択してください", selection: $viewModel.date, displayedComponents: .date)
                } header: {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("症状が始まった最初の日を入力してください")
                        Text("覚えている範囲で一番古い日付を入力してください。入力した日付が誰かに知られることはありません")
                    }
                }
            }
            
            Section {
                TextField("8桁の処理番号を入力してください", text: $viewModel.processNumber)
                    .keyboardType(.numberPad)
                    .onReceive(Just(viewModel.processNumber)) { value in
                        if 8 < value.count {
                            viewModel.processNumber = String(value.prefix(8))
                        }
                    }
            } header: {
                VStack(alignment: .leading, spacing: 8) {
                    Text("SMS（※）またはメールで届いた処理番号を入力してください")
                    Text("※スマートフォン用のテキストでの連絡手段。ショートメッセージ")
                }
            }
            
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text("登録すると")
                        .bold()
                    Text("症状が始まった日または検査を受けた日の2日前以降にあなたと接触した人に通知が行きます")
                    Text("""
                         ※登録は匿名で行われ、氏名や連絡先など個人が特定される情報が他の人に知られることはありません
                         ※接触した場所がどこなのか記録されたり、他の人に知られることもありません
                        """)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
            } header: {
                
            }
            
            PositiveRegistrationButton($viewModel.isEnabled) {
                HStack(alignment: .center) {
                    Spacer()
                    Image(systemName: "plus.square.fill")
                    Text("登録する")
                    Spacer()
                }
            } action: {
                Task {
                    do {
                        try await viewModel.send()
                        isPresentedSuccessAlert = true
                    } catch {
                        print(error)
                        // TODO: Error handling
                    }
                }
            }
            .alert(isPresented: $isPresentedSuccessAlert) {
                Alert(
                    title: Text("確認"),
                    message: Text("登録が完了しました"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .navigationBarTitle("陽性情報の登録")
    }
}


/// Back Compatibility for ios 13
private struct PositiveRegistrationButton<Content : View>: View {
    private var content : Content
    private let action: () -> Void
    @Binding var isEnabled: Bool
    
    init(_ isEnabled: Binding<Bool>, @ViewBuilder content: () -> Content, action: @escaping () -> Void) {
        self._isEnabled = isEnabled
        self.content = content()
        self.action = action
    }
    
    // TODO: - Enable
    var body: some View {
        if #available(iOS 14.0, *) {
            Section {
                Button {
                    action()
                } label: {
                    content
                        .foregroundColor(.white)
                }
                .disabled(!isEnabled)
            } header: {
                
            }
            .listRowBackground(isEnabled ? Color.blue : Color(white: 0.9))
        } else {
            Section {
                Button {
                    action()
                } label: {
                    content
                        .foregroundColor(isEnabled ? .blue : .gray)
                }
                .disabled(!isEnabled)
            } header: {
                
            }
            .listRowBackground(isEnabled ? Color.white : Color(white: 0.9))
        }
    }
}

// MARK: - ViewModel
class PositiveRegistrationViewModel: ObservableObject {
    private var processNumberRegex = try! NSRegularExpression(pattern: "\\A[0-9]{8}\\z", options: [])
    
    @Published var isEnabled = false
    
    @Published var sympotom: Symptom = .unknown {
        didSet {
            isEnabled = validate(processNumber)
        }
    }
    
    @Published var processNumber: String = "" {
        didSet {
            isEnabled = validate(processNumber)
        }
    }
    
    @Published var date: Date = Date() {
        didSet {
            isEnabled = validate(processNumber)
        }
    }
    
    private var cancellable = Set<AnyCancellable>()
    
    func validate(_ processNumber: String) -> Bool {
        let matches = processNumberRegex.matches(
            in: processNumber,
            options: .anchored,
            range: NSRange(location: 0, length: (processNumber as NSString).length))
        
        return (sympotom != .unknown && matches.count == 1)
    }
    
    // TODO: - Refactor
    func send() async throws {
        let teks = try await ExposureManager.shared.getDiagnosisKeys()
        guard let teks = teks else {
            throw AppErorr.general
        }
        
        let startDate = Calendar.current.date(byAdding: .day, value: -15, to: date)
        guard let startDate = startDate else {
            throw AppErorr.general
        }
        
        let enInterval = startDate.enInterval
        let validTeks = teks.filter { enInterval <= $0.rollingStartNumber }
        guard !validTeks.isEmpty else {
            throw AppErorr.general
        }
        
        let submissionKeys = validTeks.map { key in
            DiagnosisSubmission.Key(
                keyData: key.keyData.base64EncodedString(),
                rollingStartNumber: UInt(key.rollingStartNumber),
                rollingPeriod: UInt(key.rollingPeriod),
                reportType: UInt(ReportType.confirmedTest.rawValue)
            )
        }
        
        let submission = DiagnosisSubmission(
            symptomOnsetDate: DateFormatter.timeStamp.string(from: date),
            keys: submissionKeys,
            regions: ["440"],
            platform: "ios",
            deviceVerificationPayload: "DUMMY RESPONSE",
            appPackageName: "jp.go.mhlw.covid19radar",
            verificationPayload: processNumber,
            idempotency_key: UUID().uuidString,
            padding: [UInt8].padding
        )
        
        let request = try URLRequest.makeDiagnosisSubmission(submission)
        let (_, resp) = try await URLSession.defaultApi.data(for: request)
        guard let httpResp = resp as? HTTPURLResponse,
                httpResp.statusCode == 200 else {
            throw AppErorr.general
        }
        
        return
    }
}

struct PositiveRegistration_Previews: PreviewProvider {
    static var previews: some View {
        PositiveRegistration()
    }
}
