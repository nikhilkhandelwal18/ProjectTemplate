import { APP_ENV } from "./constants";

export const isLOCALEnv = () => {
  return !!process.env.REACT_APP_HOST_ENV && process.env.REACT_APP_HOST_ENV.toUpperCase() === APP_ENV.LOCAL;
};

export const isDEVEnv = () => {
  return !!process.env.REACT_APP_HOST_ENV && process.env.REACT_APP_HOST_ENV.toUpperCase() === APP_ENV.DEV;
};

export const isPRODEnv = () => {
  return !!process.env.REACT_APP_HOST_ENV && process.env.REACT_APP_HOST_ENV.toUpperCase() === APP_ENV.PROD;
};

export const getBaseUrl = () => {
  let hostName = window.location.hostname;
  let origin = window.location.origin;
  if (hostName === "localhost" && origin.includes("localhost")) {
    return "http://localhost:3001/api";
  } else {
    return `${origin}/api`;
  }
};
