import SwiftUI

struct OnboardingFlowView: View {
    @StateObject var flowViewModel = OnboardingFlowViewModel()
    
    var body: some View {
        VStack {
            Text(flowViewModel.currentStep.title)
                .font(.title)
                .padding(.top)
            
            // Step content
            Group {
                if let healthKitVM = flowViewModel.currentStep as? HealthKitStepViewModel {
                    HealthKitStepView(viewModel: healthKitVM)
                } else if let reviewVM = flowViewModel.currentStep as? VaccinationReviewViewModel {
                    VaccinationReviewView(viewModel: reviewVM)
                } else {
                    Text("Unknown step")
                }
            }
            .padding()
            
            HStack {
                if flowViewModel.currentStepIndex > 0 {
                    Button("Back") {
                        flowViewModel.previousStep()
                    }
                }
                Spacer()
                Button(flowViewModel.isLastStep ? "Finish" : "Next") {
                    flowViewModel.currentStep.onNext { success in
                        if success {
                            if flowViewModel.isLastStep {
                                // Handle finish
                            } else {
                                flowViewModel.nextStep()
                            }
                        }
                    }
                }
                .disabled(!flowViewModel.currentStep.isComplete)
            }
            .padding()
        }
    }
}
