
export const patientData = {
  "generalInformation": {
    "name": "Jane Smith",
    "dateOfBirth": "1985-06-15",
    "gender": "Female",
    "address": "123 Main St, Boston, MA 02115",
    "insurance": {
      "provider": "Blue Cross Blue Shield",
      "insuranceNumber": "BCBS123456789"
    }
  },
  "appleHealth": {
    "activity": {
      "stepCount": 8543,
      "walkingDistance": 6.2,
      "runningDistance": 2.5,
      "flightsClimbed": 12,
      "activeEnergyBurned": 420,
      "exerciseMinutes": 42,
      "standHours": 10
    },
    "bodyMeasurements": {
      "height": 165,
      "weight": 65.8,
      "bodyMassIndex": 24.2,
      "bodyFatPercentage": 26.5,
      "leanBodyMass": 48.4,
      "waistCircumference": 76.2
    },
    "cycleTracking": {
      "menstrualFlow": "Medium",
      "basalBodyTemperature": 36.6,
      "ovulationTestResult": "Positive",
      "cervicalMucusQuality": "Egg white",
      "sexualActivity": true
    },
    "hearing": {
      "headphoneAudioLevels": 65,
      "environmentalSoundLevels": 58,
      "hearingDeviceAudioLevels": 0
    },
    "heart": {
      "heartRate": 72,
      "restingHeartRate": 62,
      "walkingHeartRateAverage": 94,
      "heartRateVariability": 45,
      "electrocardiogram": {
        "classification": "Sinus Rhythm",
        "averageHeartRate": 68,
        "samplingFrequency": 512,
        "voltageMeasurements": [0.12, 0.15, 1.02, 1.52, 0.08, -0.67, -0.32]
      }
    },
    "medications": [
      {
        "medicationName": "Lisinopril",
        "dosage": "10mg",
        "frequency": "Once daily",
        "route": "Oral",
        "startDate": "2023-01-15",
        "endDate": ""
      },
      {
        "medicationName": "Metformin",
        "dosage": "500mg",
        "frequency": "Twice daily",
        "route": "Oral",
        "startDate": "2022-11-03",
        "endDate": ""
      }
    ],
    "mentalWellbeing": {
      "mindfulnessMinutes": 15,
      "moodTracking": "Good",
      "stressLevel": "Low",
      "anxietyTestResult": "Minimal anxiety",
      "depressionTestResult": "No depression"
    },
    "mobility": {
      "walkingSpeed": 1.2,
      "stepLength": 0.68,
      "doubleSupportTime": 0.25,
      "walkingAsymmetry": 0.03,
      "walkingSteadiness": "OK"
    },
    "nutrition": {
      "calories": 1850,
      "carbohydrates": 210,
      "protein": 95,
      "fat": 62,
      "fiber": 28,
      "sugar": 38,
      "sodium": 2300,
      "water": 2.1
    },
    "respiratory": {
      "respiratoryRate": 16,
      "oxygenSaturation": 98,
      "peakExpiratoryFlowRate": 420
    },
    "sleep": {
      "inBedTime": "22:30",
      "asleepTime": "23:05",
      "sleepDuration": 7.2,
      "sleepStages": {
        "core": 3.8,
        "deep": 1.5,
        "rem": 1.6,
        "awake": 0.3
      }
    },
    "symptoms": {
      "headache": false,
      "fatigue": true,
      "fever": false,
      "chills": false,
      "cough": false,
      "shortnessOfBreath": false,
      "nausea": false,
      "diarrhea": false
    },
    "vitals": {
      "bloodPressure": {
        "systolic": 118,
        "diastolic": 75
      },
      "bodyTemperature": 36.7,
      "bloodOxygenSaturation": 98,
      "bloodGlucose": [
        { "value": 92 },
        { "value": 105 },
        { "value": 88 }
      ]
    },
    "otherData": {
      "handwashingDuration": 22,
      "timeInDaylight": 75,
      "uvExposure": 2.4
    }
  },
  "vaccinations": [
    {
      "name": "COVID-19 mRNA",
      "doctor": "Dr. Lisa Chen",
      "date": "2023-09-20"
    },
    {
      "name": "Influenza",
      "doctor": "Dr. Mark Wilson",
      "date": "2023-10-05"
    },
    {
      "name": "Tetanus/Diphtheria/Pertussis (Tdap)",
      "doctor": "Dr. Lisa Chen",
      "date": "2020-03-12"
    }
  ],
  "medicalHistory": {
    "bloodPanels": [
      {
        "hemoglobin": {
          "value": 13.8,
          "unit": "g/dL"
        },
        "hematocrit": {
          "value": 41.2,
          "unit": "%"
        },
        "erythrocytes": {
          "value": 4.78,
          "unit": "×10^12/L"
        },
        "leukocytes": {
          "value": 6.2,
          "unit": "×10^9/L"
        },
        "platelets": {
          "value": 245,
          "unit": "×10^9/L"
        },
        "MCV": {
          "value": 86,
          "unit": "fL"
        },
        "MCH": {
          "value": 28.9,
          "unit": "pg"
        },
        "MCHC": {
          "value": 33.5,
          "unit": "g/dL"
        },
        "neutrophils": {
          "value": 3.4,
          "unit": "×10^9/L"
        },
        "lymphocytes": {
          "value": 2.1,
          "unit": "×10^9/L"
        },
        "monocytes": {
          "value": 0.4,
          "unit": "×10^9/L"
        },
        "eosinophils": {
          "value": 0.2,
          "unit": "×10^9/L"
        },
        "basophils": {
          "value": 0.1,
          "unit": "×10^9/L"
        },
        "reticulocytes": {
          "value": 1.2,
          "unit": "%"
        },
        "CRP": {
          "value": 2.4,
          "unit": "mg/L"
        }
      }
    ],
    "clinicalReports": [
      {
        "doctor": "Dr. James Rodriguez",
        "clinic": "Boston Medical Center",
        "recipient": "Jane Smith",
        "diagnosis": ["Type 2 Diabetes", "Hypertension"],
        "anamneses": "Patient presents with elevated blood glucose levels and slightly elevated blood pressure. Reports occasional fatigue and increased thirst.",
        "otherFindings": [
          {
            "date": "2023-06-18",
            "test": "Lipid Panel",
            "testDiagnosis": "Total cholesterol slightly elevated at 205 mg/dL"
          },
          {
            "date": "2023-06-18",
            "test": "HbA1c",
            "testDiagnosis": "6.5%, consistent with diabetes diagnosis"
          }
        ],
        "medications": [
          {
            "medicationName": "Lisinopril",
            "dosage": "10mg",
            "frequency": "Once daily",
            "route": "Oral",
            "startDate": "2023-01-15",
            "endDate": ""
          },
          {
            "medicationName": "Metformin",
            "dosage": "500mg",
            "frequency": "Twice daily",
            "route": "Oral",
            "startDate": "2022-11-03",
            "endDate": ""
          }
        ],
        "laboratory": []
      }
    ],
    "doctorLetters": [
      {
        "sender": "Dr. James Rodriguez",
        "recipient": "Dr. Sarah Johnson",
        "diagnosis": ["Type 2 Diabetes", "Hypertension"],
        "recommendations": [
          {
            "name": "Continue current medication regimen and reassess in 3 months"
          },
          {
            "name": "Encourage patient to maintain dietary modifications and regular exercise"
          },
          {
            "name": "Consider referral to diabetes education program"
          }
        ]
      }
    ]
  },
  "reasonsForVisit": "Three-month follow-up for diabetes management and medication review",
  "additionalComments": "Patient reports good adherence to medication regimen. Has been making dietary changes and exercising 3 times weekly."
};
