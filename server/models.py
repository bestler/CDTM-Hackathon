from pydantic import BaseModel
from typing import Dict, Any

class StrictBaseModel(BaseModel):
    model_config = {"extra": "forbid"}

class Insurance(StrictBaseModel):
    provider: str
    insuranceNumber: str

class GeneralInformation(StrictBaseModel):
    name: str
    dateOfBirth: str
    gender: str
    address: str
    insurance: Insurance

class Activity(StrictBaseModel):
    stepCount: float | None = None
    walkingDistance: float | None = None
    runningDistance: float | None = None
    flightsClimbed: float | None = None
    activeEnergyBurned: float | None = None
    exerciseMinutes: float | None = None
    standHours: float | None = None

class BodyMeasurements(StrictBaseModel):
    height: float | None = None
    weight: float | None = None
    bodyMassIndex: float | None = None
    bodyFatPercentage: float | None = None
    leanBodyMass: float | None = None
    waistCircumference: float | None = None

class CycleTracking(StrictBaseModel):
    menstrualFlow: str | None = None
    basalBodyTemperature: float | None = None
    ovulationTestResult: str | None = None
    cervicalMucusQuality: str | None = None
    sexualActivity: bool | None = None

class Hearing(StrictBaseModel):
    headphoneAudioLevels: float | None = None
    environmentalSoundLevels: float | None = None
    hearingDeviceAudioLevels: float | None = None

class Electrocardiogram(StrictBaseModel):
    classification: str | None = None
    averageHeartRate: float | None = None
    samplingFrequency: float | None = None
    voltageMeasurements: list[float] | None = None

class Heart(StrictBaseModel):
    heartRate: float | None = None
    restingHeartRate: float | None = None
    walkingHeartRateAverage: float | None = None
    heartRateVariability: float | None = None
    electrocardiogram: Electrocardiogram | None = None

class Medication(StrictBaseModel):
    medicationName: str | None = None
    dosage: str | None = None
    frequency: str | None = None
    route: str | None = None
    startDate: str | None = None
    endDate: str | None = None

class MentalWellbeing(StrictBaseModel):
    mindfulnessMinutes: float | None = None
    moodTracking: str | None = None
    stressLevel: str | None = None
    anxietyTestResult: str | None = None
    depressionTestResult: str | None = None

class Mobility(StrictBaseModel):
    walkingSpeed: float | None = None
    stepLength: float | None = None
    doubleSupportTime: float | None = None
    walkingAsymmetry: float | None = None
    walkingSteadiness: str | None = None

class Nutrition(StrictBaseModel):
    calories: float | None = None
    carbohydrates: float | None = None
    protein: float | None = None
    fat: float | None = None
    fiber: float | None = None
    sugar: float | None = None
    sodium: float | None = None
    water: float | None = None

class Respiratory(StrictBaseModel):
    respiratoryRate: float | None = None
    oxygenSaturation: float | None = None
    peakExpiratoryFlowRate: float | None = None

class SleepStages(StrictBaseModel):
    core: float | None = None
    deep: float | None = None
    rem: float | None = None
    awake: float | None = None

class Sleep(StrictBaseModel):
    inBedTime: str | None = None
    asleepTime: str | None = None
    sleepDuration: float | None = None
    sleepStages: SleepStages | None = None

class Symptoms(StrictBaseModel):
    headache: bool | None = None
    fatigue: bool | None = None
    fever: bool | None = None
    chills: bool | None = None
    cough: bool | None = None
    shortnessOfBreath: bool | None = None
    nausea: bool | None = None
    diarrhea: bool | None = None

class BloodPressure(StrictBaseModel):
    systolic: float | None = None
    diastolic: float | None = None

class Vitals(StrictBaseModel):
    bloodPressure: BloodPressure | None = None
    bodyTemperature: float | None = None
    bloodOxygenSaturation: float | None = None
    bloodGlucose: list[Dict[str, float]] | None = None

class OtherData(StrictBaseModel):
    handwashingDuration: float | None = None
    timeInDaylight: float | None = None
    uvExposure: float | None = None

class AppleHealth(StrictBaseModel):
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

class Vaccination(StrictBaseModel):
    name: str
    doctor: str
    date: str

class ValueUnit(StrictBaseModel):
    value: float
    unit: str

class BloodPanel(StrictBaseModel):
    hemoglobin: ValueUnit | None = None
    hematocrit: ValueUnit | None = None
    erythrocytes: ValueUnit | None = None
    leukocytes: ValueUnit | None = None
    platelets: ValueUnit | None = None
    MCV: ValueUnit | None = None
    MCH: ValueUnit | None = None
    MCHC: ValueUnit | None = None
    neutrophils: ValueUnit | None = None
    lymphocytes: ValueUnit | None = None
    monocytes: ValueUnit | None = None
    eosinophils: ValueUnit | None = None
    basophils: ValueUnit | None = None
    reticulocytes: ValueUnit | None = None
    CRP: ValueUnit | None = None

class OtherFinding(StrictBaseModel):
    date: str
    test: str
    testDiagnosis: str

class ClinicalReport(StrictBaseModel):
    doctor: str | None = None
    clinic: str | None = None
    recipient: str | None = None
    diagnosis: list[str] | None = None
    anamneses: str | None = None
    otherFindings: list[OtherFinding] | None = None
    medications: list[Medication] | None = None
    laboratory: list[BloodPanel] | None = None

class Recommendation(StrictBaseModel):
    name: str | None = None

class DoctorLetter(StrictBaseModel):
    sender: str | None = None
    recipient: str | None = None
    diagnosis: list[str] | None = None
    recommendations: list[Recommendation] | None = None

class MedicalHistory(StrictBaseModel):
    bloodPanels: list[BloodPanel]
    clinicalReports: list[ClinicalReport]
    doctorLetters: list[DoctorLetter]

class ReasonsForVisit(StrictBaseModel):
    reason: str

class AdditionalComments(StrictBaseModel):
    comment: str
