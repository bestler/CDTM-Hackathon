// patientFetch.ts
// Functions to fetch patient data from the backend API

const API_BASE = import.meta.env.VITE_API_BASE

export async function fetchGeneralInformation() {
  const res = await fetch(`${API_BASE}/get/generalInformation`);
  if (!res.ok) throw new Error("Failed to fetch general information");
  return await res.json();
}

export async function fetchAppleHealth() {
  const res = await fetch(`${API_BASE}/get/appleHealth`);
  if (!res.ok) throw new Error("Failed to fetch Apple Health data");
  return await res.json();
}

export async function fetchVaccinations() {
  const res = await fetch(`${API_BASE}/get/vaccinations`);
  if (!res.ok) throw new Error("Failed to fetch vaccinations");
  return await res.json();
}

export async function fetchBloodPanels() {
  const res = await fetch(`${API_BASE}/get/bloodPanels`);
  if (!res.ok) throw new Error("Failed to fetch blood panels");
  return await res.json();
}

export async function fetchClinicalReports() {
  const res = await fetch(`${API_BASE}/get/clinicalReports`);
  if (!res.ok) throw new Error("Failed to fetch clinical reports");
  return await res.json();
}

export async function fetchDoctorLetters() {
  const res = await fetch(`${API_BASE}/get/doctorLetters`);
  if (!res.ok) throw new Error("Failed to fetch doctor letters");
  return await res.json();
}

export async function fetchMedications() {
  const res = await fetch(`${API_BASE}/get/medications`);
  if (!res.ok) throw new Error("Failed to fetch medications");
  return await res.json();
}

export async function fetchReasonsForVisit() {
  const res = await fetch(`${API_BASE}/get/reasonsForVisit`);
  if (!res.ok) throw new Error("Failed to fetch reasons for visit");
  return await res.json();
}

export async function fetchAdditionalComments() {
  const res = await fetch(`${API_BASE}/get/additionalComments`);
  if (!res.ok) throw new Error("Failed to fetch additional comments");
  return await res.json();
}
