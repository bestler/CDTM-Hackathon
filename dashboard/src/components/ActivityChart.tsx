
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, Cell, TooltipProps } from 'recharts';

interface ActivityChartProps {
  activity: {
    stepCount: number;
    walkingDistance: number;
    runningDistance: number;
    flightsClimbed: number;
    activeEnergyBurned: number;
    exerciseMinutes: number;
    standHours: number;
  };
}

export default function ActivityChart({ activity }: ActivityChartProps) {
  // Prepare data for the chart
  const activityData = [
    { name: 'Steps', value: activity.stepCount, goal: 10000, unit: 'steps', color: '#4299E1' },
    { name: 'Walk', value: activity.walkingDistance, goal: 5, unit: 'km', color: '#48BB78' },
    { name: 'Run', value: activity.runningDistance, goal: 3, unit: 'km', color: '#F6AD55' },
    { name: 'Floors', value: activity.flightsClimbed, goal: 10, unit: 'flights', color: '#9F7AEA' },
    { name: 'Exercise', value: activity.exerciseMinutes, goal: 30, unit: 'min', color: '#ED8936' },
    { name: 'Energy', value: activity.activeEnergyBurned, goal: 400, unit: 'kcal', color: '#ED64A6' },
    { name: 'Stand', value: activity.standHours, goal: 12, unit: 'hours', color: '#38B2AC' },
  ];

  // Calculate goal percentage for each metric
  const normalizedData = activityData.map(item => ({
    ...item,
    percentage: Math.min(100, (item.value / item.goal) * 100)
  }));

  // Custom tooltip for the chart
  const CustomTooltip = ({ active, payload }: TooltipProps<any, any>) => {
    if (active && payload && payload.length) {
      const data = payload[0].payload;
      return (
        <div className="bg-white p-2 border border-gray-200 shadow-md rounded">
          <p className="font-medium">{data.name}</p>
          <p className="text-sm">{data.value} {data.unit} of {data.goal} {data.unit}</p>
          <p className="text-sm font-medium" style={{ color: data.percentage >= 100 ? '#48BB78' : '#4A5568' }}>
            {data.percentage.toFixed(0)}% of goal
          </p>
        </div>
      );
    }
    return null;
  };

  return (
    <Card className="shadow-sm">
      <CardHeader className="pb-2">
        <CardTitle className="text-lg text-medical-primary">Daily Activity</CardTitle>
      </CardHeader>
      <CardContent>
        <div className="h-64">
          <ResponsiveContainer width="100%" height="100%">
            <BarChart
              data={normalizedData}
              margin={{ top: 5, right: 30, left: 0, bottom: 5 }}
            >
              <CartesianGrid strokeDasharray="3 3" vertical={false} />
              <XAxis dataKey="name" tick={{ fontSize: 12 }} />
              <YAxis 
                tickFormatter={(value) => `${value}%`}
                domain={[0, 100]}
                tick={{ fontSize: 12 }}
              />
              <Tooltip content={<CustomTooltip />} />
              <Bar dataKey="percentage" name="Goal Completion">
                {normalizedData.map((entry, index) => (
                  <Cell 
                    key={`cell-${index}`} 
                    fill={entry.percentage >= 100 ? '#48BB78' : entry.color} 
                  />
                ))}
              </Bar>
            </BarChart>
          </ResponsiveContainer>
        </div>
      </CardContent>
    </Card>
  );
}
