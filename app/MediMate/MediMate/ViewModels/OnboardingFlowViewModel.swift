import Foundation
import SwiftUI

protocol FlowStepViewModel: ObservableObject {
    var isStaticVideo: Bool { get }
    var title: String { get }
    var isComplete: Bool { get }
    var videoName: String { get }
    func onNext(completion: @escaping (Bool) -> Void)
    func handleSave() 
}

class OnboardingFlowViewModel: ObservableObject {
    @Published var currentStepIndex: Int = 0
    @Published var steps: [any FlowStepViewModel]
    
    // Collected data from steps
    @Published var vaccination: Vaccination? = nil
    @Published var generalInfo: GeneralInformation? = nil
    // Add more data as needed

    init() {
        // Initialize steps
        let generalInfoVM = GeneralInformationViewModel()
        let healthKitVM = HealthKitStepViewModel()
        let vaccination = VaccinationReviewViewModel()
        let conversationVM = ConversationViewModel()
        self.steps = [generalInfoVM, healthKitVM, vaccination, conversationVM]
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
