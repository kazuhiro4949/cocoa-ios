//
//  Tutorial.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2022/01/03.
//

import SwiftUI
import Combine

enum TutorialStep {
    enum FinishedDestination {
        case home
        case usage
    }
    
    case howToUse
    case aboutPrivacy
    case terms
    case privacyPolicy
    case enableEN
    case thanks
    case finished(FinishedDestination)
}


struct Tutorial: View {
    var dismiss: (TutorialStep.FinishedDestination) -> Void
    @ObservedObject private var viewModel = TutorialViewModel()
    
    var body: some View {
        Group {
            if case .howToUse = viewModel.step {
                TutorialHowToUse(step: $viewModel.step)
            } else if case .aboutPrivacy = viewModel.step {
                TutorialAboutProvicy(step: $viewModel.step)
            } else if case .terms = viewModel.step {
                TutorialTerms(step: $viewModel.step)
            } else if case .privacyPolicy = viewModel.step {
                TutorialPrivacyPolicy(step: $viewModel.step)
            } else if case .enableEN = viewModel.step {
                TutorialEnableEN(step: $viewModel.step)
            } else {
                TutorialThanks(step: $viewModel.step)
            }
        }
        .onAppear {
            viewModel.setDismissHandler(dismiss)
        }
    }
}

class TutorialViewModel: ObservableObject {
    @Published var step: TutorialStep = .howToUse
    
    private var cancelables = Set<AnyCancellable>()
    
    func setDismissHandler(_ dismissHandler: @escaping (TutorialStep.FinishedDestination) -> Void) {
        $step.eraseToAnyPublisher()
            .sink { step in
                if case .finished(let destination) = step {
                    dismissHandler(destination)
                }
            }
            .store(in: &cancelables)
    }
}

struct Tutorial_Previews: PreviewProvider {
    static var previews: some View {
        Tutorial {_ in }
    }
}
