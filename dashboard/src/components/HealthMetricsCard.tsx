
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from "recharts";

interface HealthMetricsCardProps {
  bodyMeasurements: {
    height: number;
    weight: number;
    bodyMassIndex: number;
    bodyFatPercentage: number;
    leanBodyMass: number;
    waistCircumference: number;
  };
  bloodGlucose: Array<{value: number}>;
}

export default function HealthMetricsCard({ bodyMeasurements, bloodGlucose }: HealthMetricsCardProps) {
  // BMI classification
  const getBMIClass = (bmi: number) => {
    if (bmi < 18.5) return { class: "Underweight", color: "text-blue-500" };
    if (bmi < 25) return { class: "Normal", color: "text-green-500" };
    if (bmi < 30) return { class: "Overweight", color: "text-yellow-500" };
    return { class: "Obese", color: "text-red-500" };
  };
  
  const bmiStatus = getBMIClass(bodyMeasurements.bodyMassIndex);

  // Mock blood glucose trend (since we only have array values without dates)
  const glucoseTrend = bloodGlucose.map((reading, index) => ({
    reading: index + 1,
    value: reading.value,
  }));

  // Add some historical mock data points to make trend more meaningful
  glucoseTrend.unshift({ reading: 0, value: 103 });
  glucoseTrend.unshift({ reading: -1, value: 110 });
  glucoseTrend.unshift({ reading: -2, value: 115 });
  
  return (
    <Card className="shadow-sm">
      <CardHeader className="pb-2">
        <CardTitle className="text-lg text-medical-primary">Health Metrics</CardTitle>
      </CardHeader>
      <CardContent>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div>
            <div className="grid grid-cols-2 gap-4 mb-4">
              <div className="space-y-1">
                <div className="text-xs font-medium text-gray-500">Height</div>
                <div className="flex items-baseline">
                  <span className="text-base font-medium text-medical-text">
                    {bodyMeasurements.height}
                  </span>
                  <span className="ml-1 text-xs text-gray-500">cm</span>
                </div>
              </div>
              
              <div className="space-y-1">
                <div className="text-xs font-medium text-gray-500">Weight</div>
                <div className="flex items-baseline">
                  <span className="text-base font-medium text-medical-text">
                    {bodyMeasurements.weight}
                  </span>
                  <span className="ml-1 text-xs text-gray-500">kg</span>
                </div>
              </div>
              
              <div className="space-y-1">
                <div className="text-xs font-medium text-gray-500">BMI</div>
                <div className="flex items-baseline">
                  <span className={`text-base font-medium ${bmiStatus.color}`}>
                    {bodyMeasurements.bodyMassIndex}
                  </span>
                  <span className={`ml-1 text-xs ${bmiStatus.color}`}>({bmiStatus.class})</span>
                </div>
              </div>
              
              <div className="space-y-1">
                <div className="text-xs font-medium text-gray-500">Body Fat</div>
                <div className="flex items-baseline">
                  <span className="text-base font-medium text-medical-text">
                    {bodyMeasurements.bodyFatPercentage}
                  </span>
                  <span className="ml-1 text-xs text-gray-500">%</span>
                </div>
              </div>
              
              <div className="space-y-1">
                <div className="text-xs font-medium text-gray-500">Lean Mass</div>
                <div className="flex items-baseline">
                  <span className="text-base font-medium text-medical-text">
                    {bodyMeasurements.leanBodyMass}
                  </span>
                  <span className="ml-1 text-xs text-gray-500">kg</span>
                </div>
              </div>
              
              <div className="space-y-1">
                <div className="text-xs font-medium text-gray-500">Waist</div>
                <div className="flex items-baseline">
                  <span className="text-base font-medium text-medical-text">
                    {bodyMeasurements.waistCircumference}
                  </span>
                  <span className="ml-1 text-xs text-gray-500">cm</span>
                </div>
              </div>
            </div>
          </div>
          
          <div>
            <h3 className="text-sm font-medium mb-3">Blood Glucose Trend</h3>
            <div className="h-32">
              <ResponsiveContainer width="100%" height="100%">
                <LineChart
                  data={glucoseTrend}
                  margin={{
                    top: 5,
                    right: 10,
                    left: 0,
                    bottom: 5,
                  }}
                >
                  <CartesianGrid strokeDasharray="3 3" vertical={false} />
                  <XAxis dataKey="reading" tick={{ fontSize: 10 }} />
                  <YAxis domain={['dataMin - 10', 'dataMax + 10']} tick={{ fontSize: 10 }} />
                  <Tooltip formatter={(value) => [`${value} mg/dL`, 'Glucose']} />
                  <Line
                    type="monotone"
                    dataKey="value"
                    stroke="#1976d2"
                    strokeWidth={2}
                    dot={{ r: 3 }}
                    activeDot={{ r: 5 }}
                  />
                </LineChart>
              </ResponsiveContainer>
            </div>
          </div>
        </div>
      </CardContent>
    </Card>
  );
}
