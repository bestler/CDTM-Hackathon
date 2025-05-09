// HealthKitTypes.swift
// Helper for all available HealthKit quantity types
import HealthKit

let allQuantityTypeIdentifiers: [HKQuantityTypeIdentifier] = [
    .stepCount,
    .distanceWalkingRunning,
    .distanceCycling,
    .activeEnergyBurned,
    .basalEnergyBurned,
    .heartRate,
    .bodyMass,
    .height,
    .bodyFatPercentage,
    .bodyMassIndex,
    .leanBodyMass,
    .restingHeartRate,
    .walkingHeartRateAverage,
    .heartRateVariabilitySDNN,
    .oxygenSaturation,
    .respiratoryRate,
    .bloodPressureSystolic,
    .bloodPressureDiastolic,
    .bloodGlucose,
    .dietaryEnergyConsumed,
]

// ECG is not a quantity type, but an HKSampleType
let allElectrocardiogramTypeIdentifiers: [HKSampleType] = [
    HKObjectType.electrocardiogramType()
]
