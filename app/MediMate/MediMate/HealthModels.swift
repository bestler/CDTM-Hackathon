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
        // Helper to extract Double from allData
        func extract(_ key: String) -> Double? {
            // Use the new centralized logic from HealthKitManager
            return valueForAPI(for: key)
        }

        let activity = Activity(
            stepCount: extract("HKQuantityTypeIdentifierStepCount"),
            walkingDistance: extract("HKQuantityTypeIdentifierDistanceWalkingRunning"),
            runningDistance: extract("HKQuantityTypeIdentifierDistanceCycling"),
            flightsClimbed: extract("HKQuantityTypeIdentifierFlightsClimbed"),
            activeEnergyBurned: extract("HKQuantityTypeIdentifierActiveEnergyBurned"),
            exerciseMinutes: extract("HKQuantityTypeIdentifierAppleExerciseTime"),
            standHours: extract("HKQuantityTypeIdentifierAppleStandTime")
        )

        let bodyMeasurements = BodyMeasurements(
            height: extract("HKQuantityTypeIdentifierHeight"),
            weight: extract("HKQuantityTypeIdentifierBodyMass"),
            bodyMassIndex: extract("HKQuantityTypeIdentifierBodyMassIndex"),
            bodyFatPercentage: extract("HKQuantityTypeIdentifierBodyFatPercentage"),
            leanBodyMass: extract("HKQuantityTypeIdentifierLeanBodyMass"),
            waistCircumference: extract("HKQuantityTypeIdentifierWaistCircumference")
        )

        let heart = Heart(
            heartRate: extract("HKQuantityTypeIdentifierHeartRate"),
            restingHeartRate: extract("HKQuantityTypeIdentifierRestingHeartRate"),
            walkingHeartRateAverage: extract("HKQuantityTypeIdentifierWalkingHeartRateAverage"),
            heartRateVariability: extract("HKQuantityTypeIdentifierHeartRateVariabilitySDNN"),
            electrocardiogram: nil // Could be filled with more advanced queries
        )

        let vitals = Vitals(
            bloodPressure: {
                let sys = extract("HKQuantityTypeIdentifierBloodPressureSystolic")
                let dia = extract("HKQuantityTypeIdentifierBloodPressureDiastolic")
                if sys != nil || dia != nil {
                    return BloodPressure(systolic: sys, diastolic: dia)
                } else {
                    return nil
                }
            }(),
            bodyTemperature: extract("HKQuantityTypeIdentifierBodyTemperature"),
            bloodOxygenSaturation: extract("HKQuantityTypeIdentifierOxygenSaturation"),
            bloodGlucose: nil // Needs custom parsing if available
        )

        let respiratory = Respiratory(
            respiratoryRate: extract("HKQuantityTypeIdentifierRespiratoryRate"),
            oxygenSaturation: extract("HKQuantityTypeIdentifierOxygenSaturation"),
            peakExpiratoryFlowRate: extract("HKQuantityTypeIdentifierPeakExpiratoryFlowRate")
        )

        let nutrition = Nutrition(
            calories: extract("HKQuantityTypeIdentifierDietaryEnergyConsumed"),
            carbohydrates: extract("HKQuantityTypeIdentifierDietaryCarbohydrates"),
            protein: extract("HKQuantityTypeIdentifierDietaryProtein"),
            fat: extract("HKQuantityTypeIdentifierDietaryFatTotal"),
            fiber: extract("HKQuantityTypeIdentifierDietaryFiber"),
            sugar: extract("HKQuantityTypeIdentifierDietarySugar"),
            sodium: extract("HKQuantityTypeIdentifierDietarySodium"),
            water: extract("HKQuantityTypeIdentifierDietaryWater")
        )

        // OtherData
        let otherData = OtherData(
            handwashingDuration: extract("HKQuantityTypeIdentifierHandwashingEventDuration"),
            timeInDaylight: extract("HKQuantityTypeIdentifierTimeInDaylight"),
            uvExposure: extract("HKQuantityTypeIdentifierUVExposure")
        )

        return AppleHealth(
            activity: activity,
            bodyMeasurements: bodyMeasurements,
            cycleTracking: nil,
            hearing: nil,
            heart: heart,
            medications: nil,
            mentalWellbeing: nil,
            mobility: nil,
            nutrition: nutrition,
            respiratory: respiratory,
            sleep: nil,
            symptoms: nil,
            vitals: vitals,
            otherData: otherData
        )
    }
}
