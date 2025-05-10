import Foundation
import SwiftUI

class VaccinationReviewViewModel: ObservableObject, FlowStepViewModel {
    @Published var vaccineName: String = ""
    @Published var date: String = ""
    @Published var lotNumber: String = ""
    var title: String { "Review Vaccination" }
    var isComplete: Bool { !vaccineName.isEmpty && !date.isEmpty }
    
    func prefill(with vaccination: Vaccination?) {
        guard let v = vaccination else { return }
        self.vaccineName = v.vaccineName
        self.date = v.date
        self.lotNumber = v.lotNumber
    }
    
    func onNext(completion: @escaping (Bool) -> Void) {
        completion(isComplete)
    }
}
