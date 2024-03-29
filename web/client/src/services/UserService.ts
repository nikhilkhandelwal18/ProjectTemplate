// UserService.ts

import axios from "../app/axios";
import { User as AuthUser } from "../common/types";
import { UserUrls } from "../common/urls";
import { getBaseUrl } from "../common/helper";

export const fetchUserInfo = async (): Promise<AuthUser> => {
  try {
    getBaseUrl();

    const userResponse = await axios.get<AuthUser>(UserUrls.GetUserInfo);
    return userResponse.data;
  } catch (error) {
    console.error("Error fetching user detail:", error);
    throw error; // Re-throw the error to be caught by the caller
  }
};
