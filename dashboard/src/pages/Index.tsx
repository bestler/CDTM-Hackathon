import React, { useEffect, useState } from "react";
import DashboardLayout from "@/components/DashboardLayout";
import PatientHeader from "@/components/PatientHeader";
import VitalsCard from "@/components/VitalsCard";
import ActivityChart from "@/components/ActivityChart";
import HealthMetricsCard from "@/components/HealthMetricsCard";
import MedicationsCard from "@/components/MedicationsCard";
import WellbeingCard from "@/components/WellbeingCard";
import SymptomsCard from "@/components/SymptomsCard";
import VaccinationsCard from "@/components/VaccinationsCard";
import {
  fetchGeneralInformation,
  fetchAppleHealth,
  fetchVaccinations,
  fetchBloodPanels,
  fetchClinicalReports,
  fetchDoctorLetters,
  fetchMedications,
  fetchReasonsForVisit,
  fetchAdditionalComments
} from "@/fetch/patientFetch";
import { usePatientData } from "@/components/PatientDataContext";

const emptyPatient = {
  name: "",
  dateOfBirth: "",
  gender: "",
  address: "",
  insurance: { provider: "", insuranceNumber: "" },
};

const emptyVitals = {
  bloodPressure: { systolic: 0, diastolic: 0 },
  bodyTemperature: 0,
  bloodOxygenSaturation: 0,
  bloodGlucose: [],
};
const emptyRespiratory = {
  respiratoryRate: 0,
  oxygenSaturation: 0,
  peakExpiratoryFlowRate: 0,
};
const emptyHeart = {
  heartRate: 0,
  restingHeartRate: 0,
  walkingHeartRateAverage: 0,
};
const emptyBodyMeasurements = {
  height: 0,
  weight: 0,
  bodyMassIndex: 0,
  bodyFatPercentage: 0,
  leanBodyMass: 0,
  waistCircumference: 0,
};
const emptyBloodGlucose = [];
const emptyMedications = [];
const emptyMentalWellbeing = {
  mindfulnessMinutes: 0,
  moodTracking: "",
  stressLevel: "",
  anxietyTestResult: "",
  depressionTestResult: "",
};
const emptySleep = {
  inBedTime: "",
  asleepTime: "",
  sleepDuration: 0,
  sleepStages: { core: 0, deep: 0, rem: 0, awake: 0 },
};
const emptySymptoms = {
  headache: false,
  fatigue: false,
  fever: false,
  chills: false,
  cough: false,
  shortnessOfBreath: false,
  nausea: false,
  diarrhea: false,
};
const emptyVaccinations = [];

const Index = () => {
  const { patientData, setPatientData } = usePatientData();

  useEffect(() => {
    fetchGeneralInformation()
      .then(data => setPatientData((prev: any) => ({ ...prev, generalInformation: data })))
      .catch(() => setPatientData((prev: any) => ({ ...prev, generalInformation: {} })));
    fetchAppleHealth()
      .then(data => setPatientData((prev: any) => ({ ...prev, appleHealth: data })))
      .catch(() => setPatientData((prev: any) => ({ ...prev, appleHealth: {} })));
    fetchVaccinations()
      .then(data => setPatientData((prev: any) => ({ ...prev, vaccinations: data })))
      .catch(() => setPatientData((prev: any) => ({ ...prev, vaccinations: [] })));
    fetchBloodPanels()
      .then(data => setPatientData((prev: any) => ({ ...prev, medicalHistory: { ...(prev.medicalHistory || {}), bloodPanels: data } })))
      .catch(() => setPatientData((prev: any) => ({ ...prev, medicalHistory: { ...(prev.medicalHistory || {}), bloodPanels: [] } })));
    fetchClinicalReports()
      .then(data => setPatientData((prev: any) => ({ ...prev, medicalHistory: { ...(prev.medicalHistory || {}), clinicalReports: data } })))
      .catch(() => setPatientData((prev: any) => ({ ...prev, medicalHistory: { ...(prev.medicalHistory || {}), clinicalReports: [] } })));
    fetchDoctorLetters()
      .then(data => setPatientData((prev: any) => ({ ...prev, medicalHistory: { ...(prev.medicalHistory || {}), doctorLetters: data } })))
      .catch(() => setPatientData((prev: any) => ({ ...prev, medicalHistory: { ...(prev.medicalHistory || {}), doctorLetters: [] } })));
    fetchMedications()
      .then(data => setPatientData((prev: any) => ({ ...prev, medications: data })))
      .catch(() => setPatientData((prev: any) => ({ ...prev, medications: [] })));
    fetchReasonsForVisit()
      .then(data => setPatientData((prev: any) => ({ ...prev, reasonsForVisit: typeof data === 'string' ? data : data.reasonsForVisit || "" })))
      .catch(() => setPatientData((prev: any) => ({ ...prev, reasonsForVisit: "" })));
    fetchAdditionalComments()
      .then(data => setPatientData((prev: any) => ({ ...prev, additionalComments: typeof data === 'string' ? data : data.additionalComments || "" })))
      .catch(() => setPatientData((prev: any) => ({ ...prev, additionalComments: "" })));
  }, [setPatientData]);

  return (
    <DashboardLayout
      patientName={patientData?.generalInformation?.name || ""}
      data={patientData}
    >
      <div className="space-y-6">
        {/* Patient Information */}
        <PatientHeader 
          patientData={patientData?.generalInformation || emptyPatient} 
          reasonForVisit={patientData?.reasonsForVisit || ""} 
        />
        {/* Vitals Overview */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          <VitalsCard 
            vitals={patientData?.appleHealth?.vitals ?? emptyVitals} 
            respiratory={patientData?.appleHealth?.respiratory ?? emptyRespiratory} 
            heart={patientData?.appleHealth?.heart ?? emptyHeart} 
          />
          <ActivityChart activity={patientData?.appleHealth?.activity ?? {}} />
        </div>
        {/* Health Metrics & Medications */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          <HealthMetricsCard 
            bodyMeasurements={patientData?.appleHealth?.bodyMeasurements ?? emptyBodyMeasurements} 
            bloodGlucose={patientData?.appleHealth?.vitals?.bloodGlucose ?? emptyBloodGlucose} 
          />
          <MedicationsCard medications={patientData?.appleHealth?.medications ?? emptyMedications} />
        </div>
        {/* Wellbeing & Symptoms */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          <WellbeingCard 
            mentalWellbeing={patientData?.appleHealth?.mentalWellbeing ?? emptyMentalWellbeing} 
            sleep={patientData?.appleHealth?.sleep ?? emptySleep} 
          />
          <div className="space-y-6">
            <SymptomsCard symptoms={patientData?.appleHealth?.symptoms ?? emptySymptoms} />
            <VaccinationsCard vaccinations={patientData?.vaccinations ?? emptyVaccinations} />
          </div>
        </div>
      </div>
    </DashboardLayout>
  );
};

export default Index;
