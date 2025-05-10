import { createRoot } from 'react-dom/client'
import App from './App.tsx'
import './index.css'
import { PatientDataProvider } from "@/components/PatientDataContext";

createRoot(document.getElementById("root")!).render(
  <PatientDataProvider>
    <App />
  </PatientDataProvider>
);
