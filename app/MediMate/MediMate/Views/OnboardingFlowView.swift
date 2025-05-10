import SwiftUI

struct OnboardingFlowView: View {
    @StateObject var flowViewModel = OnboardingFlowViewModel()
    
    private var progressPercentage: CGFloat {
        let totalSteps = flowViewModel.steps.count
        let currentStep = flowViewModel.currentStepIndex + 1
        return CGFloat(currentStep) / CGFloat(totalSteps)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Top progress bar section - "Vaccination" with progress bar
            VStack(alignment: .leading) {
                Text("MediMate")
                    .font(.title2)
                    .fontWeight(.bold)
                
                HStack(spacing: 10) {
                    Text(flowViewModel.steps[flowViewModel.currentStepIndex].title)
                        .font(.headline)
                    
                    // Progress bar
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .foregroundColor(.gray.opacity(0.3))
                                .cornerRadius(5)
                            
                            Rectangle()
                                .foregroundColor(.blue)
                                .cornerRadius(5)
                                .frame(width: geometry.size.width * progressPercentage)
                        }
                    }
                    .frame(height: 10)
                }
            }
            .padding()
            .background(Color.white)
            .shadow(radius: 1)
            
            // Step title
            Text(flowViewModel.currentStep.title)
                .font(.title)
                .padding(.top)
            
            ScrollView {
                // Placeholder for Avatar - now shown on all screens
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                            .foregroundColor(.gray)
                            .frame(height: 150)
                            .padding()
                        
                        Image(systemName: "person")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.gray)
                    }
                    
                    Text("Placeholder for Avatar")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding()
                
                // Step content
                Group {
                    if let healthKitVM = flowViewModel.currentStep as? HealthKitStepViewModel {
                        HealthKitStepView(viewModel: healthKitVM)
                    } else if let scanDocVM = flowViewModel.currentStep as? ScanDocumentViewModel {
                        ScanDocumentView(viewModel: scanDocVM)
                    } else if let reviewVM = flowViewModel.currentStep as? VaccinationReviewViewModel {
                        VaccinationReviewView(viewModel: reviewVM)
                    } else if let conversationVM = flowViewModel.currentStep as? ConversationViewModel {
                        ConversationView(viewModel: conversationVM)
                    } else {
                        Text("Unknown step")
                    }
                }
                .padding()
            }
            
            Spacer()
            
            // Navigation buttons
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
                .buttonStyle(.borderedProminent)
                .disabled(!flowViewModel.currentStep.isComplete)
            }
            .padding()
        }
    }
}
