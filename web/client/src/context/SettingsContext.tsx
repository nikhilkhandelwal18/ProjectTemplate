import React, {
  createContext,
  useState,
  useEffect,
  ReactNode,
  useContext,
} from "react";

type SettingsContextType = {
  hostEnv?: string;
  apiUrl?: string;
  baseUrl?: string;
};

// Create a context for settings
export const SettingsContext = createContext<{
  settings: SettingsContextType;
  updateSettings: (newSettings: Partial<SettingsContextType>) => void;
}>({
  settings: {
    hostEnv: "",
    apiUrl: "",
    baseUrl: "",
  },
  updateSettings: () => {},
});

type ContextProviderProps = {
  children?: ReactNode;
};

// Create a SettingsProvider component
const SettingsProvider = ({ children }: ContextProviderProps) => {
  const [settings, setSettings] = useState<SettingsContextType>({
    hostEnv: "",
    apiUrl: "",
    baseUrl: "",
  });

  // Function to update settings
  const updateSettings = (newSettings: Partial<SettingsContextType>) => {
    setSettings({ ...settings, ...newSettings });
  };

  useEffect(() => {
    // Fetch initial settings from a JSON file
    let url = `${process.env.PUBLIC_URL}/appSettings.json`;

    fetch(url) // Update the path accordingly
      .then((response) => response.json())
      .then((data: SettingsContextType) => {
        setSettings(data);
      })
      .catch((error) => {
        console.error("Error fetching settings:", error);
      });
  }, []);

  return (
    <SettingsContext.Provider value={{ settings, updateSettings }}>
      {children}
    </SettingsContext.Provider>
  );
};

// Custom hook to access settings
export const useSettings = () => {
  return useContext(SettingsContext);
};

export default SettingsProvider;
