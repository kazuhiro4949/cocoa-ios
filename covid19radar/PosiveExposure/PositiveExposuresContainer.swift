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
            Task {
              try await viewModel.fetch()
            }
            
        }
        .navigationBarTitle("過去14日間の接触")
    }
}

class PositiveExposuresContainerViewModel: ObservableObject {
    @Published var positiveExposures = [PositiveExposures]()
    
    func fetch() async throws {
        
    }
}

struct PositiveExposures {
    
}

struct PositiveExposuresContainer_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PositiveExposuresContainer()
        }
    }
}
