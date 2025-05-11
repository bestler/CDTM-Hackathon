import SwiftUI
import AVKit

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

            /*
            // Step title
            Text(flowViewModel.currentStep.title)
                .font(.title)
                .padding(.top)
             */

            ScrollView {
                // Video player with key to force refresh when currentStepIndex changes
                if let videoURL = Bundle.main.url(forResource: flowViewModel.currentStep.videoName, withExtension: "mov"), flowViewModel.steps[flowViewModel.currentStepIndex].isStaticVideo == true {
                    VideoPlayerView(url: videoURL)
                        .frame(height: 180)
                        .cornerRadius(10)
                        .padding()
                        .id(flowViewModel.currentStepIndex) // Force view recreation when step changes
                } else {
                    AvatarView()
                        .frame(height: 500)
                        .cornerRadius(10)
                        .padding()
                    .id(flowViewModel.currentStepIndex) 
                }

                // Step content
                Group {
                    if let healthKitVM = flowViewModel.currentStep as? HealthKitStepViewModel {
                        HealthKitStepView(viewModel: healthKitVM)
                    } else if let generalInfoVM = flowViewModel.currentStep as? GeneralInformationViewModel {
                        GeneralInformationView(viewModel: generalInfoVM)
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
                                print("Setting showSubmissionSuccess to true") // Debugging log
                                flowViewModel.showSubmissionSuccess = true
                            } else {
                                flowViewModel.nextStep()
                            }
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(!flowViewModel.currentStep.isComplete)
                .fullScreenCover(isPresented: $flowViewModel.showSubmissionSuccess) {
                    SubmissionSuccessView()
                }
            }
            .padding()
        }
    }
}
