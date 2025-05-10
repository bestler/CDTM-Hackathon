
import { ReactNode } from 'react';
import { SidebarProvider, Sidebar, SidebarContent, SidebarTrigger } from '@/components/ui/sidebar';
import { Button } from '@/components/ui/button';
import { useToast } from "@/hooks/use-toast";
import { FileJson, Download, Settings } from 'lucide-react';

interface DashboardLayoutProps {
  children: ReactNode;
  patientName: string;
  data: any;
}

export default function DashboardLayout({ children, patientName, data }: DashboardLayoutProps) {
  const { toast } = useToast();

  const exportData = () => {
    try {
      // Create a JSON blob and download it
      const jsonString = JSON.stringify(data, null, 2);
      const blob = new Blob([jsonString], { type: 'application/json' });
      const url = URL.createObjectURL(blob);
      
      // Create a link element and trigger download
      const link = document.createElement('a');
      link.href = url;
      link.download = `${patientName.replace(/\s+/g, '_')}_medical_data.json`;
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
      URL.revokeObjectURL(url);

      toast({
        title: "Data Exported Successfully",
        description: `${patientName}'s data has been exported as JSON`,
      });
    } catch (error) {
      toast({
        title: "Export Failed",
        description: "There was an error exporting the data",
        variant: "destructive",
      });
      console.error("Export error:", error);
    }
  };

  return (
    <div className="min-h-screen bg-medical-background">
      <SidebarProvider>
        <div className="min-h-screen flex w-full">
          <Sidebar className="bg-white border-r border-gray-200 shadow-sm">
            <SidebarContent className="p-4">
              <div className="space-y-4">
                <h2 className="text-xl font-semibold text-medical-primary">MedDashboard</h2>
                <div className="py-2">
                  <div className="space-y-1">
                    <Button variant="ghost" className="w-full justify-start">
                      <FileJson className="mr-2 h-4 w-4" />
                      Patient Overview
                    </Button>
                    <Button variant="ghost" className="w-full justify-start mt-2">
                      <Settings className="mr-2 h-4 w-4" />
                    Settings
                  </Button>
                  </div>
                </div>
              </div>
            </SidebarContent>
          </Sidebar>

          <div className="flex-1 flex flex-col">
            <header className="bg-white shadow-sm border-b border-gray-200">
              <div className="flex justify-between items-center px-4 py-4 sm:px-6 lg:px-8">
                <div className="flex items-center">
                  <SidebarTrigger />
                  <h1 className="ml-4 text-2xl font-semibold text-medical-text">
                    Patient Overview
                  </h1>
                </div>
                <Button 
                  className="bg-medical-primary hover:bg-medical-primary/90"
                  onClick={exportData}
                >
                  <Download className="mr-2 h-4 w-4" />
                  Export Data
                </Button>
              </div>
            </header>

            <main className="flex-1 overflow-auto p-6">{children}</main>
          </div>
        </div>
      </SidebarProvider>
    </div>
  );
}
