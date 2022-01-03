//
//  ExposureCard.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2021/12/31.
//

import SwiftUI

struct ExposureCard: View {
    @ObservedObject private var viewModel = ExposureCardViewModel()
    
    var body: some View {
        ZStack {
            CardBackground()
            VStack(spacing: 32) {
                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    Text("利用開始から")
                    Text(viewModel.progress)
                        .bold()
                        .font(.title)
                    Text("日")
                }
                
                DefaultButton(
                    systemImageName: "person.2.fill",
                    title: "接触結果の確認") {
                        
                    }
            }
            .padding(32)
        }
        .onAppear {
            
        }
    }

}

class ExposureCardViewModel: ObservableObject {
    @Published var progress: String = "0"
    
    
    func updateDate() {
        if let startDate = UserDefaults.standard.object(forKey: "StartDate") as? Date,
           let day = Calendar.current.dateComponents([.day], from: startDate, to: Date()).day {
            progress = "\(day)"
        } else {
            progress = "0"
        }
    }
}

struct ExposureCard_Previews: PreviewProvider {
    static var previews: some View {
        ExposureCard()
    }
}
