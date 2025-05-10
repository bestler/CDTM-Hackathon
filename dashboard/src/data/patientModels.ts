// patientModels.ts
// TypeScript interfaces matching server/models.py

export interface Insurance {
  provider: string;
  insuranceNumber: string;
}

export interface GeneralInformation {
  name: string;
  dateOfBirth: string;
  gender: string;
  address: string;
  insurance: Insurance;
}

export interface Activity {
  stepCount?: number;
  walkingDistance?: number;
  runningDistance?: number;
  flightsClimbed?: number;
  activeEnergyBurned?: number;
  exerciseMinutes?: number;
  standHours?: number;
}

export interface BodyMeasurements {
  height?: number;
  weight?: number;
  bodyMassIndex?: number;
  bodyFatPercentage?: number;
  leanBodyMass?: number;
  waistCircumference?: number;
}

export interface CycleTracking {
  menstrualFlow?: string;
  basalBodyTemperature?: number;
  ovulationTestResult?: string;
  cervicalMucusQuality?: string;
  sexualActivity?: boolean;
}

export interface Hearing {
  headphoneAudioLevels?: number;
  environmentalSoundLevels?: number;
  hearingDeviceAudioLevels?: number;
}

export interface Electrocardiogram {
  classification?: string;
  averageHeartRate?: number;
  samplingFrequency?: number;
  voltageMeasurements?: number[];
}

export interface Heart {
  heartRate?: number;
  restingHeartRate?: number;
  walkingHeartRateAverage?: number;
  heartRateVariability?: number;
  electrocardiogram?: Electrocardiogram;
}

export interface Medication {
  medicationName?: string;
  dosage?: string;
  frequency?: string;
  route?: string;
  startDate?: string;
  endDate?: string;
}

export interface MentalWellbeing {
  mindfulnessMinutes?: number;
  moodTracking?: string;
  stressLevel?: string;
  anxietyTestResult?: string;
  depressionTestResult?: string;
}

export interface Mobility {
  walkingSpeed?: number;
  stepLength?: number;
  doubleSupportTime?: number;
  walkingAsymmetry?: number;
  walkingSteadiness?: string;
}

export interface Nutrition {
  calories?: number;
  carbohydrates?: number;
  protein?: number;
  fat?: number;
  fiber?: number;
  sugar?: number;
  sodium?: number;
  water?: number;
}

export interface Respiratory {
  respiratoryRate?: number;
  oxygenSaturation?: number;
  peakExpiratoryFlowRate?: number;
}

export interface SleepStages {
  core?: number;
  deep?: number;
  rem?: number;
  awake?: number;
}

export interface Sleep {
  inBedTime?: string;
  asleepTime?: string;
  sleepDuration?: number;
  sleepStages?: SleepStages;
}

export interface Symptoms {
  headache?: boolean;
  fatigue?: boolean;
  fever?: boolean;
  chills?: boolean;
  cough?: boolean;
  shortnessOfBreath?: boolean;
  nausea?: boolean;
  diarrhea?: boolean;
}

export interface BloodPressure {
  systolic?: number;
  diastolic?: number;
}

export interface Vitals {
  bloodPressure?: BloodPressure;
  bodyTemperature?: number;
  bloodOxygenSaturation?: number;
  bloodGlucose?: { value: number }[];
}

export interface OtherData {
  handwashingDuration?: number;
  timeInDaylight?: number;
  uvExposure?: number;
}

export interface AppleHealth {
  activity?: Activity;
  bodyMeasurements?: BodyMeasurements;
  cycleTracking?: CycleTracking;
  hearing?: Hearing;
  heart?: Heart;
  medications?: Medication[];
  mentalWellbeing?: MentalWellbeing;
  mobility?: Mobility;
  nutrition?: Nutrition;
  respiratory?: Respiratory;
  sleep?: Sleep;
  symptoms?: Symptoms;
  vitals?: Vitals;
  otherData?: OtherData;
}

export interface Vaccination {
  name: string;
  doctor: string;
  date: string;
}

export interface ValueUnit {
  value: number;
  unit: string;
}

export interface BloodPanel {
  hemoglobin?: ValueUnit;
  hematocrit?: ValueUnit;
  erythrocytes?: ValueUnit;
  leukocytes?: ValueUnit;
  platelets?: ValueUnit;
  MCV?: ValueUnit;
  MCH?: ValueUnit;
  MCHC?: ValueUnit;
  neutrophils?: ValueUnit;
  lymphocytes?: ValueUnit;
  monocytes?: ValueUnit;
  eosinophils?: ValueUnit;
  basophils?: ValueUnit;
  reticulocytes?: ValueUnit;
  CRP?: ValueUnit;
}

export interface OtherFinding {
  date: string;
  test: string;
  testDiagnosis: string;
}

export interface ClinicalReport {
  doctor?: string;
  clinic?: string;
  recipient?: string;
  diagnosis?: string[];
  anamneses?: string;
  otherFindings?: OtherFinding[];
  medications?: Medication[];
  laboratory?: BloodPanel[];
}

export interface Recommendation {
  name?: string;
}

export interface DoctorLetter {
  sender?: string;
  recipient?: string;
  diagnosis?: string[];
  recommendations?: Recommendation[];
}

export interface MedicalHistory {
  bloodPanels: BloodPanel[];
  clinicalReports: ClinicalReport[];
  doctorLetters: DoctorLetter[];
}

export interface ReasonsForVisit {
  reason: string;
}

export interface AdditionalComments {
  comment: string;
}
