from pydantic import BaseModel
from typing import Dict, Any

class Insurance(BaseModel):
    provider: str
    insuranceNumber: str

class GeneralInformation(BaseModel):
    name: str
    dateOfBirth: str
    gender: str
    address: str
    insurance: Insurance

class Activity(BaseModel):
    stepCount: float | None = None
    walkingDistance: float | None = None
    runningDistance: float | None = None
    flightsClimbed: float | None = None
    activeEnergyBurned: float | None = None
    exerciseMinutes: float | None = None
    standHours: float | None = None

class BodyMeasurements(BaseModel):
    height: float | None = None
    weight: float | None = None
    bodyMassIndex: float | None = None
    bodyFatPercentage: float | None = None
    leanBodyMass: float | None = None
    waistCircumference: float | None = None

class CycleTracking(BaseModel):
    menstrualFlow: str | None = None
    basalBodyTemperature: float | None = None
    ovulationTestResult: str | None = None
    cervicalMucusQuality: str | None = None
    sexualActivity: bool | None = None

class Hearing(BaseModel):
    headphoneAudioLevels: float | None = None
    environmentalSoundLevels: float | None = None
    hearingDeviceAudioLevels: float | None = None

class Electrocardiogram(BaseModel):
    classification: str | None = None
    averageHeartRate: float | None = None
    samplingFrequency: float | None = None
    voltageMeasurements: list[float] | None = None

class Heart(BaseModel):
    heartRate: float | None = None
    restingHeartRate: float | None = None
    walkingHeartRateAverage: float | None = None
    heartRateVariability: float | None = None
    electrocardiogram: Electrocardiogram | None = None

class Medication(BaseModel):
    medicationName: str | None = None
    dosage: str | None = None
    frequency: str | None = None
    route: str | None = None
    startDate: str | None = None
    endDate: str | None = None

class MentalWellbeing(BaseModel):
    mindfulnessMinutes: float | None = None
    moodTracking: str | None = None
    stressLevel: str | None = None
    anxietyTestResult: str | None = None
    depressionTestResult: str | None = None

class Mobility(BaseModel):
    walkingSpeed: float | None = None
    stepLength: float | None = None
    doubleSupportTime: float | None = None
    walkingAsymmetry: float | None = None
    walkingSteadiness: str | None = None

class Nutrition(BaseModel):
    calories: float | None = None
    carbohydrates: float | None = None
    protein: float | None = None
    fat: float | None = None
    fiber: float | None = None
    sugar: float | None = None
    sodium: float | None = None
    water: float | None = None

class Respiratory(BaseModel):
    respiratoryRate: float | None = None
    oxygenSaturation: float | None = None
    peakExpiratoryFlowRate: float | None = None

class SleepStages(BaseModel):
    core: float | None = None
    deep: float | None = None
    rem: float | None = None
    awake: float | None = None

class Sleep(BaseModel):
    inBedTime: str | None = None
    asleepTime: str | None = None
    sleepDuration: float | None = None
    sleepStages: SleepStages | None = None

class Symptoms(BaseModel):
    headache: bool | None = None
    fatigue: bool | None = None
    fever: bool | None = None
    chills: bool | None = None
    cough: bool | None = None
    shortnessOfBreath: bool | None = None
    nausea: bool | None = None
    diarrhea: bool | None = None

class BloodPressure(BaseModel):
    systolic: float | None = None
    diastolic: float | None = None

class Vitals(BaseModel):
    bloodPressure: BloodPressure | None = None
    bodyTemperature: float | None = None
    bloodOxygenSaturation: float | None = None
    bloodGlucose: list[Dict[str, float]] | None = None

class OtherData(BaseModel):
    handwashingDuration: float | None = None
    timeInDaylight: float | None = None
    uvExposure: float | None = None

class AppleHealth(BaseModel):
    activity: Activity | None = None
    bodyMeasurements: BodyMeasurements | None = None
    cycleTracking: CycleTracking | None = None
    hearing: Hearing | None = None
    heart: Heart | None = None
    medications: list[Medication] | None = None
    mentalWellbeing: MentalWellbeing | None = None
    mobility: Mobility | None = None
    nutrition: Nutrition | None = None
    respiratory: Respiratory | None = None
    sleep: Sleep | None = None
    symptoms: Symptoms | None = None
    vitals: Vitals | None = None
    otherData: OtherData | None = None

class Vaccination(BaseModel):
    name: str
    doctor: str
    date: str

class MedicalHistory(BaseModel):
    bloodPanels: list[Dict[str, Any]]
    clinicalReports: list[Dict[str, Any]]
    doctorLetters: list[Dict[str, Any]]

class ReasonsForVisit(BaseModel):
    reason: str

class AdditionalComments(BaseModel):
    comment: str
