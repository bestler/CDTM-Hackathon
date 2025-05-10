
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Check, X } from "lucide-react";

interface SymptomsCardProps {
  symptoms: {
    headache: boolean;
    fatigue: boolean;
    fever: boolean;
    chills: boolean;
    cough: boolean;
    shortnessOfBreath: boolean;
    nausea: boolean;
    diarrhea: boolean;
  };
}

export default function SymptomsCard({ symptoms }: SymptomsCardProps) {
  // Convert symptoms object to array for easier rendering
  const symptomsList = Object.entries(symptoms).map(([key, value]) => ({
    name: key.charAt(0).toUpperCase() + key.slice(1).replace(/([A-Z])/g, ' $1'),
    present: value
  }));

  // Group symptoms by presence
  const presentSymptoms = symptomsList.filter(symptom => symptom.present);
  const absentSymptoms = symptomsList.filter(symptom => !symptom.present);

  return (
    <Card className="shadow-sm">
      <CardHeader className="pb-2">
        <CardTitle className="text-lg text-medical-primary">Symptoms</CardTitle>
      </CardHeader>
      <CardContent>
        <div className="space-y-4">
          <div>
            <h3 className="text-sm font-medium text-medical-danger mb-2">Reported Symptoms</h3>
            {presentSymptoms.length > 0 ? (
              <div className="flex flex-wrap gap-2">
                {presentSymptoms.map((symptom, index) => (
                  <Badge key={index} variant="outline" className="bg-red-50 text-red-700 border-red-200">
                    {symptom.name}
                  </Badge>
                ))}
              </div>
            ) : (
              <p className="text-sm text-gray-500">No symptoms reported</p>
            )}
          </div>
          
          <div>
            <h3 className="text-sm font-medium text-medical-success mb-2">Absent Symptoms</h3>
            <div className="grid grid-cols-2 sm:grid-cols-4 gap-2">
              {absentSymptoms.map((symptom, index) => (
                <div key={index} className="flex items-center text-sm text-gray-600">
                  <X className="h-3 w-3 text-gray-400 mr-1" />
                  <span>{symptom.name}</span>
                </div>
              ))}
            </div>
          </div>
        </div>
      </CardContent>
    </Card>
  );
}
