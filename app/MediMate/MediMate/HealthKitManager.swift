// HealthKitManager.swift
// MediMate
//
// Created for Apple HealthKit integration

import Foundation
import HealthKit

class HealthKitManager: ObservableObject {
    private let healthStore = HKHealthStore()
    @Published var allData: [String: String] = [:]


    // Request authorization for all available quantity types
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false)
            return
        }
        var typesToRead: Set<HKObjectType> = Set(allQuantityTypeIdentifiers.compactMap { HKQuantityType.quantityType(forIdentifier: $0) })
        // Add ECG type
        for type in allElectrocardiogramTypeIdentifiers {
            typesToRead.insert(type)
        }
        healthStore.requestAuthorization(toShare: [], read: typesToRead) { success, _ in
            completion(success)
        }
    }

    // Fetch all available quantity types' most recent values, and ECG count
    func fetchAllData() {
        var results: [String: String] = [:]
        let group = DispatchGroup()
        // Quantity types
        for identifier in allQuantityTypeIdentifiers {
            guard let type = HKQuantityType.quantityType(forIdentifier: identifier) else { continue }
            group.enter()
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            let query = HKSampleQuery(sampleType: type, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { [weak self] _, samples, _ in
                defer { group.leave() }
                if let quantitySample = samples?.first as? HKQuantitySample {
                    let unit = self?.unit(for: identifier) ?? HKUnit.count()
                    // Defensive: Only convert if compatible
                    if quantitySample.quantity.is(compatibleWith: unit) {
                        let value = quantitySample.quantity.doubleValue(for: unit)
                        results[identifier.rawValue] = String(format: "%.2f", value)
                    } else {
                        results[identifier.rawValue] = "Incompatible Unit"
                    }
                } else {
                    results[identifier.rawValue] = "No Data"
                }
            }
            healthStore.execute(query)
        }
        // ECG type: count the number of ECG samples
        if let ecgType = allElectrocardiogramTypeIdentifiers.first as? HKElectrocardiogramType {
            group.enter()
            let query = HKSampleQuery(sampleType: ecgType, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, _ in
                let count = samples?.count ?? 0
                results["Electrocardiogram (ECG) Count"] = "\(count)"
                group.leave()
            }
            healthStore.execute(query)
        }
        group.notify(queue: .main) { [weak self] in
            self?.allData = results
        }
    }

    // Helper to get a sensible unit for each type
    private func unit(for identifier: HKQuantityTypeIdentifier) -> HKUnit {
        switch identifier {
        case .stepCount: return HKUnit.count()
        case .distanceWalkingRunning, .distanceCycling: return HKUnit.meter()
        case .activeEnergyBurned, .basalEnergyBurned, .dietaryEnergyConsumed: return HKUnit.kilocalorie()
        case .heartRate, .restingHeartRate, .walkingHeartRateAverage: return HKUnit.count().unitDivided(by: HKUnit.minute())
        case .bodyMass, .leanBodyMass: return HKUnit.gramUnit(with: .kilo)
        case .height: return HKUnit.meter()
        case .bodyFatPercentage: return HKUnit.percent()
        case .bodyMassIndex: return HKUnit.count()
        case .oxygenSaturation: return HKUnit.percent()
        case .respiratoryRate: return HKUnit.count().unitDivided(by: HKUnit.minute())
        case .bloodPressureSystolic, .bloodPressureDiastolic: return HKUnit.millimeterOfMercury()
        case .bloodGlucose: return HKUnit.gramUnit(with: .deci).unitDivided(by: HKUnit.liter())
        case .heartRateVariabilitySDNN: return HKUnit.second()
        default: return HKUnit.count()
        }
    }

}
