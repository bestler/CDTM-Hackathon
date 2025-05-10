import Foundation

struct VaccinationResponse: Codable {
    let message: String
    let data: [Vaccination]
}

struct Vaccination: Codable, Equatable {
    let name: String
    let doctor: String
    let date: String
}
