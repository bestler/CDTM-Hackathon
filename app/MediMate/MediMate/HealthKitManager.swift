// HealthKitManager.swift
// MediMate
//
// Created for Apple HealthKit integration

import Foundation
import HealthKit


// MARK: - HealthKit Type Structs

protocol HealthDataType {
    var type: HKSampleType { get }
    var healthIdentifier: String { get }
    func defaultPredicate() -> NSPredicate?
}

struct QuantityHealthDataType: HealthDataType {
    let identifier: HKQuantityTypeIdentifier
    let unit: HKUnit
    let isCumulative: Bool
    // Adjustable properties
    static var defaultDays: Int = 30
    static var defaultSampling: Calendar.Component = .day // can be .day, .weekOfYear, etc.

    var type: HKSampleType { HKQuantityType.quantityType(forIdentifier: identifier)! }
    var healthIdentifier: String { identifier.rawValue }

    func defaultPredicate() -> NSPredicate? {
        // Default: last N days
        let endDate = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: -Self.defaultDays, to: endDate) ?? endDate
        return HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
    }

    var statisticsOptions: HKStatisticsOptions {
        isCumulative ? .cumulativeSum : .discreteAverage
    }

    // Compute average for cumulative values
    func average(for sum: Double) -> Double {
        guard isCumulative else { return sum }
        return sum / Double(Self.defaultDays)
    }
}

struct ECGHealthDataType: HealthDataType {
    var type: HKSampleType { HKObjectType.electrocardiogramType() }
    var healthIdentifier: String { "Electrocardiogram (ECG)" }
    func defaultPredicate() -> NSPredicate? { nil }
}

// MARK: - HealthKitManager

class HealthKitManager: ObservableObject {

    /// Returns the value to be sent to the API for a given HealthKit identifier key.
    /// For cumulative types, returns the average (using QuantityHealthDataType logic). For discrete, returns the value.
    /// Returns the value to be sent to the API for a given HealthKit identifier key.
    /// For cumulative types, returns the average (using QuantityHealthDataType logic). For discrete, returns the value.
    func valueForAPI(for key: String) -> Double? {
        guard let type = supportedTypes.first(where: { $0.healthIdentifier == key }) as? QuantityHealthDataType else {
            // Not a quantity type or not found
            return nil
        }
        guard let str = allData[key] else { return nil }
        // If the value string contains both sum and avg (e.g., "123.45 (avg: 4.12)"), extract the avg for cumulative
        if type.isCumulative {
            // Try to extract the value inside (avg: ...)
            if let avgRange = str.range(of: "(avg: ") {
                let afterAvg = str[avgRange.upperBound...]
                if let endParen = afterAvg.firstIndex(of: ")") {
                    let avgString = afterAvg[..<endParen].trimmingCharacters(in: .whitespaces)
                    if let avg = Double(avgString) {
                        return avg
                    }
                }
            }
            // Fallback: if only a number is present, use average logic
            let numbers = str.components(separatedBy: " ").compactMap { Double($0) }
            guard let sum = numbers.first else { return nil }
            return type.average(for: sum)
        } else {
            // For discrete, just return the first number
            let numbers = str.components(separatedBy: " ").compactMap { Double($0) }
            return numbers.first
        }
    }
    private let healthStore = HKHealthStore()
    @Published var allData: [String: String] = [:]

    // All supported types as a static property
    static let supportedTypes: [HealthDataType] = [
        // Activity
        QuantityHealthDataType(identifier: .stepCount, unit: .count(), isCumulative: true),
        QuantityHealthDataType(identifier: .distanceWalkingRunning, unit: .meter(), isCumulative: true),
        QuantityHealthDataType(identifier: .distanceCycling, unit: .meter(), isCumulative: true),
        QuantityHealthDataType(identifier: .flightsClimbed, unit: .count(), isCumulative: true),
        QuantityHealthDataType(identifier: .activeEnergyBurned, unit: .kilocalorie(), isCumulative: true),
        QuantityHealthDataType(identifier: .appleExerciseTime, unit: .minute(), isCumulative: true),
        QuantityHealthDataType(identifier: .appleStandTime, unit: .minute(), isCumulative: true),

        // Body Measurements
        QuantityHealthDataType(identifier: .height, unit: .meter(), isCumulative: false),
        QuantityHealthDataType(identifier: .bodyMass, unit: .gramUnit(with: .kilo), isCumulative: false),
        QuantityHealthDataType(identifier: .bodyMassIndex, unit: .count(), isCumulative: false),
        QuantityHealthDataType(identifier: .bodyFatPercentage, unit: .percent(), isCumulative: false),
        QuantityHealthDataType(identifier: .leanBodyMass, unit: .gramUnit(with: .kilo), isCumulative: false),
        QuantityHealthDataType(identifier: .waistCircumference, unit: .meter(), isCumulative: false),

        // Heart
        QuantityHealthDataType(identifier: .heartRate, unit: HKUnit.count().unitDivided(by: .minute()), isCumulative: false),
        QuantityHealthDataType(identifier: .restingHeartRate, unit: HKUnit.count().unitDivided(by: .minute()), isCumulative: false),
        QuantityHealthDataType(identifier: .walkingHeartRateAverage, unit: HKUnit.count().unitDivided(by: .minute()), isCumulative: false),
        QuantityHealthDataType(identifier: .heartRateVariabilitySDNN, unit: .second(), isCumulative: false),

        // Vitals
        QuantityHealthDataType(identifier: .bloodPressureSystolic, unit: .millimeterOfMercury(), isCumulative: false),
        QuantityHealthDataType(identifier: .bloodPressureDiastolic, unit: .millimeterOfMercury(), isCumulative: false),
        QuantityHealthDataType(identifier: .bodyTemperature, unit: .degreeCelsius(), isCumulative: false),
        QuantityHealthDataType(identifier: .oxygenSaturation, unit: .percent(), isCumulative: false),
        QuantityHealthDataType(identifier: .bloodGlucose, unit: HKUnit.gramUnit(with: .deci).unitDivided(by: .liter()), isCumulative: false),

        // Respiratory
        QuantityHealthDataType(identifier: .respiratoryRate, unit: HKUnit.count().unitDivided(by: .minute()), isCumulative: false),
        QuantityHealthDataType(identifier: .peakExpiratoryFlowRate, unit: .liter().unitDivided(by: .minute()), isCumulative: false),

        // Nutrition
        QuantityHealthDataType(identifier: .dietaryEnergyConsumed, unit: .kilocalorie(), isCumulative: true),
        QuantityHealthDataType(identifier: .dietaryCarbohydrates, unit: .gram(), isCumulative: true),
        QuantityHealthDataType(identifier: .dietaryProtein, unit: .gram(), isCumulative: true),
        QuantityHealthDataType(identifier: .dietaryFatTotal, unit: .gram(), isCumulative: true),
        QuantityHealthDataType(identifier: .dietaryFiber, unit: .gram(), isCumulative: true),
        QuantityHealthDataType(identifier: .dietarySugar, unit: .gram(), isCumulative: true),
        QuantityHealthDataType(identifier: .dietarySodium, unit: .gram(), isCumulative: true),
        QuantityHealthDataType(identifier: .dietaryWater, unit: .liter(), isCumulative: true),

        // OtherData (if available in HealthKit)
        QuantityHealthDataType(identifier: .uvExposure, unit: .count(), isCumulative: false),
        QuantityHealthDataType(identifier: .timeInDaylight, unit: .minute(), isCumulative: true),
        //QuantityHealthDataType(identifier: .handwashingEventDuration, unit: .second(), isCumulative: true),

        // ECG
        ECGHealthDataType()
    ]

    // Instance property for convenience (optional, can be removed if not needed)
    let supportedTypes: [HealthDataType] = HealthKitManager.supportedTypes

    // Request authorization for all supported types
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false)
            return
        }
        let typesToRead: Set<HKObjectType> = Set(supportedTypes.map { $0.type })
        healthStore.requestAuthorization(toShare: [], read: typesToRead) { success, _ in
            completion(success)
        }
    }

    // Fetch all data using HKStatisticsQuery for quantity types, and count for ECG
    func fetchAllData() {
        var results: [String: String] = [:]
        let group = DispatchGroup()
        for type in supportedTypes {
            if let quantityType = type as? QuantityHealthDataType, let hkType = quantityType.type as? HKQuantityType {
                group.enter()
                let predicate = quantityType.defaultPredicate()
                let options = quantityType.statisticsOptions
                let query = HKStatisticsQuery(quantityType: hkType, quantitySamplePredicate: predicate, options: options) { _, statistics, _ in
                    defer { group.leave() }
                    var valueString = "No Data"
                    if quantityType.isCumulative {
                        if let sum = statistics?.sumQuantity(), sum.is(compatibleWith: quantityType.unit) {
                            let sumValue = sum.doubleValue(for: quantityType.unit)
                            let avgValue = quantityType.average(for: sumValue)
                            valueString = String(format: "%.2f (avg: %.2f)", sumValue, avgValue)
                        } else if statistics?.sumQuantity() != nil {
                            valueString = "Incompatible Unit"
                        }
                    } else {
                        if let avg = statistics?.averageQuantity(), avg.is(compatibleWith: quantityType.unit) {
                            let value = avg.doubleValue(for: quantityType.unit)
                            valueString = String(format: "%.2f", value)
                        } else if statistics?.averageQuantity() != nil {
                            valueString = "Incompatible Unit"
                        }
                    }
                    results[quantityType.healthIdentifier] = valueString
                }
                healthStore.execute(query)
        // Print all averages to the console
        group.notify(queue: .main) { [weak self] in
            self?.allData = results
            print("--- HealthKit 30-day Averages/Sums ---")
            for (key, value) in results.sorted(by: { $0.key < $1.key }) {
                print("\(key): \(value)")
            }
        }
            } else if type is ECGHealthDataType, let ecgType = type.type as? HKElectrocardiogramType {
                group.enter()
                let predicate = type.defaultPredicate()
                let query = HKSampleQuery(sampleType: ecgType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, _ in
                    let count = samples?.count ?? 0
                    results[type.healthIdentifier] = "\(count)"
                    group.leave()
                }
                healthStore.execute(query)
            }
        }
        group.notify(queue: .main) { [weak self] in
            self?.allData = results
        }
    }
}

