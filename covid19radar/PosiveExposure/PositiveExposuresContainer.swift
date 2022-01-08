//
//  PositiveExposureContainer.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2022/01/08.
//

import SwiftUI

struct PositiveExposuresContainer: View {
    @ObservedObject var viewModel = PositiveExposuresContainerViewModel()
    
    var body: some View {
        ZStack {
            if viewModel.positiveExposures.isEmpty {
                NoPositiveExposure()
            } else {
                SomePositiveExposures()
            }
        }
        .onAppear {
            do {
              try viewModel.fetch()
            } catch {}
        }
        .navigationBarTitle("過去14日間の接触")
    }
}

class PositiveExposuresContainerViewModel: ObservableObject {
    @Published var positiveExposures = [PositiveExposures]()
    
    func fetch() throws  {
        guard let data = UserDefaults.standard.data(forKey: "ENExposureWindow") else {
            return
        }
        
        let exposureWindows = try JSONDecoder().decode([ExposureWindow].self, from: data)
        let rawPositiveExposures = exposureWindows.reduce(into: [String: Int]()) { partialResult, window in
            let dateString = DateFormatter.dateLabel.string(from: window.date)
            partialResult[dateString] = (partialResult[dateString] ?? 0) + 1
        }
        positiveExposures = rawPositiveExposures
            .map({ PositiveExposures(dateString: $0, count: "\($1)") })
    }
}

struct PositiveExposures {
    let dateString: String
    let count: String
}

struct PositiveExposuresContainer_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PositiveExposuresContainer()
        }
    }
}
