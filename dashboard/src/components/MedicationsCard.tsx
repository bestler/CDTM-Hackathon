
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";

interface Medication {
  medicationName: string;
  dosage: string;
  frequency: string;
  route: string;
  startDate: string;
  endDate: string;
}

interface MedicationsCardProps {
  medications: Medication[];
}

export default function MedicationsCard({ medications }: MedicationsCardProps) {
  // Utility to format medication dates
  const formatDate = (dateString: string) => {
    if (!dateString) return 'Ongoing';
    return new Date(dateString).toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
    });
  };

  return (
    <Card className="shadow-sm">
      <CardHeader className="pb-2">
        <CardTitle className="text-lg text-medical-primary">Current Medications</CardTitle>
      </CardHeader>
      <CardContent>
        {medications.length === 0 ? (
          <p className="text-sm text-gray-500">No active medications</p>
        ) : (
          <div className="space-y-4">
            {medications.map((med, index) => (
              <div key={index} className="border-b border-gray-100 pb-3 last:border-0 last:pb-0">
                <div className="flex justify-between items-start">
                  <h3 className="font-medium text-medical-text">{med.medicationName}</h3>
                  <Badge variant="outline" className="bg-blue-50 text-blue-700 border-blue-200">
                    {med.route}
                  </Badge>
                </div>
                <p className="text-sm text-gray-600 mt-1">
                  {med.dosage}, {med.frequency}
                </p>
                <p className="text-xs text-gray-500 mt-1">
                  Started: {formatDate(med.startDate)} 
                  {med.endDate && ` • Ended: ${formatDate(med.endDate)}`}
                </p>
              </div>
            ))}
          </div>
        )}
      </CardContent>
    </Card>
  );
}
