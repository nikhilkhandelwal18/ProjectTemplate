import axios from "axios";
import { getBaseUrl } from "../../common/helper";

const axiosInstance = axios.create();

// Inject token if available?
axiosInstance.interceptors.request.use((config) => {
  config.baseURL = `${getBaseUrl()}`;

  config.withCredentials = true;

  config.headers["Accept"] = "application/json";
  config.headers["Content-Type"] = "application/json";

  return config;
});

export default axiosInstance;
