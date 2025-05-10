import Foundation
import SwiftUI

protocol FlowStepViewModel: ObservableObject {
    var title: String { get }
    var isComplete: Bool { get }
    func onNext(completion: @escaping (Bool) -> Void)
}

class OnboardingFlowViewModel: ObservableObject {
    @Published var currentStepIndex: Int = 0
    @Published var steps: [any FlowStepViewModel]
    
    // Collected data from steps
    @Published var vaccination: Vaccination? = nil
    // Add more data as needed

    init() {
        // Initialize steps
        let healthKitVM = HealthKitStepViewModel()
        let scanVM = ScanDocumentViewModel()
        let reviewVM = VaccinationReviewViewModel()
        self.steps = [healthKitVM, scanVM, reviewVM]
        // Pass data between steps as needed
        scanVM.onScanCompleted = { [weak self, weak reviewVM] vaccination in
            self?.vaccination = vaccination
            reviewVM?.prefill(with: vaccination)
        }
    }

    var currentStep: any FlowStepViewModel {
        steps[currentStepIndex]
    }

    func nextStep() {
        if currentStepIndex < steps.count - 1 {
            currentStepIndex += 1
        }
    }
    
    func previousStep() {
        if currentStepIndex > 0 {
            currentStepIndex -= 1
        }
    }
    
    var isLastStep: Bool {
        currentStepIndex == steps.count - 1
    }
}
