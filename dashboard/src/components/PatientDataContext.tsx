import React, { createContext, useContext, useState } from "react";

export const PatientDataContext = createContext<{
  patientData: any;
  setPatientData: (data: any) => void;
}>({
  patientData: {},
  setPatientData: () => {},
});

export const usePatientData = () => useContext(PatientDataContext);

export const PatientDataProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [patientData, setPatientData] = useState<any>({});
  return (
    <PatientDataContext.Provider value={{ patientData, setPatientData }}>
      {children}
    </PatientDataContext.Provider>
  );
};