import Foundation

struct Vaccination: Codable, Equatable {
    var vaccineName: String
    var date: String
    var lotNumber: String
    // Add more fields as needed
}

extension Vaccination {
    static var example: Vaccination {
        Vaccination(vaccineName: "COVID-19", date: "2024-05-01", lotNumber: "12345")
    }
}
