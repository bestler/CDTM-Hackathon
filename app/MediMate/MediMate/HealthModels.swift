//
//  HealthModels.swift
//  MediMate
//
//  Created by Simon Bestler on 10.05.25.
//

import Foundation

struct Insurance: Codable {
    let provider: String
    let insuranceNumber: String
}

struct GeneralInformation: Codable {
    let name: String
    let dateOfBirth: String
    let gender: String
    let address: String
    let insurance: Insurance
}

struct Activity: Codable {
    let stepCount: Double?
    let walkingDistance: Double?
    let runningDistance: Double?
    let flightsClimbed: Double?
    let activeEnergyBurned: Double?
    let exerciseMinutes: Double?
    let standHours: Double?
}

struct BodyMeasurements: Codable {
    let height: Double?
    let weight: Double?
    let bodyMassIndex: Double?
    let bodyFatPercentage: Double?
    let leanBodyMass: Double?
    let waistCircumference: Double?
}

struct CycleTracking: Codable {
    let menstrualFlow: String?
    let basalBodyTemperature: Double?
    let ovulationTestResult: String?
    let cervicalMucusQuality: String?
    let sexualActivity: Bool?
}

struct Hearing: Codable {
    let headphoneAudioLevels: Double?
    let environmentalSoundLevels: Double?
    let hearingDeviceAudioLevels: Double?
}

struct Electrocardiogram: Codable {
    let classification: String?
    let averageHeartRate: Double?
    let samplingFrequency: Double?
    let voltageMeasurements: [Double]?
}

struct Heart: Codable {
    let heartRate: Double?
    let restingHeartRate: Double?
    let walkingHeartRateAverage: Double?
    let heartRateVariability: Double?
    let electrocardiogram: Electrocardiogram?
}

struct Medication: Codable {
    let medicationName: String?
    let dosage: String?
    let frequency: String?
    let route: String?
    let startDate: String?
    let endDate: String?
}

struct MentalWellbeing: Codable {
    let mindfulnessMinutes: Double?
    let moodTracking: String?
    let stressLevel: String?
    let anxietyTestResult: String?
    let depressionTestResult: String?
}

struct Mobility: Codable {
    let walkingSpeed: Double?
    let stepLength: Double?
    let doubleSupportTime: Double?
    let walkingAsymmetry: Double?
    let walkingSteadiness: String?
}

struct Nutrition: Codable {
    let calories: Double?
    let carbohydrates: Double?
    let protein: Double?
    let fat: Double?
    let fiber: Double?
    let sugar: Double?
    let sodium: Double?
    let water: Double?
}

struct Respiratory: Codable {
    let respiratoryRate: Double?
    let oxygenSaturation: Double?
    let peakExpiratoryFlowRate: Double?
}

struct SleepStages: Codable {
    let core: Double?
    let deep: Double?
    let rem: Double?
    let awake: Double?
}

struct Sleep: Codable {
    let inBedTime: String?
    let asleepTime: String?
    let sleepDuration: Double?
    let sleepStages: SleepStages?
}

struct Symptoms: Codable {
    let headache: Bool?
    let fatigue: Bool?
    let fever: Bool?
    let chills: Bool?
    let cough: Bool?
    let shortnessOfBreath: Bool?
    let nausea: Bool?
    let diarrhea: Bool?
}

struct BloodPressure: Codable {
    let systolic: Double?
    let diastolic: Double?
}

struct Vitals: Codable {
    let bloodPressure: BloodPressure?
    let bodyTemperature: Double?
    let bloodOxygenSaturation: Double?
    let bloodGlucose: [[String: Double]]?
}

struct OtherData: Codable {
    let handwashingDuration: Double?
    let timeInDaylight: Double?
    let uvExposure: Double?
}

struct AppleHealth: Codable {
    let activity: Activity?
    let bodyMeasurements: BodyMeasurements?
    let cycleTracking: CycleTracking?
    let hearing: Hearing?
    let heart: Heart?
    let medications: [Medication]?
    let mentalWellbeing: MentalWellbeing?
    let mobility: Mobility?
    let nutrition: Nutrition?
    let respiratory: Respiratory?
    let sleep: Sleep?
    let symptoms: Symptoms?
    let vitals: Vitals?
    let otherData: OtherData?
}

// MARK: - Mapping from HealthKitManager to AppleHealth

import HealthKit

extension HealthKitManager {
    func toAppleHealth() -> AppleHealth {
        // This is a basic mapping. You should expand this to map all available HealthKit data.
        let activity = Activity(
            stepCount: allData["HKQuantityTypeIdentifierStepCount"].flatMap { Double($0.components(separatedBy: " ").first ?? "") },
            walkingDistance: allData["HKQuantityTypeIdentifierDistanceWalkingRunning"].flatMap { Double($0.components(separatedBy: " ").first ?? "") },
            runningDistance: nil, // Add mapping if available
            flightsClimbed: nil, // Add mapping if available
            activeEnergyBurned: allData["HKQuantityTypeIdentifierActiveEnergyBurned"].flatMap { Double($0.components(separatedBy: " ").first ?? "") },
            exerciseMinutes: nil, // Add mapping if available
            standHours: nil // Add mapping if available
        )
        let bodyMeasurements = BodyMeasurements(
            height: allData["HKQuantityTypeIdentifierHeight"].flatMap { Double($0.components(separatedBy: " ").first ?? "") },
            weight: allData["HKQuantityTypeIdentifierBodyMass"].flatMap { Double($0.components(separatedBy: " ").first ?? "") },
            bodyMassIndex: allData["HKQuantityTypeIdentifierBodyMassIndex"].flatMap { Double($0.components(separatedBy: " ").first ?? "") },
            bodyFatPercentage: allData["HKQuantityTypeIdentifierBodyFatPercentage"].flatMap { Double($0.components(separatedBy: " ").first ?? "") },
            leanBodyMass: allData["HKQuantityTypeIdentifierLeanBodyMass"].flatMap { Double($0.components(separatedBy: " ").first ?? "") },
            waistCircumference: nil // Add mapping if available
        )
        // Add more mappings as needed for your app
        return AppleHealth(
            activity: activity,
            bodyMeasurements: bodyMeasurements,
            cycleTracking: nil,
            hearing: nil,
            heart: nil,
            medications: nil,
            mentalWellbeing: nil,
            mobility: nil,
            nutrition: nil,
            respiratory: nil,
            sleep: nil,
            symptoms: nil,
            vitals: nil,
            otherData: nil
        )
    }
}
