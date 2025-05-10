
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";

interface VitalsCardProps {
  vitals: {
    bloodPressure: {
      systolic: number;
      diastolic: number;
    };
    bodyTemperature: number;
    bloodOxygenSaturation: number;
    bloodGlucose: Array<{value: number}>;
  };
  respiratory: {
    respiratoryRate: number;
    oxygenSaturation: number;
    peakExpiratoryFlowRate: number;
  };
  heart: {
    heartRate: number;
    restingHeartRate: number;
    walkingHeartRateAverage: number;
  };
}

export default function VitalsCard({ vitals, respiratory, heart }: VitalsCardProps) {
  // Calculate average glucose
  const averageGlucose = vitals.bloodGlucose.reduce((sum, reading) => sum + reading.value, 0) / vitals.bloodGlucose.length;

  // Define normal ranges and check if values are within range
  const isNormal = {
    bloodPressure: vitals.bloodPressure.systolic < 130 && vitals.bloodPressure.diastolic < 80,
    bodyTemperature: vitals.bodyTemperature >= 36.5 && vitals.bodyTemperature <= 37.3,
    spo2: vitals.bloodOxygenSaturation >= 95,
    heartRate: heart.heartRate >= 60 && heart.heartRate <= 100,
    respiratoryRate: respiratory.respiratoryRate >= 12 && respiratory.respiratoryRate <= 20,
    glucose: averageGlucose >= 70 && averageGlucose <= 140
  };

  const getStatusColorClass = (isNormal: boolean) => {
    return isNormal ? "text-medical-success" : "text-medical-danger";
  };

  return (
    <Card className="shadow-sm">
      <CardHeader className="pb-2">
        <CardTitle className="text-lg text-medical-primary">Vital Signs</CardTitle>
      </CardHeader>
      <CardContent>
        <div className="grid grid-cols-2 md:grid-cols-3 gap-4">
          <div className="space-y-1">
            <div className="text-xs font-medium text-gray-500">Blood Pressure</div>
            <div className="flex items-baseline">
              <span className={`text-xl font-medium ${getStatusColorClass(isNormal.bloodPressure)}`}>
                {vitals.bloodPressure.systolic}/{vitals.bloodPressure.diastolic}
              </span>
              <span className="ml-1 text-xs text-gray-500">mmHg</span>
            </div>
          </div>
          
          <div className="space-y-1">
            <div className="text-xs font-medium text-gray-500">Heart Rate</div>
            <div className="flex items-baseline">
              <span className={`text-xl font-medium ${getStatusColorClass(isNormal.heartRate)}`}>
                {heart.heartRate}
              </span>
              <span className="ml-1 text-xs text-gray-500">bpm</span>
            </div>
          </div>
          
          <div className="space-y-1">
            <div className="text-xs font-medium text-gray-500">Body Temperature</div>
            <div className="flex items-baseline">
              <span className={`text-xl font-medium ${getStatusColorClass(isNormal.bodyTemperature)}`}>
                {vitals.bodyTemperature}
              </span>
              <span className="ml-1 text-xs text-gray-500">°C</span>
            </div>
          </div>
          
          <div className="space-y-1">
            <div className="text-xs font-medium text-gray-500">Respiratory Rate</div>
            <div className="flex items-baseline">
              <span className={`text-xl font-medium ${getStatusColorClass(isNormal.respiratoryRate)}`}>
                {respiratory.respiratoryRate}
              </span>
              <span className="ml-1 text-xs text-gray-500">breaths/min</span>
            </div>
          </div>
          
          <div className="space-y-1">
            <div className="text-xs font-medium text-gray-500">Oxygen Saturation</div>
            <div className="flex items-baseline">
              <span className={`text-xl font-medium ${getStatusColorClass(isNormal.spo2)}`}>
                {vitals.bloodOxygenSaturation}
              </span>
              <span className="ml-1 text-xs text-gray-500">%</span>
            </div>
          </div>
          
          <div className="space-y-1">
            <div className="text-xs font-medium text-gray-500">Blood Glucose (avg)</div>
            <div className="flex items-baseline">
              <span className={`text-xl font-medium ${getStatusColorClass(isNormal.glucose)}`}>
                {averageGlucose.toFixed(1)}
              </span>
              <span className="ml-1 text-xs text-gray-500">mg/dL</span>
            </div>
          </div>
        </div>
      </CardContent>
    </Card>
  );
}
