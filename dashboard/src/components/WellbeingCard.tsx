
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { PieChart, Pie, Cell, ResponsiveContainer, Legend, Tooltip } from "recharts";

interface WellbeingCardProps {
  mentalWellbeing: {
    mindfulnessMinutes: number;
    moodTracking: string;
    stressLevel: string;
    anxietyTestResult: string;
    depressionTestResult: string;
  };
  sleep: {
    inBedTime: string;
    asleepTime: string;
    sleepDuration: number;
    sleepStages: {
      core: number;
      deep: number;
      rem: number;
      awake: number;
    };
  };
}

export default function WellbeingCard({ mentalWellbeing, sleep }: WellbeingCardProps) {
  // Prepare data for the sleep pie chart
  const sleepData = [
    { name: "Core Sleep", value: sleep.sleepStages.core, color: "#4299E1" },
    { name: "Deep Sleep", value: sleep.sleepStages.deep, color: "#805AD5" },
    { name: "REM Sleep", value: sleep.sleepStages.rem, color: "#48BB78" },
    { name: "Awake", value: sleep.sleepStages.awake, color: "#F6AD55" },
  ];

  // Map stress level to color
  const getStressColor = (level: string) => {
    const levelMap: Record<string, string> = {
      "Low": "text-green-500",
      "Moderate": "text-yellow-500",
      "High": "text-orange-500",
      "Very High": "text-red-500"
    };
    return levelMap[level] || "text-gray-500";
  };

  // Map mood to color and emoji
  const getMoodInfo = (mood: string) => {
    const moodMap: Record<string, { color: string, emoji: string }> = {
      "Excellent": { color: "text-green-500", emoji: "😄" },
      "Good": { color: "text-green-400", emoji: "🙂" },
      "Fair": { color: "text-yellow-500", emoji: "😐" },
      "Poor": { color: "text-orange-500", emoji: "😕" },
      "Bad": { color: "text-red-500", emoji: "😞" }
    };
    return moodMap[mood] || { color: "text-gray-500", emoji: "❓" };
  };

  const moodInfo = getMoodInfo(mentalWellbeing.moodTracking);

  return (
    <Card className="shadow-sm">
      <CardHeader className="pb-2">
        <CardTitle className="text-lg text-medical-primary">Mental & Sleep Health</CardTitle>
      </CardHeader>
      <CardContent>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          {/* Mental Wellbeing Section */}
          <div>
            <h3 className="text-sm font-medium mb-2">Mental Wellbeing</h3>
            <div className="space-y-3">
              <div className="flex justify-between items-center">
                <span className="text-sm text-gray-600">Mood</span>
                <div className="flex items-center">
                  <span className={`text-sm font-medium ${moodInfo.color} mr-1`}>
                    {mentalWellbeing.moodTracking}
                  </span>
                  <span>{moodInfo.emoji}</span>
                </div>
              </div>
              
              <div className="flex justify-between items-center">
                <span className="text-sm text-gray-600">Stress Level</span>
                <span className={`text-sm font-medium ${getStressColor(mentalWellbeing.stressLevel)}`}>
                  {mentalWellbeing.stressLevel}
                </span>
              </div>
              
              <div className="flex justify-between items-center">
                <span className="text-sm text-gray-600">Anxiety</span>
                <span className="text-sm font-medium text-gray-800">
                  {mentalWellbeing.anxietyTestResult}
                </span>
              </div>
              
              <div className="flex justify-between items-center">
                <span className="text-sm text-gray-600">Depression</span>
                <span className="text-sm font-medium text-gray-800">
                  {mentalWellbeing.depressionTestResult}
                </span>
              </div>
              
              <div className="flex justify-between items-center">
                <span className="text-sm text-gray-600">Mindfulness Practice</span>
                <span className="text-sm font-medium text-gray-800">
                  {mentalWellbeing.mindfulnessMinutes} minutes/day
                </span>
              </div>
            </div>
          </div>
          
          {/* Sleep Section */}
          <div>
            <div className="flex justify-between items-center mb-2">
              <h3 className="text-sm font-medium">Sleep Analysis</h3>
              <span className="text-sm font-medium text-medical-primary">
                {sleep.sleepDuration} hrs
              </span>
            </div>
            
            <div className="h-36">
              <ResponsiveContainer width="100%" height="100%">
                <PieChart>
                  <Pie
                    data={sleepData}
                    cx="50%"
                    cy="50%"
                    innerRadius={40}
                    outerRadius={60}
                    paddingAngle={2}
                    dataKey="value"
                  >
                    {sleepData.map((entry, index) => (
                      <Cell key={`cell-${index}`} fill={entry.color} />
                    ))}
                  </Pie>
                  <Legend 
                    layout="vertical" 
                    verticalAlign="middle" 
                    align="right"
                    formatter={(value) => {
                      return <span className="text-xs">{value}</span>;
                    }}
                  />
                  <Tooltip 
                    formatter={(value) => [`${value} hours`, '']}
                  />
                </PieChart>
              </ResponsiveContainer>
            </div>
            
            <div className="flex justify-between items-center text-xs text-gray-500 mt-2">
              <span>Bedtime: {sleep.inBedTime}</span>
              <span>Fell asleep: {sleep.asleepTime}</span>
            </div>
          </div>
        </div>
      </CardContent>
    </Card>
  );
}
