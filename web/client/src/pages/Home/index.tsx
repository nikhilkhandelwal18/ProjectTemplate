import React, { useEffect, useState } from "react";
import axios from "../../app/axios";
import { connectionResult, log4NetAppender } from "../../common/types";
import LoggedInUser from "../../components/User";

const Home = () => {
  const [apiStatus, setApiStatus] = useState<boolean>(false);
  const [log4netStatus, setLog4netStatus] = useState<log4NetAppender[] | null>([]);
  const [log4NetStatusCode, setLog4NetStatusCode] = useState<number>(204);
  const [connectionStatus, setConnectionStatus] = useState([]);

  const checkApiConnection = async () => {
    try {
      const response = await axios.get("status/apistatus");
      console.log(response);
      if (response.status === 200) {
        setApiStatus(true);
      } else {
        setApiStatus(false);
      }
    } catch (error) {
      console.error("Error connecting to API:", error);
      setApiStatus(false);
    }
  };

  const validateLog4netFile = async () => {
    try {
      const response = await axios.get("status/log4net");
      if (response.status === 200) {
        setLog4netStatus(response.data);
        setLog4NetStatusCode(200);
      } else {
        setLog4NetStatusCode(204);
      }
    } catch (error) {
      console.error("Error validating Log4net file:", error);
    }
  };

  const fetchConnectionStatus = async () => {
    try {
      const response = await axios.get("status/dbconnection");
      setConnectionStatus(response.data);
    } catch (error) {
      console.error("Error fetching connection status:", error);
    }
  };

  useEffect(() => {
    // Check the status of the API and log
    checkApiConnection();
    validateLog4netFile();
    fetchConnectionStatus();
  }, []);

  return (
    <div>
      <h1 style={{ textAlign: "center" }}>CI-CD DEMO - HOME PAGE</h1>
      <h2>User Detail</h2>
      <LoggedInUser />
      <h2>API Status</h2>
      <p>
        API Status: <span style={{ textAlign: "center", fontWeight: "bold", color: apiStatus ? "green" : "red" }}>{JSON.stringify(apiStatus)}</span>{" "}
      </p>
      <h2>Log4net Files</h2>
      {!!log4NetStatusCode && log4NetStatusCode === 200 && !!log4netStatus && (
        <>
          <table style={{ margin: "auto", textAlign: "center" }}>
            <thead>
              <tr>
                <th style={{ textAlign: "left" }}>Name</th>
                <th style={{ textAlign: "left" }}>Log File Path</th>
                <th style={{ textAlign: "center" }}>File Path Exists</th>
              </tr>
            </thead>
            <tbody>
              {log4netStatus.map((l, index) => (
                <tr key={index}>
                  <td style={{ textAlign: "left" }}>{l.name}</td>
                  <td style={{ textAlign: "left" }}>{l.logFilePath}</td>
                  <td style={{ textAlign: "center", fontWeight: "bold", color: l.filePathExists ? "green" : "red" }}>{JSON.stringify(l.filePathExists)}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </>
      )}
      {!!log4NetStatusCode && log4NetStatusCode !== 200 && <>No Log File Found </>}
      <h2>Database Connection Check</h2>
      {!!connectionStatus && (
        <>
          <table style={{ margin: "auto", textAlign: "center", width: "50%" }}>
            <thead>
              <tr>
                <th style={{ textAlign: "left" }}>Database</th>
                <th style={{ textAlign: "left" }}>Server</th>
                <th style={{ textAlign: "center" }}>Connection State</th>
              </tr>
            </thead>
            <tbody>
              {connectionStatus.map((connection: connectionResult) => (
                <tr key={`${connection.server}-${connection.database}`}>
                  <td style={{ textAlign: "left" }}>{connection.database}</td>
                  <td style={{ textAlign: "left" }}>{connection.server}</td>
                  <td style={{ textAlign: "center", fontWeight: "bold", color: connection.state === "Pass" ? "green" : "red" }}>{connection.state}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </>
      )}
    </div>
  );
};

export default Home;
