import React, { createContext, useCallback, useEffect, useState } from "react";

import axios from "../app/axios";
import { ContextProviderProps } from "./context.types";
import { User as AuthUser } from "../common/types";
import { UserUrls } from "../common/urls";
import { fetchUserInfo } from "../services/UserService";

export type UserContextType = {
  user: AuthUser | null;
  setUser: React.Dispatch<React.SetStateAction<AuthUser | null>>;
};

const UserContext = createContext({} as UserContextType);

const UserContextProvider = ({ children }: ContextProviderProps) => {
  const [user, setUser] = useState<AuthUser | null>(null);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const userInfo: AuthUser = await fetchUserInfo();
        setUser(userInfo);
      } catch (error) {
        console.error("Error fetching about info:", error);
      }
    };

    fetchData();
  }, []);

  return <UserContext.Provider value={{ user, setUser }}>{children}</UserContext.Provider>;
};

export { UserContext, UserContextProvider };
